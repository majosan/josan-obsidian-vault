# Grabher 集团与智能织物落地路径全景分析
## 附：卡尔迈耶 4 篇智能纺织品证据链复盘 + 对南烯/织序的技术、产品、规模、市场四维对标

**编制**：Josan（委托 DSH / 传感前锋执行调研）
**日期**：2026-09-14
**调研对象（4 个指定来源）**：
1. [Knitting Industry：Overcoming the barriers of e-textile production（2021，卡尔迈耶官方演讲）](https://knittingindustry.com/interviews/overcoming-the-barriers-of-etextile-production/)
2. [Textile Focus：KARL MAYER's smart shirt with integrated sensors（2019-12-27）](https://textilefocus.com/karl-mayers-smart-shirt-integrated-sensors-opening-new-applications/)
3. [World of Technical Textile：KARL MAYER and Grabher support wearables projects with competence platform（2024-03-13）](https://worldoftechnicaltextile.com/karl-mayer-and-grabher-support-wearables-projects-with-competence-platform/)
4. [Grabher Group 官网 www.grabher-group.company](https://www.grabher-group.company/)（含子公司 V-trion / Texible / 24sens / Vprotect 独立站点）
**关联文档**：[卡尔迈耶经编机设备与技术分析.md](卡尔迈耶经编机设备与技术分析.md)
**说明**：本机沙箱封了常规 HTTPS 客户端，本次改用 Node 自带 TLS 栈直读各站正文，**下列官网引文均为原文抓取**（非二手转述）。凡二手或推断均已标注。

> 📌 **本文件为独立可转发版本**（保留，便于单独分享/引用）。内容与《[卡尔迈耶经编机设备与技术分析.md](卡尔迈耶经编机设备与技术分析.md)》**第 14 节**同源，均为 2026-09-14 由 DSH 执行、以 Node 直读官网正文的同一批调研。
> **两份文件的关系**：本文＝Grabher 与"谁在做智能织物"这一问的完整答案，可单独转发；主报告＝卡尔迈耶设备/技术的完整答案（**其第 5、6、7、9 节**与本文件直接呼应），便于整体阅读。
> ⚠️ **同步提醒**：本文与主报告第 14 节目前内容一致。**若只更新其中一处，另一处会漂移**——需要更新时告诉 DSH，两处一并改。


---

## 0. 结论先行（14 条）

1. **Grabher 不是一个"做智能织物的纺织厂"，而是"欧洲智能纺织品的系统集成商 + 生态组织者 + 认证通道"**。它把 9 家实体、1 个国家级平台、22 个政府资助研究项目、1 个突尼斯实验室、1 个 IoT 实验室组装成一条"从纤维到医疗器械注册"的完整能力链。
2. **对你最有价值的一条**：Grabher 系公司 **Texible** 公开列出的五种制造工艺里，**刺绣（embroidery）居其一，且明确写着"导电与非导电纱线可按任意图案施加到底布上，图案可全自动大批量生产"**——你（织序）走的"刺绣锯齿走线三层织物"路线，**和欧洲这批最前沿玩家是同一条技术家族**，不是"土办法"。同时 Texible 的 **tailored fibre placement（TFP）** 条目里直接点名应用之一是"**textile heating elements（纺织加热元件）**"——**这才是发热布的正解工艺，而不是双针床经编**。
3. **保暖/发热布：走"刺绣 + TFP + 整面后整理导电"，不走经编整机**。Texible 的工艺清单给了明确答案：局部图案用刺绣/TFP，整面功能用纺织后整理（"整块织物做成导电或拒水"），大面积传感面用**梭织**（成本低、幅面大，他们举的例子是"平屋顶渗漏检测"）。
4. **护理床垫你有直接对标物**：Texible 自有品牌 **Wisbi** = "智能传感织物床垫插层"，检测**潮湿/体液/离床**并自动报警，还有 Home/Plus 两个版本和 Interreg 巴伐利亚-奥地利"**Smart Care Assist**"项目在跑。**这就是你 SKU-2 康养床垫的欧洲同题竞品**，且它已经被护理场景验证过。
5. **Grabher 的真正护城河是"认证 + 系统集成"，不是材料**：24sens 的长时程心电胸带已 **EU 认证**并与 Vorarlberg 医生做临床测试；Vprotect 直接开网店卖"**线上长时程心电 + 医生报告 €249**"。**医疗级认证是他们卖得出价的原因**——这条对你做养老床垫是可直接复制的路径提示（先做非医疗级报警功能，再逐步走认证）。
6. **规模真相：智能织物是"高混合、低产量"生意，不是产能生意**。Grabher 集团 1995 年起步、创始人 Günter Grabher 独资，而 24sens 在 Lustenau 的**生产团队只有约 15 人，计划到 2025 年底扩到最多 50 人**。**一家做了 30 年、客户含 Google/Red Bull/Microsoft 的欧洲龙头，生产团队只有十几个人**——这直接回答了"要不要为功能织物造一台专机"：**不要**。
7. **他们的商业模式是"孵化 + 品牌 + 独家权"，不是"一条产线卖布"**：24sens（心电）、Texible（工程服务 + Wisbi 品牌）、Vprotect（医疗电商）、Storex（纺织盐水电芯）、Basalt+（低碳建材）——**每个方向一个实体，各自融资/认证/卖货**。
8. **专利布局走的是"纺织工艺专利"，而且踩在你熟悉的地方**：Grabher 列出的 4 项专利里有 **WO2014028958A1 —— "电极用于原电池，至少部分刺绣表面是导电的"**，即**用刺绣做电池电极的全球专利**（官方另称"十年前拿到纺织与刺绣电极用于电池应用的全球专利"）。**刺绣导电结构是可以拿专利的**，这条对织序的专利布局是强心针。
9. **政府资助是他们的研发现金流**：官网列出 **22 个 FFG 项目（2021–2026）**，主题覆盖汗液分析、自供电传感、生命体征电极、桥梁监测、糖尿病支持、尿液中 CRP 检测（UriSens）、士兵生命体征、机器人抓取用自适应传感/执行皮肤、低压等离子印刷纳米油墨、液晶弹性体驱动纤维等。**"奥地利 FFG + Comet 卓越中心（TCCV）"这类项目经费，是他们养研发团队的方式。**
10. **生态组织权 = 定价权**：Grabher 是 **Smart-Textiles Platform Austria** 的发起方与所在地（Millennium Park 6, Lustenau），自称"**最大的智能纺织品研究与产业联盟**"，并运营 **Smart Textiles IoT Lab**、"Smart Embroideries Austria"网络、以及突尼斯 **Smart-Textiles Lab Tunisia**（E-Textiles/柔性传感器研究）。**谁组织生态，谁拿到第一手需求**。
11. **他们自己也承认成本压力**：创始人访谈里直言"生产挑战加大，受能源价格与工资上涨影响，**我们的竞争力受到强烈削弱**"。**这就是你的切入口**——中国侧的机会不是"再做一家智能织物公司"，而是**成为欧洲集成商的产能/器件供应方**（他们已经在突尼斯设点，说明外包是既定策略）。
12. **卡尔迈耶这条线现在完整闭环了**：设备商（KM，提供 EL/string bar/TEXTILE-CIRCUIT 打样能力）→ 集成商（Grabher，认证与系统集成）→ 终端（医疗/军警/汽车/航天）。**你之前问"卡尔迈耶为什么不做传感布"——答案是它把这一环交给了 Grabher 这类伙伴**：2023 年 5 月 KM 把 **MJ 52/1-S（138″/E28）** 交给 Grabher，由 Grabher 子公司 **V-trion** 做电导纺织品项目。
13. **要注意"叙事通胀"的坑**：v-trion 官网引用"全球智能纺织品服装市场 2025 年达 **1000 亿欧元**、复合增长率三位数"这类说法（转引自 Fortune Business Insights/Econotimes 等营销型报告）。**这类数字不可直接进 BP**；真正可验证的付费信号是：€249 的心电服务、EU 认证的医疗器械、C2C Material Health Gold、Ariane 火箭配套、2.5 kWh 储能电池独家供货权。
14. **最后一条判断**：**你缺的不是机器，是"应用场景 + 认证 + 客户关系"这三样**。Grabher 的路径证明：材料/器件只是入场券，**钱在"把钱花在认证和场景验证"的那一步**。

---

## 1. 四个来源各自的价值（逐站精读）

### 1.1 Knitting Industry（2021）：卡尔迈耶对电子纺织品的官方技术口径

**这是"卡尔迈耶怎么看 e-textile"最完整的一手材料**，讲者是 **Tony Hoojimeijer（卡尔迈耶北美总裁）**，场合为 Techtextil & Texprocess 北美网络研讨会（2021-03-25 首播，报道 2021-04-06）。

核心论点（原文口径）：
- **壁垒在哪**："电子纺织品工艺成本非常高，因为生产复杂、**传感器的附加工艺需要多步流程**；用户侧还有可洗性与穿着舒适性问题。"
- **解法**："**找一个以量为导向的生产工艺，并减少各部件的生产步骤**；**把功能做进织物，而不是事后加上去**（Building the functionality into the fabric, instead of adding it to the fabric later）——这正是经编路线能提供的。"
- **经编凭什么**：全幅平行送经、多梳栉做复杂运动、成圈结构天然四面弹、**可把多种不同纱线送入同一编织区**；医用领域甚至有"**单次通过就织出人造血管**"的案例。
- **已有成果（关键）**：卡尔迈耶研发人员**已经做出把四条独立导电纱电子回路（导电纱按普通纱处理）在单步生产中织入织物的面料**。
- **产能口径**：**200 英寸幅宽、30 针/英寸、3,000 rpm、6,000 根纱同时成圈**；"**string bar 可以把特定导电纱图案点状布置在织物各处，全部在机上实时完成**"。

> **对你的意义**：这就是"刺绣 vs 经编"之外的第三条路——**用经编 + string bar 做功能纱线的定点铺放**。它比刺绣快得多，但**精度是"梳栉级/分区级"，不是逐针级**（详见卡尔迈耶报告 5.4 节）。

### 1.2 Textile Focus（2019-12-27）：TEXTILE-CIRCUIT 的产品化历程

这篇补上了**卡尔迈耶做智能纺织品的完整时间线与产品清单**：
- **2018 年起**，卡尔迈耶以 **TEXTILE-CIRCUIT** 为概念开发"可导电功能经编织物"的高效生产技术。
- **特点**：导电纱在**经编过程中直接嵌入**，**可定位于任意位置与任意设计**；传感器、导体、线圈等功能元件**放在需要的地方**；**无需任何额外生产工序**，织物的纺织特性完整保留。
- **第一阶段产品**：**用于远程操控机器人的舒适袖口** + **用于智能手机感应充电的纺织充电站**。
- **第二阶段（后续项目）**：**带测量功能的智能衬衫**，在 **ITMA 2019** 面向大众演示——**测量心率、织物湿度、皮肤温度**；传感器**单步集成**，信号经**绝缘导体**传到移动电子单元，经**蓝牙**在手机上查看；现场把一位骑行者的数据投在大屏上。
- **市场信号（重要）**：产品开发人员 **Sophia Krinner**（Product Developer, Textile Technology）说："在与各行业用户交流后，**我对他们提出的用法之多感到惊讶**"，并认为**运动服、工装、医疗保健**潜力最大；**她还收到很多"想买这种导电经编织物"的询价**。
- **下一步方向**：**改进织物的后整理**、**优化传感器技术**。

> **对你的意义**：① 卡尔迈耶**收到了买布询价仍然没有卖布**——这进一步坐实"整机厂不与客户争利"的判断；② "下一步是后整理与传感器技术"这句话说明：**导电织物的难点在"后整理 + 传感一致性"，不在织造本身**——这跟你遇到的"跨点一致性差"是同一个问题；③ **注意时间**：这是 2019 年的成果，**六年后仍未见其商业化**，说明这条链的商业化门槛确实高。

### 1.3 World of Technical Textile / Knitting Industry（2024-03）：卡尔迈耶 × Grabher 的能力平台

两份报道内容一致，关键事实：
- "近年来，卡尔迈耶在**可穿戴领域**打出了名气。其 **TEXTILE MAKERSPACE 的 TEXTILE-CIRCUIT 部门**已经生产了**多种电导性经编织物**，应用包括**传感器衬衫（sensor shirt）、手势控制系统、导电充电站**。"
- 为推动该方向，卡尔迈耶与**奥地利 Grabher 集团**签署合作协议，**交付一台 MJ 52/1-S** 给这家位于 Lustenau 的高科技纺织专家；**总经理 Günter Grabher 于 2023 年 5 月正式启用**该智能纺织品项目关键设备。
- MJ 52/1-S 规格与能力：**138″、E 28**，"把**导电材料直接织进织物表面——恰好放在需要的位置、以所需的结构**"；**定制化纤维定位的技术基础是卡尔迈耶的 string bar 技术**；该机"参与多项研究项目，也可用于新项目"。
- **合作结构**：卡尔迈耶（Textile Makerspace/Textile-Circuit）＋ Grabher（**子公司 V-trion**，研究机构性质，做客户定制方案）；双方组建"**smart textiles competence team**"，也对外部研究网络之外的客户开放。
- **Klaus Mayer 侧人员**：**Franziska Guth**（Product Developer, Textile Technology）为公开联系人。

> **对你的意义**：这是一条**可以照抄的合作模式**——设备商出机器与工艺、集成商出认证与应用、研究子公司出项目交付。**南烯/织序如果要切入欧洲链，最现实的角色就是"器件/产能供应方"或"联合打样方"**。

### 1.4 Grabher Group 官网：全文拆解（见第 2 节）

---

## 2. Grabher 集团四维全景（技术 / 产品 / 规模 / 市场）

### 2.1 规模与组织结构（"小团队 + 大生态"）

| 维度 | 事实 | 来源 |
|---|---|---|
| 起点 | **1995 年**在 Vorarlberg 州 **Lustenau** 创立，从个体作坊起步，如今是家族企业 | 官网 About us |
| 主体 | **Grabher Group GmbH**（Augartenstraße 27, Lustenau）；Firmenbuch **FN 181850b**，登记于 **1999-04-28**，注册资本 **4 万欧元**，经营范围写的是"**经营一家剪毛作坊（Scherlerei）**" | evi.gv.at（奥地利工商登记公示） |
| 控制人 | 管理人 **Günter Grabher（自 1999 起）**、**Jörg Kathan（自 2021 起）**；唯一股东 **Günter Grabher** | 同上 |
| 集团实体数 | 官网 COMPANIES 页列 **9 个实体**；但 24sens 页面写"Grabher Group 联合**六家公司**"（口径不一，见第 7 节） | 官网 |
| 员工规模（唯一可得的硬数字） | 24sens 在 Lustenau 的**生产团队约 15 人，计划 2025 年底扩至最多 50 人**（另加销售团队） | Lustenau 官方杂志专访 |
| 面积/厂址 | Lustenau（总部 + Millennium Park）、Hohenems、Dornbirn；另在**突尼斯 Monastir** 设 Smart-Textiles Lab | 官网 |
| 荣誉 | 创始人获 **CEO Today Global Awards 2023**；集团称是"**全球首家能实现 CO₂ 中和生产**"的企业；**2021 年起 100% 使用奥地利绿电** | 官网 + 专访 |

**9 个实体及其分工（官网原文）**：

| 实体 | 地点 | 定位 |
|---|---|---|
| **Grabher Group GmbH** | Lustenau | 纳米空气过滤 / 微米液体过滤（集团主体） |
| **Vprotect GmbH** | Lustenau | **医疗与健康护理产品 / Smart-Textiles 系统**（现运营"线上心脏病学"电商） |
| **24sens GmbH** | Lustenau | **生命体征监测 / 柔性传感器技术**（smartcorCONTROL 心电胸带） |
| **Texible GmbH** | Dornbirn | **睡眠监测 / 智能纺织品开发**（工程服务 + Wisbi 品牌） |
| **V-trion GmbH**（官网另见 V-trion textile research） | Lustenau（Millennium Park 15） | 智能纺织品**顶层研究**（负责人 **Dr. Gaffar Hossain**；联系人 **Enrico Grabher**） |
| **RAC Advanced Composite GmbH** | Lustenau | 碳纤维复合 / 纺织增强混凝土 |
| **Fussenegger & Grabher GmbH** | Dornbirn | 防护工装 / 高科技纺织品 |
| **Vetter & Grabher GmbH** | Hohenems | 非洲蕾丝后整理 / 施华洛世奇水晶制品 |
| **emstex GmbH** | Hohenems | 生态染色印花技术与环保后整理 |
| **Smart-Textiles Lab Tunisia** | 突尼斯 Monastir | **电子纺织品研究 / 柔性传感器研究** |

### 2.2 技术能力栈（这是最值得你逐条对照的部分）

**A. 纺织后整理与涂层（集团老本行，30 年积累）**
- **等离子处理**：卷对卷系统、**24 米长等离子通道**、可处理**幅宽至 1.60 m** 的基材；效果**耐洗**（60℃ 多次洗涤后仍保持）；可处理 **PES、PA、m-aramid、p-aramid、PBI、液晶聚合物纤维**及其混纺。
- **化学后整理**：两台定型机（**Santex** + **Monforts Montex 6400**），**最大成品幅宽 220 cm**；可做无氟拒水拒油、阻燃涂层、抗菌、抗皱、丙烯酸、抗静电、易护理、防滑、易去污、柔软、防蚊等。
- **机械后整理**：**Vollenweider 双刀剪毛机**等。
- **熔喷无纺布**：MELTECH（100% PP 防水透气膜）、MELPLA bond（弹性粘合无纺布）、**MELPLA SE（CFRP 用环氧树脂无纺布增强）**。

**B. 智能纺织品制造工艺（Texible 官网原文列出 5 种 —— 建议你逐条比对）**

| 工艺 | Texible 原文要点 | 对你（南烯/织序）的意义 |
|---|---|---|
| **刺绣（Embroidery）** | "机绣技术可把**导电与非导电纱线**按多种图案与序列施加到底布上，**在纱线设计与排布上具有高灵活性**；图案可**全自动大批量生产**" | ⭐⭐⭐⭐⭐ **这正是你的技术路线**；"全自动大批量"说明刺绣并非只能做样品 |
| **Tailored Fibre Placement（TFP，定制纤维铺放）** | "可**按受力情况铺设纤维束**，走**任意弯曲路径与极小半径**；主要应用包括**玻纤/碳纤增强塑料构件**，以及**纺织加热元件**" | ⭐⭐⭐⭐⭐ **发热布的正解**：按图案铺发热纱/电极，直接对应你的 CNT 加热布 |
| **针织（Knitting）** | 成圈结构，**极柔软、延展性好、用途广** | ⭐⭐⭐ 即纬编/横编路线（电热服装主流结构） |
| **梭织（Weaving）** | "可**低成本生产大面积机织传感面**"，举例"**平屋顶渗漏检测**" | ⭐⭐⭐⭐ 大面积阵列（你的 1024 点垫）在欧洲是这样做的 |
| **纺织后整理** | "若整个织物都需要某种功能，与后整理伙伴合作，可在**纤维层面实现整面功能集成**，例如整块织物做成**拒水或导电**" | ⭐⭐⭐⭐ "整面导电"是另一条思路：不做图案，直接整面处理 |
| 配套能力 | **传感器**（湿度、心率、温度、汗液、**压力**、张力）／**执行器**（加热、制冷、振动、刺激）／**接口**（纽扣、拉链、磁性、压接、**刺绣**） | ⭐⭐⭐⭐ 这是"功能菜单"，可直接对齐你的产品定义 |
| 工程服务 | 迭代式开发、跨学科团队、**固件/IT/App 开发**、质量管理与标准、"**Made in Europe**"、原型→小批量的**自有小规模产线**（一栋旧针织厂改造的办公楼） | ⭐⭐⭐⭐ 说明人家卖的是**"从想法到量产"的工程服务**，不是布 |

**C. 研发体系（政府项目 + 平台 + 专利）**

- **22 个 FFG 资助项目（2021–2026）**，主题（原文摘录，与你的方向直接相关的已加粗）：
  **尿液中 C 反应蛋白（CRP）检测的智能纺织传感器**；**汗液分析智能纺织传感器**；**自供电智能纺织传感器**；**生命体征监测用智能纺织电极**；**糖尿病支持的智能纺织传感器**；**桥梁监测用智能纺织传感器**；**面向机器人抓取（分拣/回收）的自适应纺织传感与执行皮肤**；**运动数据智能纺织分析**；**智能纺织能量收集系统**；**士兵生命体征监测**；**军用飞机病毒防护系统**；**低碳（C-HOOVER 直接空气捕集）**；**液晶弹性体驱动纤维**；**低压等离子印刷纳米油墨系统**；**功能纳米复合材料集成**；**纺织混凝土碳复合材料**；**医用防护口罩（Vorarlberg）**；**数字产品护照（Digital Product Passport Austria and Beyond）**；**纤维无缝身份编码（价值链与产品生命周期）**；**TCCV / TCCV 2 —— Comet 卓越中心智能纺织项目**；**气凝胶纤维（智能 CO₂）**。
- **专利（官网列 4 项）**：
  - **WO2014028958A1** —— "**用于原电池的电极，至少部分刺绣表面是导电的**"（标签：New Batteries）→ **刺绣导电电极的全球专利**
  - **WO2020161134A1** —— "**压电纺织能量收集器的制造方法及智能纺织传感器**"（Energy Harvesting）
  - **WO2019076823A1** —— 等离子处理制备拒水纺织表面的方法（Cradle to Cradle）
  - **EP3684985A1** —— 用粗纱（rovings）制造混凝土基体增强体的方法（Textile-Concrete）
- **平台与组织权**：
  - **Smart-Textiles Platform Austria**（所在地 Millennium Park 6, Lustenau）："**通过成员整合整条纺织价值链的能力**"，目标是提升纺织业创新动力、催生新产品/工艺/服务与**创新初创企业**；创始人即 Günter Grabher。
  - **Smart Textiles IoT Lab**（Millennium Park）：与 **Smart-Textiles Platform Austria** 合址；官网称有"全球首个'有感觉的计算机' **L.U.C.E.S.S.**（Lustenauer Computer Emotion Sensor Systems）"，用智能纺织品把人的情绪传给 AI。
  - **Smart Embroideries Austria** 网络（24sens 页面提到）：把纺织专长带给其他行业，**为刺绣开辟新应用**——**这条网络的名字本身就说明了"刺绣 = 电子纺织品主流工艺之一"**。

**D. 终端与在售产品（证明"能力 → 钱"的路径）**

| 产品 | 归属 | 关键事实 |
|---|---|---|
| **smartcor CONTROL 心电胸带** | 24sens | 房颤（Vorhofflimmern）检测；**24/7 长时程记录**；传感器 + 记录单元；可穿数周至数月、**可水洗**、两种尺码无性别区分；**已通过 EU 认证**，正在 Vorarlberg 与医生做测试；**生产在 Lustenau**；计划加入心率/呼吸/睡眠监测 |
| **线上长时程心电 + 医生报告** | Vprotect | **标价 €249**，面向消费者在网店直销（"您的线上心脏病学"）；另有口罩等品类与 EU 合规声明 |
| **Wisbi 智能床垫插层** | Texible | 检测**潮湿、体液、离床**并自动报警；Home / Plus 两版（有英文/德文样册）；参与 **Interreg 巴伐利亚-奥地利 "Smart Care Assist"** 护理床研究项目 |
| **ANGEL 智能工装** | Texible × Adresys | 通过集成电极检测**电击事故或跌倒**并自动启动救援链；带手动报警与作业计时器 |
| **Stappone 足底压力传感鞋垫** | Texible | **整面纺织压力传感器**置于鞋垫内；因足部机械负荷大，宣称**耐久性比标准薄膜压力传感器高 50 倍** |
| **WAIBROsports 腰带** | Texible | 让视障运动员独立运动 |
| **EQUUSIR 生物毯（马用）** | Texible | 通过直流系统把电脉冲送入高密度线圈刺激马匹生命机能 |
| **纺织盐水电芯（Storex）** | V-trion + Storex Power GmbH | **2.5 kWh**，用于建筑储能；**不含锂/镍/钴**、不可燃、可完全放电、**全 EU 生产**；**Grabher Group 独家拥有纺织部件制造权**；香港投资人 **X.D. Yang** 2022 年在维也纳成立 STOREX Power GmbH，追加 **150 万欧元**；前身是 **V-trion 与因斯布鲁克大学 15 年研究合作**＋"**十年前获全球专利的纺织与刺绣电池电极**" |
| **电磁屏蔽织物（航天）** | Grabher | 为 **Ariane 火箭**供货；"**上一枚火箭带着我们的纺织品升空，飞向木星，预计 2030 年抵达**" |
| **CBRN 防护帐篷（PROTENT）** | Grabher | "**全球首个可透气的防护解决方案**"，家用"安全屋"版本已在 Krisenvorsorge.at 上架 |
| 曾服务客户（官网/地方媒体口径） | 集团 | **Google、Red Bull、Microsoft** 等世界级企业的产品开发；展示品包括**带刺绣腱线的**心脏瓣膜植入物**、**带传感器的儿童安全座椅**（锁车时若儿童仍在座即报警）、**带刺绣织物的智能料盒**（螺丝将用尽时提示补货）、**永久阻燃的气体处理纺织品** |

### 2.3 市场维度：他们到底在哪个市场赚钱

1. **不是"纺织品市场"，而是"受监管的功能部件市场"**：医疗器械（心电、CRP、糖尿病、汗液、绷带）、军警防护（CBRN 帐篷、士兵体征、军机病毒防护）、汽车/航空（儿童座椅传感、阻燃、电磁屏蔽、复合材料）、建筑（纺织混凝土、桥梁监测、屋顶渗漏）、能源（储能电池、能量收集）。**共同点：有标准、有认证、有明确买单方（B2B/B2G），单价高、批量小。**
2. **可验证的付费信号（而非营销数字）**：€249 的线上心电服务；EU 认证的医疗器械；C2C Material Health Gold 认证；Ariane 火箭配套；Storex 电池双层级投资与独家制造权。
3. **市场叙事要打折**：v-trion 站点引用"智能纺织品服装市场 2025 年 **1000 亿欧元**""复合材料 2025 年 **800 亿美元**"等说法，来源是**营销型市场报告**（Fortune Business Insights、Econotimes、Innovation in Textiles）。**这类数字不能进 BP**，只能用"结构性判断"（高增长、碎片化、认证驱动）。
4. **他们的自我认知是"Made in Europe + 可持续"**：官网反复强调绿电、C2C 认证、CO₂ 中和、EU 生产——**这是欧洲的溢价来源，也是它的成本软肋**（见第 2.4 节）。
5. **他们的生产压力（创始人原话）**："生产挑战加大，受**能源行业变化与高工资调整**影响，**我们的竞争力受到强烈削弱**。"——**这是你最重要的机会窗口**。

### 2.4 创始人视角（Günter Grabher 专访要点）

- 他的公司是"**智能纺织品与创新的全球枢纽**"，他本人 2023 年获 **CEO Today Global Awards**；在**医学、纳米技术、轻量化**领域有无数项目；另办初创 **Basalt+**，做**把混凝土建筑 CO₂ 排放降低 50%** 的建材。
- **为什么 Vorarlberg 能做成**："这里根植于纺织业与机械制造的创新力；**没人用标准设备（niemand arbeitet mit Standardanlagen）**；三国交界处网络强，这正是 Smart Textiles Platform 得以形成的原因。"
  > ⚠️ **"没人用标准设备"这句话，值得你反复读**——欧洲智能纺织品玩家用的是**定制化、多工艺混合的小型产线**，而不是一台"专用量产机"。
- **对成本的态度**：直言竞争力受能源与工资侵蚀（见上）。

---

## 3. 把四个来源串起来：一条完整的"智能纺织品产业分工链"

```
【设备与工艺能力】              【集成 / 认证 / 生态】                【终端与付费】
KARL MAYER (德国)               GRABHER GROUP (奥地利 Lustenau)       医疗 / 军警 / 汽车 / 航天 / 建筑
├ TEXTILE-CIRCUIT 打样           ├ V-trion   研究（Dr. Gaffar Hossain） ├ 24sens  心电胸带（EU 认证）
├ MJ 52/1-S + string bar ──────▶ ├ Texible   工程服务 + Wisbi 品牌      ├ Vprotect €249 线上心电
├ EL 花型驱动 / AFC / 选纬        ├ 24sens / Vprotect / RAC / ...       ├ Storex  2.5 kWh 储能电池
└ Textile Innovation Center      ├ Smart-Textiles Platform Austria ★   ├ Ariane 火箭电磁屏蔽织物
                                 └ Smart Textiles IoT Lab + 突尼斯 Lab  └ Google / Red Bull / Microsoft
```
**这张图回答了你最初的问题**：卡尔迈耶不做传感布/发热布，是因为**它把自己定位成这张图的左上角**——出机器、出工艺、出打样；而**把"认证与场景"这一环交给 Grabher 这类集成商**。你如果要做产品，**对手/伙伴是 Grabher 这一格，而不是卡尔迈耶那一格**。

---

## 4. 与南烯 / 织序的四维对标

| 维度 | Grabher 系（对标对象） | 南烯 / 织序（你） | 差距性质 |
|---|---|---|---|
| **技术** | 刺绣 + TFP + 梭织 + 针织 + 整面后整理（等离子/涂层/阻燃）**五工艺并行**；22 个 FFG 项目；4 项专利（含刺绣电池电极全球专利） | 三层织物刺绣锯齿走线（1024 点）；CNT 纱加热布；**自研双针床经编机（失败）** | ⚠️ **路线选择问题**：你的刺绣路线是对的、TFP 是缺的、双针床是错的 |
| **产品** | 心电胸带、护理床垫插层、智能工装、足底压力鞋垫、储能电池、航天屏蔽织物、CBRN 帐篷 | 传感垫 SKU-1/2、触觉手套、CNT 加热 Demo（眼罩/暖宫包/护膝…） | ⚠️ **产品成熟度差 1–2 个阶段**：你在 Demo，他们在认证/量产/在售 |
| **规模** | 集团 9 实体；覆盖 3 国 + 突尼斯实验室；**但单个产品线团队仅 15→50 人** | 团队小；南烯累计投入数千万元；织序零营收、demo 级 | ✅ **规模差距没想象中大**——关键在于**他们把研发放在政府项目里、把生产放在网络里** |
| **市场** | 医疗（EU 认证）/ 军警 / 汽车 / 航天 / 建筑；客户含 Google、Red Bull、Microsoft；**卖"认证过的功能部件 + 工程服务"** | 目标：养老床垫 + 机器人遥操作数采 + 康养；**尚无认证、无标杆客户** | ❌ **最大差距在市场与认证**，不在技术 |
| **生态位** | **平台组织者**（Smart-Textiles Platform Austria、IoT Lab、Smart Embroideries Austria、突尼斯 Lab） | 单点自研（连经编机都想自己造） | ❌ **生态位置差一个维度** |

### 4.1 你该学的 5 件事

1. **学他们的"工艺菜单"逻辑**：不押注单一工艺，按产品选工艺（局部图案→刺绣/TFP；大面积→梭织；整面功能→后整理；柔软可拉伸→针织）。**你现在的错误正是"为一个产品去造一种机器"。**
2. **学他们的"认证即产品"**：24sens 的路径是"做出器件 → 拿 EU 认证 → 医院测试 → 进 DACH 市场"；**认证本身就是资产**。养老床垫可以先做"非医疗级报警"，再规划认证路径。
3. **学他们的"一方向一实体"**：心电一家、工程服务一家、医疗电商一家、电池一家。**南烯/织序的资产包在出售叙事里同样应该"按方向拆分估值"**，而不是打包成一个说不清的整体。
4. **学他们的"政府项目养研发"**：22 个 FFG 项目 = 研发费用外部化。**中国侧对应物是科技型中小企业创新基金、地方专项、产学研合作（你已经有的东华大学背书）**——把研发写进申报书，比自筹更现实。
5. **学他们的"平台思维"**：他们最值钱的资产不是机器，是"**谁在做智能纺织品都得来找我**"的位置。**你可以从很小的切口复制**：做"长三角柔性传感织物打样与测试共享平台"，把同行的打样需求接住（顺便收集需求情报）。

### 4.2 你不该学的 2 件事

1. **不要学"自己造设备"**：他们明确说"**没人用标准设备**"，但那是**多工艺混合的小型产线**（刺绣机、针织机、梭织机、后整理设备），**不是自研一台整机**。你的双针床经编机是这条路上的反面教材。
2. **不要学"用营销数字做 BP"**：他们的官网也贴"1000 亿欧元市场"，但**真正支撑估值的证据全是硬的**（认证、独家权、火箭订单、专利）。**你的 BP 里"1000 元/㎡""覆盖 XXX 亿市场"这类数字要换掉。**

---

## 5. 直接可执行的动作建议

**P0（接触与验证，2–4 周内）**
1. **接触 Grabher 生态的"研发入口"而不是销售入口**：V-trion（**Dr. Gaffar Hossain**、**Enrico Grabher**；Millennium Park 15, Lustenau）是明确对外做联合项目的机构；Texible（info@texible.com，Widagasse 9, Dornbirn）公开说"从想法到量产一站式"，**它就是最合适的对接方**。话术建议：**"我们是中国侧的柔性传感织物与加热织物制造方，希望成为你们的器件供应商/联合开发伙伴"**，不要一上来谈卖公司。
2. **先看 Wisbi**：下载 Texible Wisbi Home/Plus 样册（官网有英文版[官网](https://www.texible.com/smart-textiles/)），逐条对比你的 SKU-2 康养床垫——**它的功能集（潮湿/体液/离床 + 分级告警）和你 PRD 里的设计重合度极高**，这是最快的竞品情报来源。
3. **把"刺绣 + TFP"作为发热布与传感阵列的正式工艺主线写进内部立项**（TFP 明确列出"纺织加热元件"应用），**双针床经编机项目按既有"阶段门"原则停止追加投入**。

**P1（能力补齐，1–3 个月）**
4. **补 TFP 能力**：TFP 是"按受力/图案铺纤维束、可极小半径弯曲"，对应你 CNT 发热纱与电极布线；**先找国内 TFP/刺绣代工打样**（比买设备便宜一个数量级）。
5. **补"整面功能化"能力**：Grabher 的看家本领是**后整理**（等离子、涂层、阻燃、整面导电）。**你的"单层一体织"若配合整面导电/阻燃后整理，故事会更完整**——找国内后整理厂做一轮工艺窗口测试。
6. **认证路径规划**：明确"养老床垫走非医疗器械（报警/监测）→ 再评估二类器械"的路线与成本，参考 24sens 的"先认证、再临床、再 DACH 市场"节奏。

**P2（生态与叙事，长期）**
7. **生态位选择**：与其做"又一个智能织物公司"，不如明确二选一——**(a) 欧洲集成商的中国器件/产能伙伴**（利用他们自认的成本劣势 + 他们已有突尼斯外包先例）；**(b) 国内细分场景的自有品牌**（如康养床垫 + 触觉数采），**但必须补认证与标杆客户**。
8. **对外叙事更新**：把"我们自研经编机"从卖点里删掉，换成"**我们掌握刺绣/TFP 定点铺纱 + 电极引出 + 逐点标定的织物集成能力，设备可替换**"。这一句和 Grabher 的实际做法完全一致。
9. **专利动作**：Grabher 拿的是"**刺绣导电电极**"专利——**你的"物理↔虚拟传感点一一对应映射"与"锯齿走线刺绣"同样属于可专利的纺织工艺方向**；按 `03-专利与IP` 的既有规划，**优先把"刺绣导电阵列 + 映射表"这一族抢申请日**。

---

## 5.5 专题核查：经编（warp knitting）到底做没做传感布 / 加热布？（逐站关键词扫描）

> **追问来源**：Josan 直接提问——"这几个网站新闻和 Grabher 公司到底有没有用经编机技术做出传感布或者加热布？"
> **方法**：把 4 个指定来源 + Grabher 系全部官网（grabher-group.company 各页、texible.com、24sens.com、vprotect.at、v-trion.com）正文抓取后，用正则逐站扫描两组关键词：**经编组** = warp / knit / Raschel / Karl Mayer / Wirk；**加热组** = heat / Heiz / warm / thermo / Wärme。结果如下（均为原文匹配，非推断）。

### 5.5.1 扫描结果一览

| 站点 | 经编组命中 | 加热组命中 | 判定 |
|---|---|---|---|
| **Knitting Industry 2021**（卡尔迈耶官方演讲） | **密集命中**："Versatility of **warp knitting** offers high potential for the incorporation of electronic circuits based on conductive yarns"；"This is what the **warp knitting route** offers"；"four separate electronic circuits based on conductive yarns … knitted into a fabric during **single step production**" | 无（与加热无关） | ✅ **经编做传感/导电布 = 有，明确** |
| **Textile Focus 2019**（TEXTILE-CIRCUIT 智能衬衫） | **密集命中**："producing **functional warp knits with electrical conductivity** under the concept of TEXTILE-CIRCUIT"；"conductive yarns can be incorporated directly into the textile during the **warp knitting process**"；"enquiries about buying the conductive, **warp-knitted textiles**" | 命中全部是站内其他文章的 "heat-setting" 噪音，**与本文无关** | ✅ **经编做传感布 = 有；无加热布内容** |
| **World of Technical Textile 2024**（KM × Grabher） | **密集命中**："electrically conductive **warp-knitted** items … including a **sensor shirt**, a gesture control system and a conductive charging station"；MJ 52/1-S "produces a wide range of **warp-knitted fabrics** and incorporates conductive material **directly into the textile surface**" | 无（与加热无关） | ✅ **经编做传感/导电布 = 有；无加热布内容** |
| **grabher-group.company**（全部子页） | **零命中**（warp / Raschel / Karl Mayer / Wirk 一次都没出现） | 无"加热布/发热织物"表述 | ⚠️ **Grabher 自己的官网从不自称做经编** |
| **texible.com**（Grabher 系） | 零命中 | 仅 **执行器（Actuators）**一栏出现 "Heating, cooling, vibrating or stimulating"（通用能力表述） | ⚠️ **加热只是能力项，且未指定经编工艺** |
| **v-trion.com**（Grabher 研究机构） | 零命中 | ✅ **关键命中**："**Shuttle Embroidery Technology** … conductible threads, wires or **heating conductors** are placed onto the support material employing computer operated **embroidery machines**" | 🔴 **加热导体的实际工艺 = 梭式刺绣机，不是经编** |
| **v-trion.com**（TFP 技术段） | 零命中 | 同上（TFP 明确"基于服装业的刺绣机改造"） | 🔴 **TFP 也是刺绣机衍生的工艺** |
| **24sens.com / vprotect.at** | 零命中 | 无 | —（终端产品公司，不涉及织造工艺） |
| **卡尔迈耶官网站内搜索 "heatable"** | — | **0 结果** | 🔴 **"可加热织物"在卡尔迈耶官方文本中不存在** |
| **卡尔迈耶官网站内搜索 "heating"** | — | 42 结果，但逐条看全是**机器热交换器**（heat exchanger for water conditioning）、**热定型**（heat-setting）、**调温面料**（heat-regulating double cloth） | 🔴 **没有一条是"发热布"产品** |

### 5.5.2 三条结论（直接回答提问）

**① 经编做"传感布/导电布"——有，而且是完整的官方证据链。**

卡尔迈耶的 **TEXTILE-CIRCUIT**（2018 年起）做的就是这件事，原文措辞是 "electrically conductive **warp-knitted** items"，产出物已经包括：
- **传感器衬衫（sensor shirt）**：测心率、织物湿度、皮肤温度，ITMA 2019 现场演示，蓝牙上传；
- **手势控制系统**；
- **导电充电站**（手机感应充电）；
- **远程操控机器人的舒适袖口**；
- **四条独立导电回路单步织入一匹布**（2021 年披露）。

而且这条线**已经在 Grabher 落地**：2023 年 5 月卡尔迈耶把 **MJ 52/1-S（138″ / E 28）** 交给 Grabher（**MJ = 多梳贾卡拉舍尔机 = 拉舍尔经编机**，卡尔迈耶官网把 MJ 系列归在"经编机 > 花边机"目录下），用 **string bar 技术**把导电材料"织到恰好需要的位置"。

> **所以答案：有。传感布/导电布用经编做，是卡尔迈耶官方验证过的路线，并且在 Grabher 有实体机。**

**② 经编做"加热布"——四个来源里，零证据。**

- 卡尔迈耶官网：**heatable 搜不到**；**heating 的 42 条命中全是热交换器 / 热定型 / 调温面料**，没有发热布产品；
- Grabher 系全站：没有"发热织物 / 加热布"的任何产品表述；**4 项专利里没有经编加热专利**（刺绣电池电极、压电能量收集、等离子拒水、纺织混凝土）；**22 个 FFG 项目里也没有"经编加热织物"**；
- 三篇新闻：加热相关词汇要么无关（heat-setting 噪音），要么根本没有。

**③ Grabher 的加热布（以及大部分导电布）实际走的是"刺绣 + TFP"，不是经编。**

V-trion 官网把工艺讲得很直白：
- **Tailored Fiber Placement**："**基于服装纺织业使用的刺绣机**，经改造后用于铺放并缝合纤维粗纱"；
- **Shuttle Embroidery Technology**："我们专门**借助刺绣机**开发与生产智能纺织品。在此过程中，**导电线、导线或加热导体**由电脑控制的机器铺放到基材上，再用多种缝纫与刺绣技术固定，实现耐久且高柔性的集成。"
- Texible 的生产页同样把"刺绣"列为五种工艺之一，并把"**纺织加热元件（textile heating elements）**"归到 **TFP** 名下。

### 5.5.3 一句话对照表（谁用什么工艺做了什么）

| 目标产品 | 有公开先例的工艺 | 证据方 | 有经编先例吗？ |
|---|---|---|---|
| **导电/传感布**（传感器衬衫、手势控制、导电垫） | **经编（warp knitting）+ string bar 定点铺纱** | 卡尔迈耶 TEXTILE-CIRCUIT（官方新闻 + 2021 演讲 + 2024 合作） | ✅ **有** |
| **加热布 / 加热元件** | **刺绣（shuttle embroidery）+ TFP** | Grabher / V-trion 官网原文（"heating conductors" 由刺绣机铺放） | ❌ **无** |
| **大面积压力传感面** | **梭织**（低成本大面）+ 整面后整理 | Texible 官网（举例：屋顶渗漏检测） | ⚠️ 未见于经编 |
| **可穿戴体征电极 / 心电** | 刺绣电极 + 系统集成 + 认证 | 24sens（EU 认证心电胸带）、Grabher 专利 WO2014028958A1 | ❌ 未见于经编 |

### 5.5.4 对南烯 / 织序的直接含义

1. **"经编做传感布"这条路是真实存在的**——如果坚持经编，对标物是**卡尔迈耶的多梳拉舍尔 + string bar 定点铺纱**（MJ 系列 / 花边机家族），**不是双针床间隔织物机，也不是普通特里科**。门槛在于：**string bar 是"梳栉级 / 分区级"定点，不是逐针级**（见《卡尔迈耶经编机设备与技术分析.md》5.4 节），做 1024 点可寻址阵列仍需后道或刺绣补齐。
2. **"经编做加热布"没有先例**——双针床上做的"加热布专机"，**连一个可对标的案例都找不到**；而 Grabher 这种最前沿玩家做加热，用的是**刺绣 / TFP**。这条证据基本替你回答了"双针床方向对不对"。
3. **刺绣路线被 Grabher 的官网原文直接验证**：他们用的就是"**刺绣机 + 导电线/加热导体 + 电脑控制**"——**和织序的锯齿走线刺绣是同一工艺家族**。差距不在工艺，在**后整理（整面功能化）、TFP 补位、认证与场景**。
4. **如果要做加热布，优先验证顺序**：① 刺绣 / TFP 铺加热导体（对 Grabher 有先例，可打样）→ ② 整面后整理（Grabher 的看家本领：等离子 / 涂层 / 阻燃 / 整面导电）→ ③ 电极引出与电阻一致性测试 → ④ 才谈设备采购。**经编整机在这条链里不是必需品。**

---

## 6. 关键洞察（给你的一句话版）

> **卡尔迈耶证明了"能织出来"，Grabher 证明了"怎么卖出去"——而这两件事中间隔着的，是认证、场景和客户关系，不是机器。**
> 你现在的处境是：**技术路线里有一条是对的（刺绣），有一条是缺的（TFP/后整理），有一条是错的（双针床经编机）；而商业上缺的是认证与标杆客户。** 资源应该按这个顺序重排。

---

## 7. 证据强度与不确定项

| 论断 | 强度 | 说明 |
|---|---|---|
| Grabher 集团 9 个实体、各自定位、地址 | **强** | 官网 COMPANIES 页原文抓取 |
| 1995 年创立、家族企业、绿电、C2C 认证 | **强** | 官网 About us |
| Firmenbuch 数据（FN 181850b、1999-04-28、注册资本 4 万欧、经营范围"剪毛作坊"、管理人与唯一股东） | **强** | evi.gv.at 奥地利工商登记公示（一手登记信息） |
| 22 个 FFG 项目清单与编号 | **强** | 官网 Research Projects 页原文（含 FFG 编号与项目链接） |
| 4 项专利号与标题 | **强** | 官网 Patents 页原文 |
| Texible 五工艺清单、传感器/执行器/接口菜单、Wisbi、ANGEL、Stappone、EQUUSIR、WAIBO | **强** | Texible 官网各页原文 |
| 24sens smartcorCONTROL、EU 认证、房颤定位、Lustenau 生产、15→50 人 | **强** | 24sens 官网 + Lustenau 官方杂志专访 |
| Vprotect €249 线上心电、口罩电商 | **强** | Vprotect 官网商品页 |
| Storex 2.5 kWh 盐水电芯、独家纺织部件制造权、150 万欧元追加、香港投资人 X.D. Yang、Nikola Todorovic | **中强** | Grabher 官网电池 know-how 页（转述媒体报道） |
| Ariane 火箭电磁屏蔽织物 + 木星任务 2030 抵达 | **中** | 创始人专访口径（Lustenau 官方杂志），未见 ESA/Ariane 官方确认 |
| 客户含 Google / Red Bull / Microsoft | **中** | 地方媒体（Lustenau 市）报道，非这些企业官方确认 |
| L.U.C.E.S.S."有感觉的计算机" | **中** | 地方媒体报道口径，属宣传性表述 |
| 卡尔迈耶 TEXTILE-CIRCUIT 的时间线（2018 起、ITMA 2019 智能衬衫、测心率/湿度/皮温） | **中强** | Textile Focus 2019 报道，与 2024 年两份报道互相印证 |
| "集团联合六家公司" vs 官网列 9 个实体 | **口径冲突** | 24sens 页面写 six，官网 COMPANIES 列 9（含 lab/older entities）；**数字以官方 COMPANIES 页为准，但需向对方确认口径** |
| **Grabher Group 的总营收与总员工数** | **未获取** | Firmenbuch 只公示登记信息不含财报数字；firmenabc 等站点返回 JS 拦截（429/0 字节）。**建议在接触时直接询问，或通过 Firmenbuch 年报付费渠道获取** |
| V-trion 与"V-trion textile research GmbH"的关系、官网 Technologies 页内容 | **未获取** | 该页为编辑器框架页（仅 346 字符），无实质正文；**Wiki/注册信息待补** |
| v-trion 引用的"智能纺织品服装市场 1000 亿欧元"等数字 | **弱** | 营销型市场报告转引，**勿引用入 BP** |

---

## 8. 来源清单

**指定来源（4）**
- [Knitting Industry — Overcoming the barriers of e-textile production（2021-04-06）](https://knittingindustry.com/interviews/overcoming-the-barriers-of-etextile-production/)
- [Textile Focus — KARL MAYER's smart shirt with integrated sensors is opening up new applications（2019-12-27）](https://textilefocus.com/karl-mayers-smart-shirt-integrated-sensors-opening-new-applications/)
- [World of Technical Textile — KARL MAYER and Grabher support wearables projects with competence platform（2024-03-13）](https://worldoftechnicaltextile.com/karl-mayer-and-grabher-support-wearables-projects-with-competence-platform/)
- [Grabher Group 官网](https://www.grabher-group.company/)

**Grabher 官网子页**
- [About us](https://www.grabher-group.company/company-about-us)｜[Companies](https://www.grabher-group.company/companies-grabher-group)｜[Smart Textiles](https://www.grabher-group.company/smart-textiles)｜[Patents](https://www.grabher-group.company/research-patents)｜[Research Projects](https://www.grabher-group.company/research-projects)｜[News/Blog](https://www.grabher-group.company/blog)｜[Textile Finishing](https://www.grabher-group.company/textile-finishing)｜[电池 know-how](https://www.grabher-group.company/batterieknowhow)

**子公司与生态**
- [Texible GmbH](https://www.texible.com/)（[Smart Textiles](https://www.texible.com/smart-textiles/)｜[Production](https://www.texible.com/production/)｜[Services](https://www.texible.com/services/)｜[Projects](https://www.texible.com/projects/)｜[About](https://www.texible.com/about-us/)｜[Scientific Partnerships](https://www.texible.com/scientific-partnerships/)）
- [24sens GmbH](https://24sens.com/)（[Team](https://24sens.com/team-english)）
- [Vprotect GmbH](https://www.vprotect.at/)
- [V-trion GmbH](https://www.v-trion.com/)

**工商登记与地方媒体**
- [evi.gv.at — Grabher Group GmbH 工商公示（FN 181850b）](https://www.evi.gv.at/f/181850b)
- [Lustenau 市官方杂志专访：Lustenauer Textilpionier stößt bis zum Jupiter vor](https://marketing.lustenau.at/de/aktivitaeten/lebens-lust-das-lustenau-magazin/lebenslust-ausgabe-30/lebenslust-ausgabe-36/lustenauer-textilpionier-stoesst-bis-zum-jupiter-vor)
- [Lustenau 市：Textilien mit Zukunft](https://www.lustenau.at/de/neuigkeiten/textilien-mit-zukunft)

**关联内部文档**
- [卡尔迈耶经编机设备与技术分析.md](卡尔迈耶经编机设备与技术分析.md)｜[南烯经编机项目.md](南烯经编机项目.md)｜[南烯公司出售与资产重组策略.md](南烯公司出售与资产重组策略.md)｜[南烯对外Teaser一页纸.md](南烯对外Teaser一页纸.md)｜[demo-prd-heating-sensing-v0.1.md](../09-加热传感Demo产品线/demo-prd-heating-sensing-v0.1.md)

---

## 附：一页速记

- **Grabher 是谁**：1995 年创立于奥地利 Lustenau 的家族集团，做纺织后整理起家，现在是**欧洲智能纺织品的系统集成商 + 生态组织者**（Smart-Textiles Platform Austria 发起方）。9 个实体、突尼斯实验室、22 个 FFG 项目、4 项专利、客户含 Google/Red Bull/Microsoft、给 Ariane 火箭供电磁屏蔽织物。
- **它的技术菜单**：刺绣（导电纱按图案铺，可全自动批量）／**TFP 定制纤维铺放（明确包括"纺织加热元件"）**／针织／梭织（大面积低成本传感面）／整面后整理（等离子、涂层、阻燃、整面导电）。
- **它的产品**：24sens 心电胸带（EU 认证、房颤、Lustenau 生产）｜Vprotect 线上心电 **€249**｜Texible **Wisbi 护理床垫插层**（潮湿/体液/离床报警）｜ANGEL 智能工装｜Stappone 足底压力鞋垫（耐久性 50×）｜Storex **2.5 kWh** 盐水电芯（Grabher 独家纺织部件制造权）｜CBRN 防护帐篷｜Ariane 火箭屏蔽织物。
- **它的规模真相**：**单个产品线团队只有 15→50 人**；研发靠政府项目；生产靠欧洲网络 + 突尼斯。**智能织物是高混合低产量生意，不是产能生意。**
- **它的软肋（你的机会）**：创始人自己说"能源与工资上涨，**竞争力被强烈削弱**"；他们已有突尼斯外包先例。
- **对你的三条硬结论**：① **刺绣路线是对的**（Grabher 系的核心工艺之一就是刺绣）；② **发热布该走 TFP/刺绣 + 后整理**，不是双针床经编；③ **你缺的是认证、场景和客户关系，不是机器**——先谈"器件供应/联合开发"，别先谈整机。
