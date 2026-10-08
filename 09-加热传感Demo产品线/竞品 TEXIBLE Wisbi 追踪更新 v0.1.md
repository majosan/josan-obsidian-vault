---
date: 2026-10-08
tags:
  - 竞品研究
  - 养老
  - 追踪更新
  - 资料摘录
关联文档: "[[TEXIBLE-Wisbi产品资料摘录]]、[[织物传感空间化与场景包 v0.1]]、[[Grabher集团与智能织物落地路径分析]]、[[智能床垫压力监测垫系统 · 场景与角色 v1.1]]"
来源: texible.com 官网（home / about-us / projects / production / smart-textiles）、英国经销商产品页（willowhealthcaresupplies / manageathome / medchemuk）、AAL 产品目录、官方样册 PDF
---
# 竞品 TEXIBLE Wisbi 追踪更新（V0.1）

> **目的**：在《[[TEXIBLE-Wisbi产品资料摘录]]》（2026-09-16 整理）基础上，做一次**现状追踪**：公司近况、产品在售状态、价格、技术能力变化，以及对我们的启示。
> **核实日期**：2026-10-08。
> **⚠️ 情报限制**：本机常规搜索被反爬（DuckDuckGo 拒答、部分站点 403、Northdata 财务数据付费墙），**未能获取 2025–2026 集团财报与新品发布的一手证据**；下列凡"未证实"均已标注。

---

## 一、公司：Texible GmbH（品牌 Wisbi 的持有方）

| 项 | 事实 | 来源 |
|---|---|---|
| 主体 | **Texible GmbH**（奥地利 Dornbirn） | texible.com |
| 出身 | **2016 年作为因斯布鲁克大学（University of Innsbruck）的初创 / 衍生公司（spin-off）成立** | texible.com/about-us |
| 定位 | 智能纺织品**工程服务商**（设计/开发/生产一站式），"推动智能纺织品在欧洲的可持续生产" | texible.com |
| 团队构成 | IT + 纺织工业 + 塑料技术 + 电子 + 项目管理 跨学科团队 | texible.com/about-us |
| 地域 | 总部在 Vorarlberg 莱茵河谷（邻近瑞士/德国），可用区域完整纺织产业链 | texible.com |
| 集团关系 | 属 **Grabher Group** 生态（姊妹公司 24sens / v-trion / Vprotect 等，详见 [[Grabher集团与智能织物落地路径分析]]） | 既有调研 |
| 品牌 | **Wisbi 是 Texible GmbH 自有品牌**（official 表述："Texible Wisbi is a Texible GmbH brand"） | texible.com/projects |

---

## 二、产品现状：Wisbi 在售、在推、在演进

### 2.1 在售状态 ✅（成熟商品，非概念）
- **英国在售**：经销商 willowhealthcaresupplies、manageathome、medchemuk 等均有产品页。
- **欧洲在售**：AAL 产品目录（aal-products.com）收录；奥地利经销商 georgegger.at 提供《TEXIBLE Wisbi PLUS 快速指南》下载。
- 有正式**用户手册**（ManualsLib 收录两个版本）。

### 2.2 价格锚点（新增，之前没有）💡
- **英国零售价：£255 – £315（不含 VAT）**，对应套餐 **1×发射器 + 1 张床垫** 到 **1×发射器 + 2 张床垫**。
  - 来源：willowhealthcaresupplies.co.uk（2026-10-08 抓取）。
  - 意义：**这是"床垫插层 + 报警"品类的真实付费价格锚点**，对我们定价与"按床采购/租赁"测算有直接参考价值。

### 2.3 产品定位与功能（复核，与 09-16 摘录一致）
- 智能传感织物**床垫插层**（bed insert，铺在床单下），检测 **潮湿/体液 + 离床**，触发报警。
- 报警路径：接**现有护理呼叫系统**，或无线接收器，或 **App**。

### 2.4 ⚠️ 关键发现：**Wisbi 并非"不用 WiFi"，而是"按场景分协议"**
- **HOME（居家）版 = Wi-Fi + 手机 App**：英国经销商原文——"The Wisbi app connects the bed pad control box to your smartphone **via Wi-Fi**"。
- **PLUS（机构）版 = Eldat Easy Wave 868.3 MHz**（接护理呼叫系统 / 低功耗电池报警）。
- **启示**：
  1. 我们选 **2.4 GHz WiFi 直连云端**（手机—云—设备）**与 Wisbi HOME 版同路**，路线不冲突、有先例。
  2. 868.3 MHz（欧洲 sub-GHz SRD，EnOcean 标准频点）用于**低功耗、穿墙、接既有呼叫系统**的场景；**HOME 版因要 App 直连而用 WiFi**——印证"协议按场景选，不是二选一"。
  3. 我们**电池版续航（规格书 P2 ≥30 天）与 Wisbi 3×AA 半年**的差距，根源就是 WiFi；若电池版重要，需专门评估低功耗通道（**当前协议已定 WiFi，暂不引入**，仅记录为待评估项）。

### 2.5 版本矩阵（复核）
CLASSIC（湿）/ **PLUS**（机构·湿+离床）/ **HOME**（居家·WiFi+App）/ PRO / KIDS / WHEELCHAIR / DIALYSIS。

### 2.6 研发动向
- **Interreg 巴伐利亚-奥地利项目 "Smart Care Assist"**：研究"智能纺织品用于护理床，减轻护理人员负担 + 优化照护"——Texible 为参与方（项目海报 2024-10）。
- 含义：**需求方向仍被欧洲公共研究持续背书**（智能纺织 + 护理床）。

---

## 三、技术能力更新：Texible 工艺菜单在扩充（对我们最有用的一条）

**对比 2026-09-14 Grabher 调研（当时列 5 种工艺）**，Texible `production` 页 2026-10-08 显示能力已扩展为 **9 类**：

| 工艺 | 状态 | 对我们 |
|---|---|---|
| 刺绣 Embroidery | 原有 | 我们同族工艺 ✅ |
| TFP 定制纤维铺放 | 原有（含"纺织加热元件"） | 我们缺、应补 |
| 针织 Knitting / 梭织 Weaving / 纺织后整理 | 原有 | 我们可对标 |
| **丝网印刷 Screen printing** | 🆕 **新增** | **可"点状精准"印传感器图案**，是**另一种做传感层的方法**——既是可借鉴工艺，也是潜在竞争路线 |
| **激光切割 Laser cutting** | 🆕 **新增** | 轮廓识别/对位裁切，适合**小批量自有产线** |
| 组装与生产 / 质量保证与测试 | 原有 | 其"**测试机器人 + 测试台 + 标准流程**"正是我们缺的测试能力 |

**启示**：对手在**扩产能与工艺**（丝网印刷、激光切割）的同时，**把"测试"作为正式能力对外强调**——这与我们"缺测试数据"的短板形成对照，进一步说明**补测试是我们最该做的事**。

---

## 四、对标小结（更新版）

| 维度 | Wisbi | 我们 |
|---|---|---|
| 公司 | Texible GmbH（2016 因斯布鲁克大学衍生，Grabher 生态） | 更早期，资产/demo 阶段 |
| 核心功能 | 湿/体液 + 离床（**二值报警**） | **连续压力分布**（1024 点热力图 / 重心 / edgePct） |
| 通信 | PLUS=868.3MHz；**HOME=WiFi+App** | **2.4 GHz WiFi 直连云端**（已定） |
| 价格锚点 | **£255–315（不含 VAT）** | 待定 |
| 体验卖点 | 95℃ 可洗 100 次、3×AA 半年、超薄 | 可拆洗面层、防溅、有线供电 |
| 场景 | 机构 + 居家单品 | **物业/小区 SaaS + 值班兜底**（它没占这个位） |
| 工艺 | 刺绣/TFP/针织/梭织/后整理/**丝印**/**激光** + 自有小批产线 + 测试能力 | 刺绣路线 + 单层一体织 |

**结论（不变）**：Wisbi 证明"织物传感做养老"**需求真实、居家市场最大**（其引用"71% 需护理者在居家"）；但它是**二值报警 + 单品**路线，我们是**连续分布 + 物业/小区服务**路线。**讲差异，不讲超越。**

---

## 五、待补情报（下次追踪清单）

| # | 事项 | 状态 | 获取途径 |
|---|---|---|---|
| 1 | Grabher Group 2025–2026 营收/员工/财务健康 | 未获取 | Northdata/奥地利 Firmenbuch（付费）；或接触时直接问 |
| 2 | Wisbi 是否发布新品 / 是否已升级传感器（如增压力分布） | 未证实 | 官网 News/Blog、行业展会 |
| 3 | Wisbi 中国是否有代理/竞品 | 未查 | 国内搜索 |
| 4 | Smart Care Assist 项目成果报告 | 未获取 | Interreg 项目页 / 官方海报文件 |
| 5 | Wisbi 全系列官方报价（机构级） | 未获取 | 需向 info@texible.com 询价 |

---

## 六、来源

- texible.com：home / about-us / projects / production / smart-textiles（2026-10-08 抓取）
- 英国经销商：willowhealthcaresupplies.co.uk（含价格 £255–315 不含 VAT）、manageathome.co.uk、medchemuk.com
- AAL 产品目录：aal-products.com（页面标注"Last updated 04.03.2022"）
- 奥地利经销商：georgegger.at（Wisbi PLUS 快速指南）
- 官方样册：TEXIBLE-Wisbi-PLUS / HOME（本地存档 `assets/Grabher智能织物调研/`）

---

## 七、修订历史

| 日期 | 版本 | 修改人 | 变更摘要 |
|---|---|---|---|
| 2026-10-08 | V0.1 | 传感前锋 | 初稿：公司（2016 因斯布鲁克衍生）、在售与价格锚点（£255–315）、HOME=WiFi+App、工艺扩至丝印/激光、待补清单 |

---

*V0.1 — 2026-10-08。基于 2026-10-08 公开网络信息核实；财务与新品部分受情报限制未证实，已在文中标注。*
