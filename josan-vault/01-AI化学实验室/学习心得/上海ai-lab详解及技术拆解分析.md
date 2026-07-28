# ⚡ 从头到脚拆解：自然语言 → 仿真执行 → 训练数据

用你场景里最经典的操作来串——**「将A烧杯液体倒入B烧杯并加热」**。

---

## 第一步：自然语言 → 工作流（Workflow）

输入的是一条实验指令：

> **"将A烧杯液体倒入B烧杯并加热"**

RoboGenesis 的**工作流引擎**会做第一层翻译：把自然语言映射成**原子技能序列**。

映射结果：

Copy

```
语言指令 → 拆解为步骤数组（YAML配置）：

workflow:
  language_instruction: "将A烧杯液体倒入B烧杯并加热"
  scene_objects:
    - name: "source_beaker"    ← 场景中的物体A
      path: "/World/beaker_A"
      position_range:          ← 随机化范围（位置可变）
        x: [0.20, 0.28]        # 每次reset随机放
        y: [0.05, 0.12]
        z: [0.06, 0.065]
    - name: "target_beaker"    ← 场景中的物体B
      path: "/World/beaker_B"
      position_range:
        x: [0.35, 0.45]
        y: [-0.10, 0.05]
        z: [0.06, 0.065]
    - name: "hotplate"        ← 加热台
      path: "/World/hotplate"
      position_range:
        x: [0.50, 0.55]
        y: [-0.05, 0.05]
        z: [0.04, 0.05]

  steps:                        ← 关键！原子技能组合
    - skill: "pick"             # 第1步：抓取A烧杯
      target_object: "source_beaker"
    - skill: "pour"             # 第2步：倒入B烧杯
      target_object: "target_beaker"
    - skill: "place"            # 第3步：把A烧杯放回
      target_object: "source_beaker"
    - skill: "pressZ"           # 第4步：按压加热开关
      target_object: "hotplate"
```

这个 YAML 就是**工作流配置文件**，放在 `config/workflows/` 下。

---

## 第二步：原子技能 → 状态机执行

每个原子技能都是一个**多阶段状态机**。以 **pick（抓取）** 为例，它有 **7个阶段**：

Copy

```
pick 的7个阶段（一个接一个自动推进）：

阶段0: █░░░░░░░░░  移动到目标上方（预抓取偏移）
阶段1: ██░░░░░░░░  水平接近修正
阶段2: ███░░░░░░░  下降到抓取位
阶段3: ████░░░░░░  等待物理稳定（等物体不晃了）
阶段4: █████░░░░░  闭合夹爪（抓！）
阶段5: ██████░░░░  抬升物体到安全高度
阶段6: ███████░░░  完成
```

每个阶段的**推进速度**由 `events_dt` 控制：

Copy

```python
# pick 的默认 events_dt
events_dt = [0.002, 0.002, 0.005, 0.02, 0.08, 0.01, 0.02]
#          阶段0   阶段1   阶段2   阶段3   阶段4   阶段5   阶段6
# 数值越小→这个阶段走得越慢→动作越保守
# 比如阶段4(抓取)要0.08/帧→走得慢→夹爪闭合很稳
# 阶段0(移动)只要0.002/帧→走得快→快速到位
```

**底层执行机制**（伪代码）：

Copy

```python
class SkillController:
    def __init__(self, events_dt):
        self._event = 0          # 当前在第几个阶段
        self._t = 0.0            # 当前阶段的进度（0→1）
        self._events_dt = events_dt  # 每帧推进多少

    def forward(self, obs):
        if self._event == 0:
            # 阶段0：移动到目标上方
            action = move_to_pregrasp_pose(obs)
        elif self._event == 1:
            # 阶段1：水平修正
            action = horizontal_adjust(obs)
        elif self._event == 2:
            # 阶段2：下降到抓取位
            action = descend_to_grasp(obs)
        elif self._event == 3:
            # 阶段3：等稳定（不动作）
            action = None  # wait
        elif self._event == 4:
            # 阶段4：闭合夹爪
            action = close_gripper()
        elif self._event == 5:
            # 阶段5：抬升
            action = lift_up(obs)
        # ...

        # 推进进度
        self._t += self._events_dt[self._event]
        if self._t >= 1.0:
            self._event += 1     # 进入下一阶段
            self._t = 0.0

    def is_done(self):
        return self._event >= len(self._events_dt)  # 所有阶段完成
```

**阶段推进的直观演示**（一个 pick 动作，每帧推进）：

Copy

```
帧 1:  _t=0.002  阶段0 → 机械臂开始向目标移动
帧 2:  _t=0.004  阶段0 → 继续移动
  ...
帧 500: _t=1.0 → 阶段0完成，进入阶段1
帧 501: _t=0.002  阶段1 → 水平修正
  ...
帧 1000: _t=1.0 → 阶段1完成，进入阶段2（下降）
帧 1001: _t=0.005  阶段2 → 开始下降
  ...
帧 1200: _t=1.0 → 阶段2完成，进入阶段3（等稳定）
帧 1201: _t=0.02  阶段3 → 等0.02/帧 → 大概等50帧（约1秒）
  ...
帧 1300: 阶段4 → 夹爪闭合（_t=0.08，走得最慢→最稳）
  ...
帧 1400: 阶段5 → 抬升
帧 1500: 阶段6 → 完成

整个 pick 动作大约跑了 1500 帧 ≈ 75-100 模拟步
```

---

## 第三步：pour（倒液）的详细执行

倒液比抓取复杂，因为涉及**液体物理**。pour 的 **6个阶段**：

Copy

```
pour:
  阶段0: ██░░░░░░░  移动到目标（B烧杯）上方
  阶段1: ████░░░░░  精调位置和高度
  阶段2: ██████░░░  切换手腕到速度模式 → 开始倒液！（关键）
  阶段3: ████████░  保持倾倒姿态，液体流出
  阶段4: █████████░  反向回正
  阶段5: ██████████  保持并结束
```

**阶段2-4 的腕关节控制**特别关键：

Copy

```python
# 阶段2：倒液
wrist_velocity = -pour_speed  # 例如 pour_speed=-1 → 手腕以-1 rad/s旋转
# 烧杯倾斜 → 液体流出 → MuJoCo物理引擎模拟液滴下落

# 阶段3：保持
wrist_velocity = 0  # 保持角度，液体持续流出

# 阶段4：回正
wrist_velocity = +pour_speed  # 手腕回正
```

这里的 `end_effector_euler: [0, 90, 30]` 控制机械臂末端姿态，而手腕专门负责倾倒角度。

---

## 第四步：随机化 → 生成泛化数据

关键来了——**RoboGenesis 不是执行一次就完，而是批量化自动随机执行**：

Copy

```
每次 reset，以下随机变化：

场景物体位置随机化：
  source_beaker.x ∈ [0.20, 0.28]  ← 烧杯每次在不同位置
  target_beaker.x ∈ [0.35, 0.45]
  hotplate.x ∈ [0.50, 0.55]

光照随机化：
  光源角度/强度随机变化

相机位置随机化：
  视角略有不同

视觉属性随机化：
  烧杯颜色、桌面纹理、背景杂物
  
技能参数随机化：
  pour_speed 在 [-1.2, -0.8] 之间随机
  gripper_distance 在 [0.02, 0.03] 之间随机
```

**效果**：同一个工作流跑 1000 次，产生 1000 条**场景略有不同但操作相同**的轨迹。这就是 LabVLA 泛化能力（ID 71.1% → OOD 70.0%）的基石。

---

## 第五步：结构化训练数据的产出

每次执行，系统记录的是**这样的数据**：

Copy

```python
# 单条轨迹文件（格式：LeRobot Dataset / HDF5）
{
  "episode_index": 42,          # 第42条轨迹
  "task": "pick_pour_heat",    # 任务名称
  "language_instruction": "将A烧杯液体倒入B烧杯并加热",
  
  # 时间序列（每帧的数据）
  "observations": [
    {
      "timestamp": 0.0,
      # 图像（每帧一张）
      "images.camera_0":           <RGB: 640×480×3>,
      "images.camera_1":           <RGB: 640×480×3>,
      "images.wrist_camera":       <RGB: 640×480×3>,
      
      # 机器人状态
      "state.joint_positions":     [0.1, -0.3, 0.5, ...],    # 7自由度关节角
      "state.gripper_position":    0.02,                      # 夹爪开合度
      "state.end_effector_pose":   [x, y, z, roll, pitch, yaw],
      
      # 场景物体位姿
      "scene.source_beaker_pose":  [0.25, 0.08, 0.06],
      "scene.target_beaker_pose":  [0.38, -0.02, 0.06],
      
      # 液体状态（MuJoCo仿真信息）
      "liquid.volume_source":      0.8,       # A烧杯剩余80%
      "liquid.volume_target":      0.2,       # B烧杯已有20%
    },
    {
      "timestamp": 0.033,        # 下一帧（约30fps）
      # ... 完整的观测数据
    },
    # ... 一直到任务完成（约500-2000帧）
  ],
  
  # 动作（与观测一一对应）
  "actions": [
    {
      "joint_velocities":    [0.01, -0.02, ...],  # 关节速度指令
      "gripper_command":     0.0,                  # 夹爪指令
      "wrist_velocity":      0.0,                  # 手腕速度
    },
    # ... 每帧一个动作
  ],
  
  # 元信息
  "success": True,              # 任务是否成功
  "skill_sequence": ["pick", "pour", "place", "pressZ"],
  "robot_type": "franka",
  "total_frames": 1842,
}
```

**关键：这个数据格式和 LabVLA/VLA 模型训练管线直接兼容**。你可以直接用这个数据训练 LabVLA。

---

## 完整的数据流转图

Copy

```
自然语言指令
"将A烧杯液体倒入B烧杯并加热"
        │
        ▼
  ┌─────────────────────────────────┐
  │  RoboGenesis 工作流引擎          │
  │                                 │
  │  ① 语言→YAML工作流配置           │
  │    steps:                        │
  │      - pick (source_beaker)     │
  │      - pour (target_beaker)     │
  │      - place (source_beaker)    │
  │      - pressZ (hotplate)        │
  │                                 │
  │  ② 场景实例化 + 随机化           │
  │    位置随机 / 光照随机 / 颜色随机 │
  │                                 │
  │  ③ 逐技能状态机执行              │
  │    pick: 阶段0→1→2→...→6        │
  │    pour: 阶段0→1→2→...→5        │
  │    ...                          │
  │                                 │
  │  ④ 每帧记录完整数据              │
  │    图像+状态+动作 → HDF5文件    │
  └──────────┬──────────────────────┘
             │
             ▼
  ┌─────────────────────────────────┐
  │  结构化训练数据 (LabEmbodied-Data)│
  │                                 │
  │  dataset/                       │
  │  ├── episode_000.hdf5           │
  │  ├── episode_001.hdf5           │
  │  ├── ...                        │
  │  ├── episode_999.hdf5           │
  │  ├── meta/                      │
  │  │   ├── stats.json             │
  │  │   ├── task.json              │
  │  │   └── skill_vocab.json       │
  │  └── dataset_info.json          │
  └──────────┬──────────────────────┘
             │
             ▼
  ┌─────────────────────────────────┐
  │  LabVLA 模型训练                │
  │                                 │
  │  阶段1: 大规模预训练              │
  │    Qwen3-VL + 动作token → 理解动作│
  │                                 │
  │  阶段2: 知识隔离后训练             │
  │    DiT动作专家 + 实验室数据       │
  │                                 │
  │  阶段3: 任务微调                  │
  │    你的具体实验场景数据            │
  └─────────────────────────────────┘
             │
             ▼
       部署到真实机器人
```

---

## 对应到你的 8 种操作

RoboGenesis 内置了 11 种原子技能，和你列的 8 种高度匹配：

|你的操作|RoboGenesis 原子技能|状态机阶段数|核心参数|
|---|---|---|---|
|① 抓取烧杯/试管/量筒|**pick**|7|pre_offset, gripper_distances|
|② 倾倒液体|**pour**|6|pour_speed, height_range|
|③ 插入（移液枪头/探头）|**pressZ**|3-4|press_z_tcp_offset|
|④ 旋转（瓶盖/旋钮）|需自定义（类似open的弧线插值）|—|angle, arc_interpolation|
|⑤ 按压（移液枪/按钮）|**press** / **pressZ**|3|press_distance|
|⑥ 滑动（沿实验台）|**move**|无固定阶段|position_threshold|
|⑦ 擦拭（清洁/涂抹）|需自定义（结合move+stir）|—|—|
|⑧ 夹取（镊子取物）|**pick**（小物体适配）|7|gripper_distances更小|

其中 **④旋转** 和 **⑦擦拭** 需要自定义新的原子技能。但框架是现成的——写一个新的状态机控制器，注册到 `skill_registry.py` 就行。

---

## 最实在的建议

**与其从零开始造 RoboGenesis，不如直接 fork 他们的代码库**：

Copy

```
RoboGenesis 仓库：https://github.com/Ylr9933/RoboGenesis
（浙大自己维护的，和 LabVLA 配套）
```

你们要做的改动：

1. **加 2 个自定义原子技能**（旋转瓶盖 + 擦拭动作）
2. **注册你们的化实验场景**（烧杯规格、移液枪型号、实验台布局）
3. **接入触觉手套数据**（RoboGenesis 目前没做触觉，这是你们的创新点）
4. **跑仿真数据生成** → 以此预训练 LabVLA

这样核心工作量不在"从零搭一个仿真引擎"，而在**定义你们的原子技能和场景资产**。