---
date: 2026-09-22
tags:
  - 开发交接
  - 技术方案
  - 养老
  - 物业
关联文档: "[[智能床垫压力监测垫系统 · 功能需求 v1.1]]、[[智能床垫压力监测垫系统 · 场景与角色 v1.1]]、[[设备通信协议与数据规范 v1.0]]、[[传感床垫软件 · 开发交接书（dsh 执行版）v0.1]]"
编写人员: 传感前锋
版本: V1.1
---
# 智能床垫压力监测垫系统 · 开发交接书（dsh 执行版）V1.1

> **本文件是自包含的开发任务书**，可直接交给编码 Agent（dsh）执行，无需再读其他文档即可开工。
> **目标**：交付一条端到端可演示的链路 ——「**设备（WiFi 直连）→ IoT 平台 → 业务后端 → 小程序（家属端 / 物业端）+ 后台管理 Web**」。
> **与 V0.1 的根本区别**：**没有 PC 网关**。设备端（含 WiFi 固件）**外包**，dsh **不写固件**，但要**按协议对接**（用设备模拟器开发）。

---

## 0. 一页速览

| 项 | 内容 |
|---|---|
| **要做什么** | 养老床垫（物业场景）的**软件闭环**：云平台对接 + 业务后端 + 小程序（家属端/物业端）+ 后台 Web |
| **不做** | ❌ 设备固件（外包）❌ PC 网关（已废弃）❌ 硬件电路 |
| **技术栈** | 设备接入 **IoT 平台（MQTT）**；业务后端（**Node.js 或 Python，二选一**，见 §2）；小程序 **原生微信小程序**；后台 **Vue3 + Vite**；数据库 **云数据库/MySQL 二选一** |
| **关键约束** | ① **不传原始 1024 点**，只传特征包；② 设备**只连 IoT 平台**，小程序**只连业务后端**；③ **设备接入层做成 Adapter**，不锁死云厂商；④ 所有阈值/时段/响应策略**配置化**；⑤ 文案**不做医疗宣称** |
| **首要里程碑** | **无硬件跑通**：本地 MQTT + 设备模拟器造 3 台设备 → 后端 → 小程序看在床/离床 + 告警 → 后台多床看板 |
| **验收口径** | 见 §12；协议见 [[设备通信协议与数据规范 v1.0]] |

---

## 1. 背景（30 秒）

- 设备端：`32×32 柔性压力阵列 → 采集板 MCU → 边缘判定 → WiFi 模组 → MQTT/TLS → IoT 平台`。
- **固件由外包公司开发**，dsh **不碰固件**，但**必须按协议实现云端对接**：
  - **上线前**：用 **设备模拟器**（dsh 自己写）模拟真实设备，**在没有硬件的情况下完整开发与演示**。
  - **上线时**：外包固件按同一协议接入，云端与前端**零改动**。
- 业务侧：**面向物业/小区**，告警响应人是**家属/亲友（第一响应）+ 物业值班（兜底）**，**没有护理员角色**。
- **设计铁律**：协议是唯一的对接契约（见 [[设备通信协议与数据规范 v1.0]]）。改协议 = 云与端全改，所以**先按协议把模拟器做对**。

---

## 2. 技术栈与运行环境

| 层 | 选型 | 说明 |
|---|---|---|
| **设备接入** | **IoT 平台**（阿里云 IoT / 腾讯云 IoT / 华为云 IoT） | 负责 MQTT 接入、设备影子、OTA；**开发期用本地 MQTT Broker（EMQX / mosquitto）替代** |
| **业务后端** | **Node.js 18+（NestJS/Express）或 Python 3.10+（FastAPI）** | 告警规则引擎、通知、报表、计费、API；**推荐 Node.js，与小程序同栈** |
| **数据库** | **云数据库（MongoDB 兼容）或 MySQL** | 状态/事件/告警/统计/计费；见 §6 |
| **小程序** | **原生微信小程序**（不用 uni-app） | 家属端 + 物业端（同一小程序按角色分流） |
| **后台 Web** | **Vue3 + Vite + Element Plus** | 机构/项目管理、看板、报表、规则配置 |
| **短信** | 阿里云短信 / 腾讯云短信 | L3 告警短信（先做 **Stub 接口**，后接真实通道） |
| **共享** | `shared/` 放协议常量与 JSON Schema | 模拟器与后端**共用同一份定义** |

> **反锁定要求**：设备接入写成 `DeviceAdapter` 接口（`LocalMqttAdapter` / `AliyunIotAdapter` / `TencentIotAdapter`），切换云厂商只换实现。

---

## 3. 系统架构

```
┌──────────────┐   ┌─────────────────────────────┐
│ 压力传感床垫  │   │  采集板 MCU（边缘判定）        │
│ + WiFi 模组   │──▶│  → MQTT/TLS 上行              │  ← 固件外包，dsh 不写
└──────────────┘   └───────────────┬─────────────┘
                                    │  MQTT over TLS(8883)
                                    ▼
                    ┌───────────────────────────────┐
                    │  IoT 平台（设备接入）           │
                    │  设备影子 / 规则转发 / OTA      │
                    └───────────────┬───────────────┘
                                    │  HTTP/Webhook 转发
                                    ▼
        ┌──────────────────── 业务后端（dsh 主战场）─────────────────────┐
        │  DeviceAdapter → Ingest → 告警规则引擎 → 告警中心              │
        │                             ├─ 通知服务（订阅消息 / 短信）      │
        │  数据层：状态覆盖写 + 事件追加 + 定时聚合                       │
        │  账号权限(多租户) / 报表 / 计费订阅 / 开放 API / 运维后台        │
        └───────────────┬───────────────────────────┬──────────────────┘
                        │ HTTPS API                 │ HTTPS API
                        ▼                           ▼
                ┌────────────────┐        ┌──────────────────┐
                │ 小程序          │        │ 后台 Web          │
                │ 家属端 / 物业端 │        │ 项目管理/看板/报表 │
                └────────────────┘        └──────────────────┘
```

---

## 4. 建议仓库结构（monorepo）

```
mattress-guard/
├── shared/
│   ├── protocol.md              # 协议摘要（权威文档见《设备通信协议与数据规范》）
│   ├── constants.json           # 事件类型/告警级别/字段名/错误码（模拟器+后端+前端共用）
│   └── schemas/                 # 报文的 JSON Schema（status/event/cmd/ack）
├── simulator/                   # ① 设备模拟器（**dsh 必做，无硬件开发的核心**）
│   ├── device.py                # 单设备：剧本（上床/静卧/翻身/贴边/离床/回床）
│   ├── fleet.py                 # 批量造 N 台设备 BED-0001..BED-000N
│   ├── mqtt_pub.py              # 按协议发布 status/event（含断网缓存与续传模拟）
│   └── config.yaml              # broker 地址、设备数、剧本速度
├── backend/                     # ② 业务后端
│   ├── adapters/                # DeviceAdapter（local_mqtt / aliyun / tencent）
│   ├── ingest/                  # 报文校验 + 幂等 + 状态覆盖写
│   ├── rules/                   # 告警规则引擎（配置化）
│   ├── alerts/                  # 告警中心（接单/处理/归档）
│   ├── notify/                  # 通知：订阅消息 / 短信（Stub → 真实）
│   ├── report/                  # 聚合与报表导出
│   ├── billing/                 # 计费与订阅
│   ├── api/                     # 小程序/后台的 REST API
│   ├── cron/                    # 定时：聚合、离线判定、续费提醒
│   └── config/                  # 阈值默认值、响应策略默认值
├── miniprogram/                 # ③ 小程序（原生）
├── admin/                       # ④ 后台 Web（Vue3 + Vite）
├── ops/                         # ⑤ 运维后台（设备监控/OTA/租户/工单）
└── docs/                        # 本交接书与关联文档
```

---

## 5. 设备接线方式（dsh 的实现口径）

### 5.1 开发期（无硬件）
```
simulator ──MQTT──▶ 本地 Broker(EMQX/mosquitto) ──▶ backend(DeviceAdapter=local_mqtt)
```
- 模拟器**严格按协议**发 `up/status`、`up/event`、`up/heartbeat`；
- 同时支持接收下行 `down/cmd`（用于测 `set_rules`、`ota`、`reboot`）。

### 5.2 生产期（真机）
```
真机(外包固件) ──MQTT/TLS──▶ IoT 平台 ──规则转发/Webhook──▶ backend(DeviceAdapter=aliyun/tencent)
```
- **业务后端代码不变**，只切换 Adapter 与环境配置。

---

## 6. 数据层规格

> ⚠️ **绝不**把原始帧或 15Hz 数据入库。**状态覆盖写 + 事件追加 + 定时聚合**，三层。

| 表/集合 | 写入方式 | 关键字段 |
|---|---|---|
| `tenants` | 少 | `tenantId`、`name`（物业公司）、`plan`、`status` |
| `projects` | 少 | `projectId`、`tenantId`、`name`（小区）、`address` |
| `devices` | 少 | `deviceId`(唯一)、`projectId`、`bedId`、`model`、`fw`、`deviceKeyHash`、`lastTs`、`online`、`battery` |
| `device_status` | **覆盖写（每设备 1 条）** | `deviceId`、`ts`、`inBed`、`total`、`centroid`、`peak`、`edgePct`、`thumb`、`online`、`inBedSince`、`outBedSince`、`edgeSince`、`lastTurnTs` |
| `buildings`/`rooms` | 少 | 楼栋/房间层级 |
| `beds` | 少 | `bedId`、`roomId`、`projectId`、`deviceId`、`elderId`、`responsePolicy` |
| `elders` | 少 | `elderId`、`name`、`gender`、`age`、`phone`、`emergencyContacts[]`、`tags[]`（独居/空巢/半失能/失能/认知症）、`note`、`consentSigned` |
| `users` | 少 | `openid`、`tenantId`、`projectId`、`role`(`family`/`property`/`supervisor`/`admin`/`group`/`ops`)、`bedIds[]`、`phone` |
| `events` | 追加 | `deviceId`、`bedId`、`type`、`ts`、`detail` |
| `alerts` | 追加 | `deviceId`、`bedId`、`type`、`level`(`L1`/`L2`/`L3`)、`ts`、`status`(`pending`/`accepted`/`handled`/`archived`)、`handler`、`acceptedTs`、`handledTs`、`note`、`escalated` |
| `alert_rules` | 少，可覆盖 | `scope`(global/project/bed)、`leaveBedMinutes`、`activeStart/End`、`fallRiskEdgePct`、`longLieSec`、`turnIntervalSec`、`responsePolicy` |
| `stats_hourly`/`stats_daily` | 定时聚合 | `bedId`、`period`、`inBedMinutes`、`leaveCount`、`turnCount`、`alertCount`、`fallRiskCount`、`avgResponseSec` |
| `billing` | 少 | `contractId`、`tenantId`、`projectId`、**`mode`(purchase/lease)**、`bedCount`、`startDate`、`endDate`、`fee`、`renewalRemind`、`status` |
| `audit_logs` | 追加 | 操作人、动作、对象、时间 |

**字段命名**：JSON 用 `camelCase`，DB 字段统一 `camelCase`（如用 MySQL 则列名 `snake_case`，代码层映射）。

---

## 7. 后端 API 契约（给小程序/后台）

| 接口 | 方法 | 入参 | 出参 / 说明 |
|---|---|---|---|
| `/api/auth/login` | POST | `code`(wx.login) | 按 `users.role` 返回角色与可见范围 |
| `/api/status` | GET | `bedId?` `projectId?` | 单床/多床最新状态（**按角色过滤**） |
| `/api/events` | GET | `bedId?` `from?` `to?` `page?` | 事件列表 |
| `/api/alerts` | GET | `status?` `level?` `from?` `to?` | 告警列表 |
| `/api/alerts/accept` | POST | `alertId` | 接单（记 `acceptedTs`/`handler`） |
| `/api/alerts/handle` | POST | `alertId`、`note?`、`photos?` | 处理（记 `handledTs`） |
| `/api/elders` | GET/POST/PUT | 档案字段 | 老人档案 CRUD |
| `/api/beds` | GET/POST/PUT | 床位字段 | 床位/房间/绑定 CRUD |
| `/api/bind` | POST | `action`(bind/unbind/createElder) | 设备↔床位↔用户 |
| `/api/rules` | GET/PUT | `scope`、阈值 | 规则与**响应策略**配置 |
| `/api/report` | GET | `bedId?` `projectId?` `from` `to` `format` | 报表数据 / 导出文件 |
| `/api/billing` | GET/POST | 合同字段 | **计费与订阅管理** |
| `/api/devices` | GET | `projectId?` `online?` | 设备列表（运维） |

> 所有接口**必须鉴权 + 租户隔离 + 角色校验**（越权返回 403）。

---

## 8. 告警规则引擎（**核心**）

| type | 判定（默认） | level |
|---|---|---|
| `leave_bed` | `inBed` true→false；`now - outBedSince > leaveBedMinutes`（默认 **30**，可配 15/30/60）**且**在 `[activeStart, activeEnd]`（默认 21:00–06:00）内 | L2 |
| `long_lie` | 重心位移 < 阈值 且持续 > `longLieSec`（默认 7200s） | L1（压疮风险，任务化提醒） |
| `turn` | `now - lastTurnTs > turnIntervalSec`（默认 7200s） | L1（任务化提醒） |
| **`fall_risk`** | ① 在床且 `edgePct > fallRiskEdgePct` 持续 > 2s；**或** ② `edgePct` 高 → 3s 内 `inBed` 变 false | **L3** |
| `offline` | `lastTs` 超时 > 120s | **L3** |
| `low_battery` | `battery < 15%` | L2 |

**必须实现**：
1. **三级配置**：`global → project → bed` 逐级覆盖。
2. **去重**：同一床位 + 同一类型，在**事件窗口**内只报一次（按 `outBedSince`/`edgeSince` 归一）。
3. **静默期**：人工临时静音 N 分钟。
4. **免打扰时段**：默认 22:00–06:00 仅推 L2/L3。
5. **升级规则**：
   - L3 → 通知「家属 + 物业值班」；**5min 未接单** → 通知 `supervisor`；**10min 未处理** → 通知 `admin` 并再提醒家属。
   - L2 → 30min 未接单 → 通知 `supervisor`。
6. **响应策略**（**默认 `物业兜底`**）：`family_first` / `dual` / `property_backup` / `property_first`。

---

## 9. 通知服务

| 渠道 | 代码 | 说明 | 优先级 |
|---|---|---|---|
| 小程序消息中心 | 内置 | 兜底，必到 | P0 |
| 微信订阅消息 | `wx.subscribeMessage` | 需**模板 ID**（Josan 提供） | P0 |
| **短信** | 阿里云/腾讯云短信 | **L3 发给家属 + 物业值班**；先做 **Stub**（写日志+落库） | P1 |
| 语音外呼 | 可选 | 商业化评估 | P2 |
| Webhook | 开放 API | 对接物业/工单系统 | P2 |

**要求**：通知发送**异步、可重试、失败落库**；发送记录可查（谁、何时、什么渠道、成功否）。

---

## 10. 小程序规格（原生）

### 10.1 通用
- 登录：`wx.login` → `/api/auth/login` → 按 `role` 分流（家属端 / 物业端）。
- 绑定：`wx.scanCode` 得 `deviceId` → `/api/bind` → 选/建床位与老人。
- 实时性：优先 **WebSocket / 长轮询**，退化 5–10s 轮询。

### 10.2 家属端页面
| 页面 | 内容 | 接口 |
|---|---|---|
| 首页·实时状态 | 在床/离床大图标、最近告警、刷新 | `/api/status` |
| 告警列表 / 详情 | 时间线、级别、详情、**接单/处理** | `/api/alerts` |
| 周报 | 在床时长/离床次数/翻身次数/告警统计 | `/api/report` |
| 我的 | 绑定管理、订阅授权、**短信手机号** | `/api/bind` |

### 10.3 物业端（值班）页面
| 页面 | 内容 | 接口 |
|---|---|---|
| 小区/楼栋多床看板 | 一屏总览（在线/在床/告警），级别高亮 | `/api/status`（批量） |
| 告警列表 / 处理 | 接单 → 处理 → 备注 → 上传照片 | `/api/alerts/accept`、`/handle` |
| 照护提醒 | 久卧/翻身任务待办 | `/api/events` |
| 交接班 | 当前告警、待办、重点老人 | 组合查询 |
| 个人设置 | 通知开关、免打扰、值班状态 | — |

---

## 11. 后台 Web 规格（Vue3 + Vite）

| 页面 | 内容 |
|---|---|
| 登录 | 账号密码 + 可选短信验证码（租户/角色） |
| 多床看板 | 按项目/楼栋/在线/告警多维筛选，点进单床详情 |
| 告警管理 | 列表、筛选（类型/级别/状态/时间/床位）、处理流转、导出 |
| 楼栋/房间/床位 | 层级管理 + **Excel 批量导入** |
| 老人档案 | 含**人群标签**、**知情同意**状态 |
| 设备管理 | 设备列表、在线状态、固件版本、绑定/解绑、**配网状态** |
| 规则与响应策略 | **三级配置**（全局/项目/床位）+ 响应策略 |
| 报表 | 按项目/楼栋/床位/时间段 + **导出 xlsx/pdf** |
| 计费与订阅 | **按床采购 / 按年租赁**、合同期、费用、续费提醒 |
| 账号与权限 | 用户/角色/值班组管理 |

---

## 12. 验收标准（Definition of Done）

1. **无硬件可演示**：模拟器造 **3 台设备**，全链路无需真实床垫。
2. **端到端**：模拟器 → 本地 Broker → 后端 → 小程序首页 **5s 内**反映"在床/离床"。
3. **协议一致**：模拟器与外包固件**发同一套报文**（字段/类型/枚举一致）；切换 Adapter 到 IoT 平台不改业务代码。
4. **告警准确**：
   - 生效时段内离床超 30min（可配）→ `leave_bed`；
   - 贴边 + 快速离床 → `fall_risk`（L3，**短信 + 小程序**）；
   - 设备 2min 无上报 → `offline`（L3）；
   - 同一次事件**不重复告警**；
   - **升级规则**生效（5min→supervisor，10min→admin）。
5. **多床 + 多租户**：物业端看板同时显示多床；**跨租户越权被拒**。
6. **断网容错**：模拟器断网期间事件入队，恢复后补传、去重、不丢。
7. **成本红线**：后端**不出现原始帧**；状态覆盖写 + 事件追加 + 聚合。
8. **配置化**：阈值、时段、响应策略、上行间隔**全部在配置/数据库**，不写死。
9. **计费双模式**：后台可建"采购/租赁"合同，到期可触发**续费提醒**。
10. **合规文案**：全程"预警/风险/提醒"，无"报警/监护/诊断"。

---

## 13. 任务拆解（按里程碑）

| # | 任务 | 产出 | 验收 |
|---|---|---|---|
| **M0** | 仓库骨架 + `shared/` 协议常量与 Schema + **设备模拟器（本地 MQTT）** | 模拟器可发 status/event | 用 MQTT 客户端能看到符合协议的报文 |
| **M1** | `DeviceAdapter(local_mqtt)` + Ingest + `device_status` 落库 | 数据入库 | 模拟器跑 1 台，`device_status` 持续更新 |
| **M2** | 规则引擎 + `events`/`alerts` + 通知（订阅消息 + 短信 Stub）+ 升级规则 | 告警能产生并通知 | 模拟"离床超时""贴边快离"，产生 L2/L3 且不重复；升级生效 |
| **M3** | 小程序·家属端（5 页） | 家属端可用 | 能绑定、看实时状态、收告警、看周报 |
| **M4** | 小程序·物业端（5 页） | 值班端可用 | 多床看板实时刷新、能接单处理 |
| **M5** | 后台 Web（10 页） | 后台可用 | 看板/告警流转/档案/**三级规则**/报表导出可用 |
| **M6** | 多租户 + 报表 + **计费订阅** + 越权防护 | SaaS 就绪 | 跨租户隔离验证通过；可建采购/租赁合同 |
| **M7** | 对接真机：切 Adapter 到 IoT 平台 + 配网联调（配合外包固件）+ OTA | 真机上线 | 真机按协议接入，**业务代码零改动**；OTA 成功 |
| **M8** | 加固：日志、监控、错误处理、文档、运维后台 | 可交付 | §12 全过 |

> **第一个交付目标 = M0–M2 + M3 首页**：即"模拟设备 → 后端 → 小程序首页看到在床/离床 + 一条告警"。**先跑通再加宽**。

---

## 14. 需要 Josan 提供（前置条件）

| # | 事项 | 用途 | 是否阻塞 |
|---|---|---|---|
| 1 | **微信小程序 AppID** | 建项目 | 阻塞 M3/M4 联调 |
| 2 | **IoT 平台账号**（阿里云/腾讯云 IoT）+ 产品/设备三元组 | 真机接入 | 不阻塞（先用本地 MQTT） |
| 3 | **短信通道**（阿里云/腾讯云短信）签名与模板 | L3 短信 | 不阻塞（先 Stub） |
| 4 | **订阅消息模板 ID** | 微信推送 | 不阻塞（可后补） |
| 5 | **外包固件方的联调排期与责任人** | M7 对接 | 阻塞 M7 |
| 6 | 域名 + SSL 证书（后台/API） | 部署 | 不阻塞（先本地） |
| 7 | 设备/床位编号规则（默认 `BED-0001`） | 命名统一 | 不阻塞 |
| 8 | 阈值初值 / 标定参数 | 告警灵敏度 | 不阻塞（用 §16 占位值） |

---

## 15. 工程约定与红线

- **命名**：JSON `camelCase`；时间戳统一**毫秒**；枚举值用英文小写。
- **不得入库原始帧**；不得存 15Hz 数据。
- **设备接入必须走 Adapter**，业务代码不得直接依赖某云厂商 SDK。
- **网络发送与采集/入库解耦**（异步 + 队列）。
- 阈值/时段/响应策略/计费模式**不得硬编码**。
- **上行必须鉴权**；下行指令必须回 `ack`。
- 文案**避免医疗/监护宣称**。
- 每个模块给 README + 运行步骤；**模拟器必须能独立跑通全部验收**。

---

## 16. 待定参数占位（先用这些值，后按实测标定）

| 参数 | 占位值 | 说明 |
|---|---|---|
| `inBedThreshold` | 按标定（默认空载基线+经验值） | 逐床标定 |
| `edgeBandCells` | 3 | 边沿带宽（格） |
| `fallRiskEdgePct` | 0.30 | 坠床风险边沿占比 |
| `leaveBedMinutes` | 30（档 15/30/60） | 离床超时 |
| `activeStart/End` | 21:00 / 06:00 | 离床告警生效时段 |
| `longLieSec` | 7200（2h） | 久卧 |
| `turnIntervalSec` | 7200（2h） | 翻身提醒 |
| `reportIntervalSec` | 5 | 状态上行 |
| `offlineTimeoutSec` | 120 | 设备离线 |
| `responsePolicy` | **`property_backup`（物业兜底）** | 默认响应策略 |
| 短信触发 | **仅 L3** | 家属 + 物业值班 |

---

*V1.1 — 2026-09-22。相对 V0.1：**去掉 PC 网关**，改为 **设备 WiFi 直连 IoT 平台**；dsh **不写固件**，改为**按协议实现云端对接 + 自研设备模拟器**；角色改为**家属 + 物业值班**（新增响应策略，默认物业兜底）；新增**多租户、计费订阅、短信、运维后台**。协议以 [[设备通信协议与数据规范 v1.0]] 为准；需求背景见《功能需求 v1.1》与《场景与角色 v1.1》。*
