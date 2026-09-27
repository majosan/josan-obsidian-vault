# 📋 任务板

传感前锋在这里发 task，Claude Code 机器认领执行。

## Task 格式

每个 task 是一个 markdown 文件，命名规范：

```
T<序号>-<机器代号>-<简短描述>.md
```

**机器代号：**
- `WS` — 公司台式 (workstation)
- `LP` — 笔记本 (laptop)
- `HM` — 家里台式 (home)
- `ALL` — 任意机器

**示例：**

```markdown
# T001-WS-数据分析脚本
- 状态: ⏳ 待认领  |  ✅ 已完成  |  🔄 执行中  |  ❌ 已取消
- 认领人: (空/公司台式/笔记本/家里台式)
- 优先级: ⭐⭐⭐

## 任务描述
...

## 产出要求
- 文件保存到: `data/xxx/`
- 需提交内容: xxx

## 备注
...
```

---

## 📦 历史任务归档（2026-09-27 整理）

早期这批执行任务（主要围绕 **LabVLA 环境搭建 / MuJoCo 闭环 / 触觉数据注入**）已跑完或过时，**已归档到对应项目目录下的 `任务归档/`**：

| 任务 | 内容 | 归档位置 |
|---|---|---|
| T001-WS-DataAnalysisScriptInit | 触觉手套数据分析脚本骨架 | `02-触觉传感器/柔性触觉手套/任务归档/` |
| T002-LP-Sample-LabVLATest | 笔记本 LabVLA 冒烟测试 | `01-AI化学实验室/项目实施/任务归档/` |
| T003-HM-SetupLabVLAEnv | 家里台式搭 `labvla-cu124` 环境 | `01-AI化学实验室/项目实施/任务归档/` |
| T004-HM-Phase1-LabVLA-Verification | 家里台式 Phase 1 验证 | `01-AI化学实验室/项目实施/任务归档/` |
| T003-WS-Phase2-MuJoCoLabVLAClosedLoop | MuJoCo + LabVLA 闭环（Phase 2） | `04-实验室自动化/任务归档/` |
| T005-WS-TactileDataInjection | 触觉数据注入验证 | `04-实验室自动化/任务归档/` |
| T006-WS-TactileHeatmapViz | 触觉热力图可视化 | `04-实验室自动化/任务归档/` |

> 本目录（`tasks/`）保留为**任务板机制说明**；后续新任务仍按上方格式在这里创建。
