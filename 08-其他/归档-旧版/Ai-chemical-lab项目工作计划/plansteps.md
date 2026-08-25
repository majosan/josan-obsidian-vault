好，第一步不是先下载模型（那是第 1b 步）。正确顺序是：

**1a → 先搭建环境 + clone 代码**（今天能搞定）  
**1b → 再下载 9.5GB 模型 + 量化推理测试**（看网速，下载可能要一阵）

你先在 VSCode 里建好项目文件夹，然后我给你第一条可以直接丢给 Claude Code 的提示词。

---

## 项目结构建议

Copy

```
~/projects/labvla-mujoco/     ← VSCode 项目根目录
├── LabVLA/                   ← git clone 的官方代码（不动它）
├── scripts/                  ← 你自己的脚本放这里
│   ├── test_client.py
│   └── infer_quantized.py
└── LabVLA-5B-Base/           ← 下载的模型权重（大的在这里）
```

建议先在 VSCode 创建 `labvla-mujoco` 文件夹，然后在里面打开终端，**一条一条执行**以下命令先建环境和 clone：

Copy

```bash
# 1. 克隆 LabVLA 官方代码
git clone https://github.com/zjunlp/LabVLA.git

# 2. 创建 conda 环境
conda create -n labvla python=3.10 -y
conda activate labvla

# 3. 装 PyTorch + CUDA
pip install torch==2.7.1 torchvision==0.22.1 --index-url https://download.pytorch.org/whl/cu126

# 4. 装 FlashAttention（编译要几分钟，耐心等）
pip install flash_attn==2.8.3 --no-build-isolation

# 5. 装 LabVLA 其他依赖
cd LabVLA
pip install -r requirements.txt

# 6. 装 bitsandbytes（用于 4-bit 量化——这个是关键，有了它 RTX 4060 8GB 才能跑）
pip install bitsandbytes
```

这些跑完后，再把下面这个提示词丢给 Claude Code：

---

## 📝 第一条 Claude Code 提示词

Copy

```
我正在 ~/projects/labvla-mujoco/ 目录下搭建 LabVLA 的量化推理实验。

## 已完成
- LabVLA 官方代码已 clone 到 ./LabVLA/
- conda 环境 labvla (Python 3.10) 已创建
- PyTorch 2.7.1 + CUDA 12.6 + FlashAttention 2.8.3 已安装
- LabVLA 依赖已从 requirements.txt 安装
- bitsandbytes 已安装
- 我的 GPU 是 NVIDIA RTX 4060 (8GB VRAM)

## 需要你做的工作

### 1. 下载模型（在 ./scripts/ 目录运行）
创建一个下载脚本 `download_model.sh`，用 huggingface-cli 下载 `zjunlp/LabVLA-5B-Base` 到 `./LabVLA-5B-Base/` 目录。

### 2. 写一个量化推理测试脚本 `scripts/infer_quantized.py`
这个脚本要做：
a) 用 bitsandbytes 4-bit 量化加载 LabVLA-5B-Base 模型（用 transformers 的 AutoModelForCausalLM + BitsAndBytesConfig，load_in_4bit=True，bnb_4bit_compute_dtype=float16，bnb_4bit_use_double_quant=True）
b) 用 Qwen3-VL 的 processor 处理一个简单的输入：
   - 一张随机生成的 224x224 占位图像（用 numpy 生成随机像素，转成 PIL Image）
   - 文本： "pick up the beaker on the table"
c) 跑一次推理，打印输出 token 的前 20 个
d) 打印显存占用峰值

### 3. 写一个 WebSocket 测试客户端 `scripts/test_client.py`
这个脚本模拟 LabUtopia 的观测发送协议：
a) 连接到 ws://localhost:8000
b) 接收服务端发来的 metadata（遵循 openpi_client 的 msgpack 协议）
c) 构造一个假的观测字典：
   ```python
   obs = {
       "camera_1_rgb": np.random.randint(0, 256, (224, 224, 3), dtype=np.uint8),
       "camera_2_rgb": np.random.randint(0, 256, (224, 224, 3), dtype=np.uint8),
       "camera_3_rgb": np.random.randint(0, 256, (224, 224, 3), dtype=np.uint8),
       "state": np.zeros(8, dtype=np.float32),
       "prompt": "pick up the beaker"
   }
```

d) 用 msgpack（兼容 numpy 的序列化）发送  
e) 接收 action 回复，打印 action 的形状和数值范围

### 4. 修改部署代码支持量化（关键）

LabVLA 的 `deployment/serve_labvla.py` 中的 `LabVLALabUtopiaPolicy` 默认用 FP16 加载模型。  
你的 RTX 4060 只有 8GB 显存，FP16 加载 ~10GB 会 OOM。

请做以下修改（复制一份到 `scripts/serve_labvla_4bit.py`）：

- 在模型加载部分加入 BitsAndBytesConfig 的 4-bit 量化参数
- 确保 model.to(device) 和 model.eval() 正确
- 其他推理逻辑保持不变

### 注意

- 所有新建脚本放在 ./scripts/ 目录下
- 保持 LabVLA/ 目录（官方代码）不被修改
- 使用 conda 的 labvla 环境
- 如果下载模型中途断掉，可以用 huggingface-cli 的 --resume-download
- 先测试 infer_quantized.py 确认量化加载成功，再跑 serve 和 client

Copy

```

---

环境搭好 + 提示词丢进去后，Claude Code 会一步步完成。**下载 9.5GB 模型可能要等半小时到一小时**（看网速）。

跑通 `infer_quantized.py` 看到类似这样的输出就算成功了：
```

模型加载成功！显存占用：5.2 GB / 8 GB  
输入: pick up the beaker on the table  
输出 token: [...]