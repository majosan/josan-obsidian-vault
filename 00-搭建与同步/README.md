# Josan's Obsidian 知识库 / A4S Chem-Lab

> 📖 个人项目知识库 + 全项目协作中枢

## 简介

涵盖 AI 化学实验室、触觉传感器研发、专利布局与实验室自动化。由传感前锋（服务器）统筹 + Josan（物理执行）三台 Windows 机器 + Claude Code 协作。

## 知识库目录

```
00-总览.md              ← 从这里开始（总索引）
00-AI入口/               ← 给本地 AI/Agent 的阅读理解层（先读这个）
00-搭建与同步/            ← 本目录：环境搭建与同步说明
01-AI化学实验室/         ← 高通量无人化学实验平台 + LabVLA + 具身智能
02-触觉传感器/           ← 柔性织物触觉传感器 + 触觉手套
03-专利与IP/             ← 发明专利/实用新型 + 竞品风险
04-实验室自动化/          ← 机械臂部署与 MuJoCo 仿真
05-LLM从零构建/          ← LLMs-from-scratch 学习计划
06-Blender/             ← Blender 3D 建模学习
07-WorkBuddy/           ← 房地产集团 AI 赋能（山水集团）
08-其他/                ← 南烯出售/资产重组、FA、Teaser、对外分析
09-加热传感Demo产品线/    ← 加热+传感 Demo PRD + 养老床垫系统
10-经编机项目/           ← 南烯经编机合同纠纷技术评判
11-自媒体/              ← 自媒体矩阵（小红书/抖音/视频号 · 造物者工程师 IP，原 douyin_pj）
12-半导体产业链/          ← 芯片产业链笔记
assets/                 ← 图片素材
shared/                 ← Agent 协作共享上下文
tasks/                  ← 任务板
```

## 协作工作流

```
传感前锋（服务器）
   ├─ 统筹协调、写 task、审核产出、数据分析
   │
   GitHub 私有仓库 ← 单源真理
   │
   ├─ 公司台式 (Claude Code) ← 认领 task A
   ├─ 笔记本 (Claude Code)   ← 认领 task B
   └─ 家里台式 (Claude Code) ← 认领 task C
```

## 同步方式

使用 **Obsidian Git** 插件自动同步，跨多台电脑共享。

### 首次使用

```bash
git clone https://github.com/majosan/josan-obsidian-vault.git
```

在 Obsidian 中打开该文件夹作为 vault，然后：
1. 设置 → 第三方插件 → 安全模式关闭
2. 社区插件 → 搜索并安装 **Obsidian Git**
3. 启用后设置：
   - Auto commit & push：5 分钟
   - Auto pull：10 分钟
   - Pull on startup：开启

### 功能区

```
assets/       ← 图片素材
tasks/        ← 任务板（传感前锋发活，Claude Code 认领）
shared/       ← 共享上下文（agent 协作用）
```

> 注：AI 的**项目上下文层**（`projects/*/CONTEXT.md` + `sessions/` + `memory/`）不在此 vault 内，仅保留在服务器本地，不入 git。

> **Windows 用户**：打开终端，运行 `.\bridge.ps1` 即可一键 pull → 显示待办 → 完成时 push
