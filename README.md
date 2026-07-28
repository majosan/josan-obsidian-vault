# Josan's Obsidian 知识库 / A4S Chem-Lab

> 📖 个人项目知识库 + 全项目协作中枢

## 简介

涵盖 AI 化学实验室、触觉传感器研发、专利布局与实验室自动化。由传感前锋（服务器）统筹 + Josan（物理执行）三台 Windows 机器 + Claude Code 协作。

## 知识库目录

```
00-总览.md              ← 从这里开始
01-AI化学实验室/         ← 高通量无人化学实验平台 + LabVLA 项目
02-触觉传感器/           ← 柔性织物触觉传感器
03-专利与IP/             ← 发明专利/实用新型
04-实验室自动化/          ← 机械臂部署与仿真
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

### 项目目录

```
projects/     ← 项目详细文档
tasks/        ← 任务板（传感前锋发活）
shared/       ← 共享上下文（agent 协作用）
```

> **Windows 用户**：打开终端，运行 `.\bridge.ps1` 即可一键 pull → 显示待办 → 完成时 push
