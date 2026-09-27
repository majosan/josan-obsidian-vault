# A4S Chem-Lab 统一上下文

> 所有 agent 启动时必读

## 项目架构

```
A4S Chem-Lab (GitHub 私有仓库)
├── projects/
│   ├── tech-project-sensor/   ← 全柔性织物压力传感
│   │   └── subprojects/tactile-glove/  ← 触觉手套
│   └── ai-chem-lab/           ← AI 化学实验室
├── tasks/                     ← 任务板（2026-09 废弃，任务改放各项目目录下）
└── shared/                    ← 共享上下文（Agent 协作文档，vault 内见 `00-AI入口/协作体系/`）
```

## 参与方

| 角色 | 位置 | 职责 |
|------|------|------|
| 🧑 Josan | 3 台 Windows | 物理执行（测试/采集/验证） |
| ⚡ 传感前锋 | Linux 服务器 | 总工（方案/标准/分析/决策） |
| 🤖 Claude Code | 各台 Windows | 纯 coding（写脚本，不参与决策） |

## 协作协议

1. **传感前锋**在**对应项目目录下**写 task markdown 文件（原 `tasks/` 已废弃）
2. **Claude Code 机器** pull → 认领 → 执行 → push 结果
3. **传感前锋** review → 在 task 中写评语 → 关闭或迭代
4. **Josan** 是最终决策者，通过飞书沟通

## 当前活跃子项目

**触觉手套 (tactile-glove)** — 已缝制完成，验收测试阶段
