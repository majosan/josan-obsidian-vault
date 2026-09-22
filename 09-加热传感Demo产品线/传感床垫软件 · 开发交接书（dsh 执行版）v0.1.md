---
date: 2026-09-20
tags:
  - 开发交接
  - 软件需求
  - 技术方案
关联文档: "[[传感床垫软件 · 需求与范围 v0.1]]、[[传感数据上云与养老后台小程序技术方案-v0.2]]"
编写人员: 传感前锋
版本: V0.1
---
> [!warning] 历史版本（已归档）
> 本文件为 **V0.1（PC 网关版）记录版**，**已被 [[智能床垫压力监测垫系统 · 开发交接书（dsh 执行版）v1.1]] 取代**（新架构：设备 WiFi 直连 IoT 平台，无 PC 网关）。
> **请勿据此开发**，仅作演进留档。

# 传感床垫软件 · 开发交接书（dsh 执行版）V0.1

> **本文件是自包含的开发任务书**，可直接交给编码 Agent（dsh）执行，无需再读其他文档即可开工。
> **目标**：交付一条端到端可演示的链路 ——「压力传感床垫 → PC 网关 → 微信云开发 → 小程序（家属端/护工端） + 后台管理 Web」。

---

## 0. 一页速览

| 项 | 内容 |
|---|---|
| **要做什么** | 养老场景压力床垫的**软件闭环**：设备接入网关 + 云端 + 小程序（家属端/护工端）+ 后台 Web |
| **技术栈** | PC 网关 **Python 3.10+**；云端 **微信云开发**（云函数 Node.js + 云数据库）；小程序 **原生 + wx.cloud**；后台 **Vue3 + Vite**（云开发静态托管，`@cloudbase/js-sdk`） |
| **硬件现状** | **无 WiFi/无蓝牙**。本轮由 PC 串口读数据、当网关上云（多串口 → 多设备） |
| **关键约束** | ① **不传原始 1024 点**，只传特征包（≈90B）；② 小程序**不能连局域网 PC**，只连云开发；③ 所有阈值/时段**配置化**；④ 本轮**不做真配网**，只做绑定 |
| **本轮不做** | 心率/生命体征、真 BLE/WiFi 配网、4G、呼叫中心、多级地图、医疗宣称 |
| **首要里程碑** | **用模拟设备（无需硬件）跑通**：模拟器造 3 台设备 → 云端 → 小程序看到在床/离床 + 告警 → 后台看板多床 |
| **验收口径** | 见 §11 |

---

## 1. 背景（30 秒）

- 现场：`32×32 压力传感布 → 采集板 MCU → 串口(1 Mbps) → PC(Python 本地热力图)`。
- 现在要把它接到云上，做出**家属端 + 护工端 + 后台**的养老预警闭环。
- 因为硬件暂无联网模块，**PC 承担"设备接入层"职责**：读串口 → 提特征 → 降频 → POST 到云。
- **设计铁律**：PC 网关说的"协议"，就是将来 WiFi 模组里固件要说的同一套协议。云端和小程序按"设备直连云端"设计，**将来换硬件时云端/小程序零改动**。

---

## 2. 技术栈与运行环境

| 层 | 选型 | 说明 |
|---|---|---|
| PC 网关 | Python 3.10+，`pyserial`、`requests`、`PyYAML`、`sqlite3`（标准库）；可视化保留现有框架 | 三线程：读串口 / 可视化 / 上云转发 |
| 云端 | 微信云开发：**云函数（Node.js 16+）**、云数据库、订阅消息、HTTP 访问服务 | 免备案、免服务器 |
| 小程序 | 原生小程序 + `wx.cloud` | 家属端 + 护工端（按角色切换） |
| 后台 Web | Vue3 + Vite（或纯 HTML 也行），`@cloudbase/js-sdk` | 部署到云开发**静态网站托管** |
| 共享 | `shared/` 放协议常量与 JSON Schema | 网关与云函数共用同一份定义 |

---

## 3. 系统架构

```
┌────────────┐  ┌──────────────────────────── PC（现场）────────────────────────────┐
│ 压力传感床垫 │→ │  读串口线程 ──▶ 环形缓冲 deque(maxlen=200)                          │
│ + 采集板     │  │        │            ├─▶ 本地可视化线程（读最新帧，保留现有代码）        │
└────────────┘  │        └────▶ 上云转发线程：特征提取 + 降频(5s) + 事件即时 + 断网补传     │
                └──────────────────────────────┬────────────────────────────────────────┘
                                               │ HTTPS POST /ingest  (X-Device-Key)
                                               ▼
                         ┌─────────────── 微信云开发 ───────────────┐
                         │ 云函数 ingest → 云数据库（状态/事件/告警） │
                         │ 规则判定 → 订阅消息                        │
                         │ 云函数 query / alert-handle / bind / report│
                         │ 定时云函数 cron-stat → 小时/日聚合         │
                         └──────────┬───────────────────┬───────────┘
                                    │ wx.cloud           │ @cloudbase/js-sdk
                                    ▼                    ▼
                             ┌────────────┐      ┌──────────────┐
                             │ 小程序      │      │ 后台管理 Web  │
                             │ 家属/护工端 │      │ 多床看板/报表 │
                             └────────────┘      └──────────────┘
```

---

## 4. 建议仓库结构（monorepo）

```
mattress-guard/
├── shared/
│   ├── protocol.md              # 协议说明（人读）
│   └── constants.json           # 事件类型/告警级别/字段名（网关+云函数共用）
├── gateway/                     # ① PC 设备接入网关（Python）
│   ├── main.py                  # 装配：加载配置 → 起线程
│   ├── config.yaml              # 串口↔deviceId 映射、云端地址、密钥、阈值
│   ├── requirements.txt
│   ├── sources/
│   │   ├── base.py              # FrameSource 抽象接口
│   │   ├── serial_source.py     # 真串口（pyserial）
│   │   ├── mock_source.py       # 模拟器数据源（无硬件可用）
│   │   └── replay_source.py     # 回放录制的原始帧
│   ├── processing/
│   │   ├── frames.py            # 帧解析（demo 帧格式见 §5.3）
│   │   └── features.py          # 32×32 → 特征包（缩略图/总压力/重心/峰值/边沿占比/在床）
│   ├── sink/
│   │   ├── cloud.py             # POST /ingest，重试+退避
│   │   └── queue_sqlite.py      # 事件本地落盘 + 补传（按 seq 去重）
│   ├── viz/live.py              # 本地热力图（保留/改造现有代码，可选）
│   └── data/                    # 原始帧本地存（sqlite/文件），**不上云**
├── cloud/functions/             # ② 云函数（Node.js）
│   ├── ingest/                  # HTTP：接收特征包
│   ├── query/                   # 小程序/后台查询
│   ├── alert-handle/            # 处理告警
│   ├── bind/                    # 绑定设备↔床位↔用户
│   ├── report/                  # 报表导出
│   └── cron-stat/               # 定时聚合
├── miniprogram/                 # ③ 小程序（原生 + wx.cloud）
├── admin/                       # ④ 后台 Web（Vue3 + Vite）
├── tools/
│   ├── simulator.py             # 模拟设备发生器（脚本化：上床/翻身/离床/贴边）
│   └── replay.py                # 回放工具
└── docs/                        # 本交接书、需求与范围
```

---

## 5. 设备接入层（PC 网关）规格

### 5.1 线程模型

| 线程 | 职责 | 铁律 |
|---|---|---|
| ① 读串口 | 收帧 → append 到环形缓冲 | **只读不处理、绝不阻塞** |
| ② 本地可视化 | 从缓冲取最新帧画图 | 保留现有代码 |
| ③ 上云转发 | 取最新帧 → 提特征 → 降频 → POST | **失败静默重试，不拖累 ①②**；网络发送不得在①里做 |

```python
from collections import deque
frame_q = deque(maxlen=200)   # 满则丢最老帧，绝不反压
```

### 5.2 配置（`gateway/config.yaml`）

```yaml
cloud:
  ingest_url: "https://<云开发HTTP访问地址>/ingest"
  device_key: "<每设备或全局密钥>"
  up_interval_sec: 5          # 状态上行间隔（可调 5/10/30）
  timeout_sec: 3

serial:
  - port: "COM3"
    baud: 1000000
    device_id: "BED-0001"
  - port: "COM4"              # 多设备：每台一条串口，各起一个读线程
    baud: 1000000
    device_id: "BED-0002"

thresholds:
  in_bed: 500                 # 在床判定阈值（待标定）
  edge_band: 2                # 边沿带宽度（格）
  edge_pct_fall: 0.35         # 坠床风险：边沿占比阈值
  long_lie_centroid_eps: 0.8  # 久卧：重心变化阈值（格）
  long_lie_sec: 7200          # 久卧持续（s）
  turn_interval_sec: 7200     # 翻身提醒间隔（s）

local:
  raw_sqlite: "data/raw.sqlite"
  event_queue_sqlite: "data/events.sqlite"
  ntp_sync: true
```

### 5.3 串口帧格式（**demo 占位，可替换**）

> ⚠️ 真实硬件的帧格式待 Josan 提供。先按下面这套实现，`frames.py` 里做成**可替换的解析器**；真实协议确定后只改这一个文件。

```
每帧 = [0xAA][0x55] + payload(1024 bytes) + [xor]
payload: 32×32 压力矩阵，行优先，uint8（0–255）
xor    = payload 全部字节异或（1 byte）
帧长   = 1027 bytes ；帧率 15 Hz ；串口 1 Mbps
```

### 5.4 特征提取（`features.py`）—— **核心，决定云成本**

| 特征 | 计算 | 字节 |
|---|---|---|
| `thumb` | 32×32 → 8×8：每 4×4 块取**均值**（0–255 取整） | 64 |
| `total` | 全部 1024 点求和 | 4 |
| `centroid` | 压力加权质心 `[cx, cy]`（格子坐标，保留 1 位小数） | 8 |
| `peak` | `max(payload)` | 2 |
| `edgePct` | 落在**边沿带（宽 `edge_band`）**的压力 / `total` | 4 |
| `inBed` | `total > thresholds.in_bed` | 1 |
| 元数据 | `deviceId` / `ts`(ms) / `seq` / `event` | — |

> **原始 1024 点只留 PC 本地**（`data/raw.sqlite` / 文件），**绝不 POST 上云**。

### 5.5 上云数据包（POST `/ingest`，JSON）

```json
{
  "deviceId": "BED-0001",
  "ts": 1757970000000,
  "seq": 12345,
  "inBed": true,
  "total": 3421,
  "centroid": [15.2, 18.7],
  "peak": 255,
  "edgePct": 0.12,
  "thumb": [/* 64 个 0-255 */],
  "event": null
}
```
- Header：`X-Device-Key: <key>`
- `event` 取值：`null | "leave_bed" | "return_bed" | "long_lie" | "turn" | "fall_risk" | "offline"`

### 5.6 断网补传

- 事件类数据写 `events.sqlite`（字段：`seq, payload_json, created_at, sent(0/1)`）。
- 正常时立即 POST；失败则 `sent=0`。后台线程每 N 秒把 `sent=0` 的按 `seq` 顺序补传；成功后置 `sent=1`。
- 云端 `ingest` 按 `deviceId + seq` **幂等去重**（重复的直接返回 ok）。

---

## 6. 云端（微信云开发）规格

### 6.1 云数据库集合与字段

| 集合 | 写入方式 | 关键字段 |
|---|---|---|
| `devices` | 少量 | `deviceId`(唯一)、`bedId`、`model`、`fw`、`deviceKeyHash`、`lastTs`、`online` |
| `device_status` | **覆盖写（每设备 1 条）** | `deviceId`、`ts`、`inBed`、`total`、`centroid`、`peak`、`edgePct`、`thumb`、`online`、`inBedSince`、`outBedSince`、`edgeSince`、`lastTurnTs` |
| `beds` | 少量 | `bedId`、`room`、`org`、`deviceId`、`elderId` |
| `elders` | 少量 | `elderId`、`name`、`gender`、`age`、`address`、`phone`、`emergencyContacts[]`、`tags[]`（留守/空巢/独居/半失能/失能/普通）、`note`、`consentSigned`(bool) |
| `users` | 少量 | `openid`、`role`(`family`/`caregiver`/`admin`)、`bedIds[]`、`phone`、`name` |
| `events` | 追加 | `deviceId`、`bedId`、`type`、`ts`、`detail` |
| `alerts` | 追加 | `deviceId`、`bedId`、`type`、`level`(`mid`/`high`)、`ts`、`status`(`pending`/`handled`)、`handler`、`handledTs`、`note` |
| `alert_rules` | 少量，可覆盖全局默认 | `bedId`(可空=全局)、`leaveBedMinutes`、`activeStart`、`activeEnd`、`fallRiskEdgePct`、`longLieSec`、`turnIntervalSec` |
| `stats_hourly` / `stats_daily` | 定时聚合写 | `bedId`、`period`、`inBedMinutes`、`leaveCount`、`turnCount`、`alertCount`、`fallRiskCount` |

> ⚠️ **绝不**把原始帧或 15Hz 数据写库。状态覆盖写 + 事件追加 + 定时聚合，三层。

### 6.2 云函数契约

**`ingest`（HTTP 触发）**
- 入参：§5.5 的 JSON；Header `X-Device-Key`
- 逻辑：
  1. 校验 `X-Device-Key` 对应 `devices.deviceKeyHash`（不匹配 → 401）
  2. 校验必填字段；按 `deviceId+seq` 幂等去重
  3. **覆盖写** `device_status`（更新 `ts`、`online=true`，维护 `inBedSince/outBedSince/edgeSince/lastTurnTs`）
  4. 规则判定（§6.3）→ 写 `events` / `alerts`
  5. 命中告警 → 发**订阅消息**给绑定家属/护工
- 出参：`{ ok: true }`

**`query`**
- 入参：`{ type: "status"|"events"|"alerts"|"report", bedId?, deviceId?, from?, to?, page? }`
- 出参：对应数据数组（按角色/绑定做**权限过滤**）

**`alert-handle`**
- 入参：`{ alertId, action: "handle", note? }` → 改 `status=handled`、写 `handler/handledTs`

**`bind`**
- 入参：`{ action: "bind"|"unbind", deviceId, bedId, elderId?, openid?, role? }`
- 逻辑：建立/解除 `设备↔床位↔用户` 关系；`action:"createElder"` 时建档老人

**`report`**
- 入参：`{ bedId, from, to, format: "xlsx"|"csv" }`
- 出参：文件内容/下载地址（在床时长、离床次数、翻身次数、告警统计）

**`cron-stat`（定时触发：每小时 + 每天）**
- 聚合 `events`/`device_status` → 写 `stats_hourly`/`stats_daily`
- 顺带判**离线**：`lastTs` 超时 > 2min → `device_status.online=false` + 写 `offline` 告警（去重）

### 6.3 告警规则（`ingest` + `cron-stat`）

| type | 判定 | level |
|---|---|---|
| `leave_bed` | 由 `inBed` true→false；`now - outBedSince > leaveBedMinutes`（默认 30，可配 15/30/60）**且**在 `[activeStart, activeEnd]` 内（默认 21:00–06:00） | mid/high |
| `long_lie` | 重心位移 < `long_lie_centroid_eps` 且持续 > `long_lie_sec` | high |
| `turn` | `now - lastTurnTs > turnIntervalSec` | mid |
| **`fall_risk`** | ① 在床且 `edgePct > fallRiskEdgePct` 持续 > 2s；**或** ② `edgePct` 高 → 3s 内 `inBed` 变 false | high |
| `offline` | `lastTs` 超时 > 2min | high |

> 每条告警**按"事件窗口"去重**（同一 `outBedSince`/同一 `edgeSince` 只报一次），避免刷屏。

### 6.4 订阅消息

- 用小程序**订阅消息**推送告警。需 Josan 申请**模板 ID**并配置到小程序/云函数。
- 兜底：小程序"消息中心"列表 + 后台看板轮询。

---

## 7. 小程序规格（原生 + wx.cloud）

### 7.1 通用
- 登录：`wx.login` → 云函数换取 `openid`；首次进入按 `users.role` 分流（家属端 / 护工端）。
- 绑定：扫码 `wx.scanCode` 得 `deviceId`（或手输）→ 调 `bind` → 选/建床位与老人。

### 7.2 家属端页面
| 页面 | 内容 | 主要接口 |
|---|---|---|
| 首页·实时状态 | 在床/离床大图标、最近告警、刷新 | `query(status)` |
| 告警列表 | 时间线、类型/级别/时间 | `query(alerts)` |
| 告警详情 | 详情 + 处理状态 | `query(alerts)` |
| 周报 | 在床时长/离床次数/翻身次数/告警统计 | `query(report)` |
| 我的 | 绑定管理、订阅设置 | `bind` / 订阅授权 |

### 7.3 护工端页面
| 页面 | 内容 | 主要接口 |
|---|---|---|
| 多床看板 | 一屏总览（在线/在床/告警），按 `bedId` 分组 | `query(status)` 批量 |
| 告警处理 | 接单、处理、备注 | `alert-handle` |
| 任务 | 翻身提醒列表 | `query(events)` |

- 实时性：优先用云数据库**实时数据推送 `watch`**，退化方案为 5–10s 轮询。

---

## 8. 后台管理 Web 规格（Vue3 + Vite）

| 页面 | 内容 |
|---|---|
| 登录 | 管理员登录（`@cloudbase/js-sdk` 匿名/自定义登录 + 安全规则） |
| 多床看板 | 在线/在床/告警一屏总览，点进去看单床详情 |
| 告警管理 | 列表、筛选（类型/状态/时间/床位）、处理流转 |
| 设备管理 | `devices` 增删改查（含 deviceKey 配置） |
| 床位/老人档案 | `beds`/`elders` 管理，人群标签 |
| 报表 | 按床/时间段查询 + **导出 xlsx/csv** |

> 部署到云开发**静态网站托管**；调用云函数用 `@cloudbase/js-sdk`（需 Josan 在控制台开启并配置安全规则）。

---

## 9. 模拟器与回放（**无硬件也能全链路开发/演示**）

- `tools/simulator.py`：
  - 生成 32×32 压力帧的脚本化剧本：**上床 → 静卧 → 翻身 → 贴边 → 离床（含"快速离床"模拟坠床）→ 回床**；
  - 两种输出模式：① 直接喂 `mock_source`（走完整"特征提取→POST"链路）；② 写虚拟串口/文件供 `replay_source` 回放。
  - 支持一次生成 **N 台设备**（`BED-0001..000N`），供**多床看板**演示。
- `tools/replay.py`：读取录制文件，按原始帧率回放。
- 目的：dsh 在**没有任何硬件**的情况下，跑通 §11 的全部验收项。

---

## 10. 任务拆解（按里程碑，含验收）

| # | 任务 | 产出 | 验收 |
|---|---|---|---|
| **M0** | 仓库骨架 + `shared/constants.json` + 协议说明 | 目录成型 | 结构符合 §4 |
| **M1** | 网关：`FrameSource` 抽象 + `mock_source` + `features.py` + `sink/cloud.py` + `ingest` 云函数 + `device_status` 落库 | 单设备数据上云 | 模拟器跑 1 台，云数据库 `device_status` 有数据、`ts` 持续更新 |
| **M2** | 规则引擎 + `events`/`alerts` + 订阅消息 + 幂等去重 | 告警能产生 | 模拟"离床超时""贴边快速离床"，分别产生 `leave_bed`、`fall_risk` 告警且不重复 |
| **M3** | 小程序·家属端 | 5 个页面 | 能绑定、看到实时状态、告警列表、周报 |
| **M4** | 小程序·护工端 | 3 个页面 | 多床看板实时刷新、能处理告警 |
| **M5** | 后台 Web | 6 个页面 | 多床看板、告警流转、档案管理、报表导出可用 |
| **M6** | 真实串口接入 + 断网补传 + 多设备并联 | `serial_source` + `queue_sqlite` | 拔网 30s 后恢复，事件不丢且不重；3 台设备同时在线 |
| **M7** | 加固：配置化、鉴权、错误处理、日志、README | 可交付 | §11 全过 |

> **第一个交付目标 = M0–M2 + M3 首页**：即"模拟设备 → 云 → 小程序首页看到在床/离床 + 一条告警"。先把这个跑通再往下做。

---

## 11. 验收标准（Definition of Done）

1. **无硬件可演示**：模拟器造 **3 台设备**，无需真实床垫。
2. **端到端**：数据从网关 → `ingest` → 云数据库，小程序首页 5s 内反映"在床/离床"。
3. **告警准确**：
   - 在生效时段内离床超 30min（可配）→ 产生 `leave_bed`；
   - 贴边后快速离床 → 产生 `fall_risk`（high）；
   - 设备 2min 无上报 → `offline`（high）。
   - 同一次事件**不重复告警**。
4. **多床**：护工端看板同时显示 3 床状态；后台看板一致。
5. **断网容错**：断网期间事件本地入队，恢复后补传、去重、不丢。
6. **成本红线**：云端**不出现原始帧**；每日写入量 = 状态覆盖 + 事件 + 聚合（单床状态 5s 覆盖写 ≈ 17k 次/天，多床按倍数，间隔可调）。
7. **配置化**：串口映射、阈值、生效时段、上行间隔**全部在配置/数据库里**，不写死代码。
8. **可替换硬件**：把 `mock_source` 换成 `serial_source`、填好 `config.yaml`，即可接真机，**云端与小程序不改一行**。

---

## 12. 需要 Josan 提供（前置条件）

| # | 事项 | 用途 | 是否阻塞开发 |
|---|---|---|---|
| 1 | 微信**小程序 AppID** | 建项目 | 阻塞 M3/M4 联调 |
| 2 | 云开发**环境 ID** | 云函数/数据库 | 阻塞 M1 联调 |
| 3 | 开通**云开发 HTTP 访问服务** + 一把 `device_key` | PC 上行 | 阻塞 M1 |
| 4 | **订阅消息模板 ID** | 告警推送 | 不阻塞（可后补） |
| 5 | 现有**串口帧格式**（帧头/长度/校验） | `frames.py` | 不阻塞（先用 demo 帧） |
| 6 | 现有 Python **可视化框架** | 网关改造方式 | 不阻塞 |
| 7 | 设备/床位**编号规则**（如 `BED-0001`） | 命名统一 | 不阻塞（默认按此） |
| 8 | 阈值**初值** | 告警灵敏度 | 不阻塞（先用占位值） |

---

## 13. 待定参数占位（先用这些值，后按实测标定）

| 参数 | 占位值 | 说明 |
|---|---|---|
| `in_bed` 阈值 | 500 | 逐床标定 |
| `edge_band` | 2 格 | 边沿带宽 |
| `fallRiskEdgePct` | 0.35 | 坠床风险边沿占比 |
| `leaveBedMinutes` | 30（档位 15/30/60） | 离床超时 |
| `activeStart/End` | 21:00 / 06:00 | 离床告警生效时段 |
| `long_lie_sec` | 7200（2h） | 久卧 |
| `turnIntervalSec` | 7200（2h） | 翻身提醒 |
| `up_interval_sec` | 5 | 状态上行 |
| `offline` 超时 | 120s | 设备离线 |

---

## 14. 工程约定与红线

- **命名**：字段/集合/函数一律英文、`camelCase`（小程序）/`snake_case`（DB 字段可视现有风格统一），时间戳统一**毫秒**。
- **不得上传原始帧**；不得把 15Hz 数据写云数据库。
- **网络发送与串口读取必须解耦**（见 §5.1）。
- 阈值/时段/间隔**不得硬编码**。
- 云端上行**必须鉴权**（`X-Device-Key`），不得裸奔。
- 文案**避免医疗/监护宣称**（用"预警/风险"，不用"报警/监护/急救"）。
- 每个模块给出简短 README + 运行步骤；模拟器必须能独立跑通验收。

---

*V0.1 — 2026-09-20。本文档为 dsh 执行版，自包含；实现细节与需求背景分别见技术方案 V0.2 与《需求与范围 v0.1》。*
