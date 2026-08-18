# CH4 从零搭 GPT 模型 — 预习笔记

> 教材：[rasbt/LLMs-from-scratch](https://github.com/rasbt/LLMs-from-scratch)
> 状态：📖 预习中

---

## 一、一句话概括 CH4

CH3 教会你"注意力怎么算"——CH4 把 CH2（词嵌入）+ CH3（注意力）**组装成一个完整的、能生成文本的 GPT 模型**。

可以这么想：
- CH2 = 造砖（token → embedding）
- CH3 = 发明水泥（self-attention，砖跟砖怎么连通）
- **CH4 = 砌墙**（把砖和水泥一层层叠起来，搭出整面墙）

---

## 二、CH4 核心知识模块

```
┌──────────────────────────────────────────────────────┐
│              GPT 模型 = 以下组件堆叠 N 次             │
├──────────────────────────────────────────────────────┤
│                                                      │
│  输入文本                                              │
│    ↓                                                 │
│  ① Token Embedding     ← CH2 已学：词表大小→d_model  │
│  ② Positional Embedding ← 位置编码，让模型知道顺序    │
│    ↓                                                 │
│  ┌─────────────────────────┐                         │
│  │ ③ Transformer Block ×N  │ ← N=12（GPT-2小模型）   │
│  │  ┌───────────────────┐  │                         │
│  │  │ LayerNorm         │  │ ← 归一化，稳定训练      │
│  │  │ ↓                 │  │                         │
│  │  │ Multi-Head        │  │ ← CH3 已学              │
│  │  │ Self-Attention    │  │                         │
│  │  │ ↓ (+) Shortcut ──→│  │ ← 残差连接（关键！）     │
│  │  │ LayerNorm         │  │                         │
│  │  │ ↓                 │  │                         │
│  │  │ FeedForward (FFN) │  │ ← 两层全连接 + GELU     │
│  │  │ ↓ (+) Shortcut ──→│  │ ← 又一个残差             │
│  │  └───────────────────┘  │                         │
│  └─────────────────────────┘                         │
│    ↓                                                 │
│  ④ Final LayerNorm                                    │
│    ↓                                                 │
│  ⑤ Output Head (Linear) → Logits → next token        │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### 2.1 Transformer Block（本章组装的核心单元）

每个 Block 包含两个子层，**各自前面有 LayerNorm，后面有残差连接（Shortcut）**：

```
x → LayerNorm → MultiHeadAttention → + x（残差）→ LayerNorm → FFN → + 残差 → 输出
```

**CH4 的新东西不是 Attention（CH3 已会），而是"怎么把 Attention 装进 Block 里跑"：**

| 组件 | 作用 | 一句话理解 |
|------|------|-----------|
| **LayerNorm** | 把每层的输出"拉平"到均值为0、标准差为1 | 像调音量——防止数值爆炸，让深网络能稳定训练 |
| **残差连接（Shortcut/Residual）** | 输入直接跳过子层，加到输出上 | **为什么不直接跳过？** 没有它，深层网络的梯度会"消失"（链式求导时越乘越小），残差给了梯度一条"高速公路" |
| **FeedForward (FFN)** | 两层全连接，中间加 GELU 激活 | Attention 负责"看全局关系"，FFN 负责"非线性变换"——两者分工 |
| **GELU 激活函数** | 比 ReLU 更平滑的高斯误差线性单元 | 给 FFN 提供非线性；为什么 GPT 选 GELU 不选 ReLU？因为 GELU 平滑、可导，适合大模型训练 |
| **Dropout** | 训练时随机丢弃一些神经元 | 防过拟合的开关，只在训练时用，推理时关掉 |

### 2.2 整体 GPT 模型结构

```python
# 伪代码 —— CH4 的核心就是在写这个类
class GPTModel(nn.Module):
    def __init__(self, vocab_size, d_model, n_heads, n_layers, context_length):
        # ① Token + Positional Embedding
        self.tok_emb = nn.Embedding(vocab_size, d_model)
        self.pos_emb = nn.Embedding(context_length, d_model)   # 可学习的位置编码
        self.drop_emb = nn.Dropout(drop_rate)

        # ③ N 层 TransformerBlock（重复堆叠）
        self.blocks = nn.Sequential(*[TransformerBlock(...) for _ in range(n_layers)])

        # ④ Final LayerNorm
        self.final_ln = nn.LayerNorm(d_model)
        
        # ⑤ 输出头：把 d_model 映射回词表大小（每个词一个 logit）
        self.out_head = nn.Linear(d_model, vocab_size)

    def forward(self, x):
        # ① 嵌入
        tok_embeds = self.tok_emb(x)              # (batch, seq_len, d_model)
        pos_embeds = self.pos_emb(positions)       # (batch, seq_len, d_model)
        x = tok_embeds + pos_embeds                # 相加（不是拼接！）
        x = self.drop_emb(x)
        # ③ 过 N 个 Transformer Block
        x = self.blocks(x)
        # ④ Final LayerNorm
        x = self.final_ln(x)
        # ⑤ 输出 Logits
        logits = self.out_head(x)                  # (batch, seq_len, vocab_size)
        return logits
```

### 2.3 因果掩码（Causal Mask / Attention Mask）

GPT 是**自回归**的：生成第 t 个 token 时，只能看到前面的 1~t-1 个 token，不能偷看后面的（"未来"）。

```python
# 因果掩码是一个下三角矩阵：能看到自己及左边的，右边全都 -∞（softmax 后变 0）
context_length = 6
mask = torch.tril(torch.ones(context_length, context_length))  # 下三角全1
mask = mask.masked_fill(mask == 0, -float('inf'))              # 上三角 → -∞

# 结果示意（6×6）：
# 0  -∞ -∞ -∞ -∞ -∞      位置1只能看到自己
# 0   0 -∞ -∞ -∞ -∞      位置2能看到1和2
# 0   0  0 -∞ -∞ -∞      
# 0   0  0  0 -∞ -∞      
# 0   0  0  0  0 -∞      
# 0   0  0  0  0  0      位置6能看到全部
```

这个掩码在 **Attention 计算 scores 之后、softmax 之前**加进去。

---

## 三、CH4 跟之前 CH2、CH3 的关系

```
            CH2 作业                      CH3 作业                     CH4 作业
        ┌─────────────┐            ┌──────────────┐           ┌──────────────┐
文本 ──→│ Tokenizer    │──→ tokens ──→             │           │              │
        │ (BPE 分词)   │           │              │           │              │
        ├─────────────┤           │ Multi-Head   │           │ GPT Model    │──→ logits
        │ Token Embed  │──→ dims   │ Attention    │──→ 新的  │ (N层堆叠)     │     → next token
        ├─────────────┤           │ (+残差+LN)   │    表征   │              │
        │ Pos Embed    │──→ dims   │              │           │              │
        └─────────────┘           └──────────────┘           └──────────────┘
              ↑                          ↑                         ↑
          CH4 会把它俩                   CH4 会把注意               CH4 的成品
          直接嵌进模型里              力装进Block里              是一个能跑的GPT
```

一句话：**CH2 处理输入端，CH3 提供运算逻辑，CH4 把它们拧成一台完整的机器。**

---

## 四、CH4 你需要"看懂就行"的公式（不要求推导）

### 4.1 LayerNorm

$$\text{LayerNorm}(x) = \gamma \cdot \frac{x - \mu}{\sigma} + \beta$$

- $\mu$ = 均值，$\sigma$ = 标准差（沿最后一个维度，即 `d_model` 方向算）
- $\gamma$, $\beta$ = 可学习的缩放/偏移参数
- **直觉**：把每个 token 的 embedding 向量压到均值为0、标准差为1，再重新缩放到合适的范围

### 4.2 GELU

$$\text{GELU}(x) \approx 0.5x \left(1 + \tanh\left(\sqrt{\frac{2}{\pi}}(x + 0.044715x^3)\right)\right)$$

- 比 ReLU（负的直接截断为0）更平滑
- **直觉**：ReLU 像一刀切——负的就是0；GELU 像软刀——负的也会留一点信号，对大模型更友好
- **不用背公式**，知道是 ReLU 的平滑版就行

### 4.3 参数量怎么算

GPT-2 Small 为例（config: `vocab_size=50257, d_model=768, n_heads=12, n_layers=12`）：

| 组件 | 计算 | 约 |
|------|------|-----|
| Token Embedding | 50257 × 768 | 38.6M |
| Position Embedding | 1024 × 768 | 0.8M |
| 每层 Attention QKV | 3 × 768 × 768 | 1.8M/层 |
| 每层 FFN | 2 × 768 × 3072 | 4.7M/层 |
| 每层 Total | 1.8M + 4.7M + biases | ~7M/层 |
| 12层 + Embed + Head | | **~124M** |

**关键洞察**：GPT-2 Small 的 1.24 亿参数里，70% 在 FFN 层（不是 Attention！）。FFN 才是"存储知识"的地方，Attention 是"检索关系"的地方。

---

## 五、看视频前的预习清单（带着这 5 个问题看）

1. **LayerNorm 放在哪里？** 是 Attention/FFN 的"前面"还是"后面"？（GPT 是 Pre-LN：**先归一化再进子层**）
2. **残差连接怎么实现？** 是 `x = layer(x) + x` 还是 `x = x + layer(x)`？（顺序无所谓，但 CH4 代码写的是 `x = x + attn(ln(x))`）
3. **为什么 Token Embedding 和 Position Embedding 是"相加"而不是"拼接"？**（拼接会让维度翻倍，相加更节省参数，而且实验证明效果相当）
4. **输出头的 `nn.Linear(d_model, vocab_size)` 出了什么？** 出了  形状为 `(seq_len, vocab_size)` 的 logits——每个位置在 50257 个词上的打分，取最高分的词就是下一个 token
5. **Causal Mask 加在 Attention 的哪个步骤？** 在 Q·K^T 算出 scores 之后、Softmax 之前——把"未来"位置的 scores 设成 -∞，Softmax 后就是 0

---

## 六、CH4 的坑（预览一下，写代码时注意）

| 坑 | 表现 | 怎么躲 |
|----|------|-------|
| **LayerNorm 的方向** | 在 d_model 方向上归一化，不是 batch 方向！ | `nn.LayerNorm(d_model)` 写对参数 |
| **残差连接忘记加** | 训练几个 epoch 后 loss 不降甚至变 nan | 检查每个子层后都有 `x = x + sublayer(x)` |
| **Causal Mask 方向搞反** | 上三角和下三角弄混，模型生成语法全乱 | 画个小矩阵手工验证：`torch.tril(torch.ones(4,4))` |
| **生成时忘记 mask** | 训练正常、推理出错 | `forward` 里 `mask` 参数要有，推理时必须传 |
| **Token Embed 和 Pos Embed 直接相加** | 位置信息丢失 | 确认是 `tok_emb + pos_emb`，不是 `torch.cat` |

---

## 七、学完 CH4 的标准（这里的"会"）

✅ 能画出 GPT 模型的完整数据流图（token→embed→N个block→output logits）
✅ 能解释 LayerNorm、残差连接、GELU 各自解决了什么问题
✅ 能回答"GPT 的 1.24 亿参数主要分布在哪里"（FFN 占 70%）
✅ 跑通 CH4 代码，打印 `model` 出来能看懂每一层的形状变化
✅ 用自己搭的 GPT 生成第一段文字——哪怕只有一行

---

## 八、跟 DRIFTS 项目的连接

```
LabVLA 里的 DiT 架构：
  · 核心零件：Attention Block + FeedForward Block ← CH4 刚搭完的！
  · LayerNorm / 残差连接 ← 和 GPT 一模一样的模式
  · 区别：GPT 处理文本 token，DiT 处理机器人动作 token
  · 底层画布相同，上层涂不同颜色

我们的 DRIFTS 24步流程：
  · Attention 机制（CH3）→ 理解"这一步操作在全局流程中的位置"
  · GPT 生成逻辑（CH4）→ 帮 AI 编排接下来的操作步骤
  · 就像 GPT 生成下一个词 → 我们的系统生成下一个动作
```

---

> **预习目标**：看完笔记，脑子里有那个"积木搭成整面墙"的画面就够了。矩阵细节让视频和代码填。
