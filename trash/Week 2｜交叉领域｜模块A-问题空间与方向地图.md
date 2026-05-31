# Week 2 | 模块 A：问题空间与方向地图

> 目标：快速看完整个 AI × Web3 的几大交叉领域，再选择一个主方向深入。

## 一句话

AI × Web3 不是把两个 buzzword 拼在一起——真正有价值的问题落在**"机器执行 + 经济交换 + 权限控制 + 可验证记录"**的交界处。一个方向是否成立，不看它用了多少新词，而看 AI 能力和 Web3 机制是否**同时不可替代**。

## 统一判断框架

每个方向都用同一组 7 个问题判断，避免项目仅是把 AI 和 Web3 两个词放在标题里：

| # | 问题 | 考察维度 |
|:-:|------|:--------:|
| 1 | **没有 AI，这个方向是否仍然成立？AI 承担什么能力？** | AI 是否不可替代 |
| 2 | **没有 Web3，这个方向是否仍然成立？Web3 提供什么机制？** | Web3 是否不可替代 |
| 3 | **谁发起任务、执行、付款、验收、承担失败成本？** | 角色与权责分配 |
| 4 | **哪些动作可自动化？哪些必须人工确认？** | 自动化边界 |
| 5 | **结果如何验证？验证成本是否低于人工协调成本？** | 可验证性 |
| 6 | **它更像应用层体验、开发者工具、协议/标准、权限系统、安全机制、还是治理协作？** | 落地层 |
| 7 | **如果失败，最可能原因是什么？**（需求不存在/信任不可建/成本过高/接口不成熟/权限风险/用户不愿改变流程） | 风险预判 |

## 六大交叉方向（+ 一个应用路径）

| # | 方向 | 核心问题 | 适合谁 |
|:-:|------|---------|:------:|
| 1 | **Payment / Commerce / Settlement** | 机器/Agent 如何购买 API、数据、算力？报价→验收→托管→结算如何闭环？ | 对商业闭环、支付标准感兴趣 |
| 2 | **Identity / Reputation / Capability / Interoperability** | Agent 如何被发现、描述、调用、验证和协作？ | 对 MCP、A2A、ERC-8004、Registry 感兴趣 |
| 3 | **Wallet / Permission / Safe Execution** | Agent 接触钱包和链上动作时，如何做权限分层、自动化边界、人工确认、撤销与审计？ | 对 AA、Safe、Policy、Session Key 感兴趣 |
| 4 | **Privacy / Security / Sovereignty** | Prompt Injection、Tool Abuse、私钥/API Key 暴露、模型供应商依赖如何防范？ | 对安全、隐私、可信执行感兴趣 |
| 5 | **Dev Tooling / Agent Workflow** | AI 能否改善 Web3 builder 工作流？合约阅读、交易解释、部署助手、测试脚本？ | 希望做工具、开发者体验或 Workflow |
| 6 | **Governance / Coordination / Public Goods** | AI 如何辅助 DAO 做提案总结、会议行动项、贡献记录、预算检查？ | 对社区协作、公共物品感兴趣 |
| — | **Agent DeFi Execution**（sponsor 应用路径） | 把 Payment、Wallet/Permission 和 Privacy/Security 放到 DeFi 链上执行场景检验 | Cobo 相关 Hackathon 优先路径 |

---

## 开始速览

### Direction 1：Payment / Commerce / Settlement
#### 我的判断

在 Payment / Commerce / Settlement 领域，AI Agent = **更智能的代码** = 把以前人做的脏活（比价、选 router、处理失败、调 allowance）自动化了。它没有引入"智能"，它引入的是**适应能力**——读取上下文、做判断、处理不确定性。
后者多了读取上下文 + 做判断 + 处理不确定性

#### 一句话

Agent 不能只调用免费工具——真实世界需要付费：推理 API、数据源、浏览器环境、链上交易、存储、人工审核、另一个 Agent 的任务执行。机器支付（Machine Payment）是 AI Agent 经济的血液：x402 把 HTTP 402 Payment Required 标准化为链上支付通道，MPP（Machine Payments Protocol）定义 Budget-Quote-PaymentIntent 三层预算模型让 Agent 在用户授权的全局/任务/调用级预算内自主采购；ERC-8183 则把托管结算（Escrow）的状态机（Created→Funded→Delivered→Accepted→Released）固化为链上标准，让服务方在收到可验证付款后交付结果，也让双方在交付争议时有链上仲裁依据。

#### 三问

- **解决什么真实问题？** 机器/Agent 如何购买 API、数据、算力和服务，以及报价→验收→托管→争议处理→结算如何形成一个无需人工介入的闭环。核心挑战不是"能不能支付"，而是四个耦合问题：(1) 报价可信——服务方的 Quote 必须签名且带过期时间（类似 ERC-8183 的 Quote schema），防止服务方在 Agent 下单后涨价或拒绝交付；(2) 预算安全——用户凭什么相信 Agent 不会把钱花光？MPP 提出的三层 Budget（global/task/call-level）让用户在授权时就写死"最多花多少、花在什么事上、什么时间到期"；(3) 交付验证——Agent 如何判断服务方真的交付了？ERC-8183 的 Escrow 状态机引入 Evaluator 角色，在 Funded→Delivered 之间插入独立的验收检查；(4) 争议解决——交付不符合预期时钱归谁？链上托管（Escrow）让资金在争议期间锁在合约里，Refund/Release 由 Evaluator 或仲裁合约决定，而非依赖任何一方的善意。
- **AI 角色？Web3 角色？** AI：在用户授权的 Budget 范围内自主选择服务、比价（比较多个服务方的 Quote）、下单（发起 Payment Intent 绑定 task+budget+payee+deadline）、验证交付（检查 Receipt 与 Quote 的匹配度、调用 Evaluator 的验收逻辑）。Web3：提供 AI 无法自建的三层基础设施——(1) 可编程权限边界（Approve/Allowance 限定金额上限，与 Dir3 的 Session Key 联动）；(2) 无需中间商的结算通道（x402 的 HTTP 402 + 链上支付让 Agent 和服务方之间不需要 Stripe/PayPal 这样的中心化收单方）；(3) 可验证的链上收据与托管（ERC-8183 的 Escrow 合约确保资金在验收通过前不释放，链上 Receipt 不可篡改，争议时可作为仲裁证据）。
- **落地层？** 三层架构——**协议/标准层**（Quote 格式、MPP 的 Budget/PaymentIntent schema、x402 的 HTTP 402 支付标准、ERC-8183 的 Escrow 状态机、AP2 的 Agent Payments Protocol 统一接口）；**中间件/服务层**（报价发现与聚合、Evaluator 验收服务、争议仲裁合约）；**应用层体验**（Agent 采购 UI——用户设定 Budget→Agent 展示候选服务方→Agent 自主下单→用户查看消费记录）。现阶段最成熟的是协议层（多个 EIP 在推进），最薄弱的是应用层（还没有一个像"Agent 版淘宝"的产品）。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | 没有 AI 时，这个方向退化为传统的 API 付费和企业采购——人类手动填信用卡、签合同、逐笔审批。AI 的不可替代性在于三点：(1) **比价与选择**——Agent 能同时向多个服务方请求 Quote、比较价格/质量/交付时间、做出最优选择，人类面对 10+ 服务方时只能凭直觉或品牌；(2) **交付验证**——Agent 可以程序化检查交付物（API 返回数据的完整性、算力任务的计算结果哈希、交付文档的格式），人类逐一验收成本过高；(3) **7×24 自主采购**——Agent 在凌晨自动购买更便宜的算力、在流量低谷调用 API 获得更低价格，这是人类无法做到的。没有 AI，机器支付就是一把没有大脑的扳手——能拧螺丝但不知道拧哪颗。 |
| 2 | **没有 Web3？** | 没有 Web3 时 Agent 之间可以通过传统支付通道（Stripe、信用卡、PayPal）完成支付，但会失去四个关键能力：(1) **无需中间商的微支付**——Stripe 的标准费率（2.9% + $0.30）让 $0.01 的 API 调用支付在经济上不成立，而 L2 的链上支付可以让 gas 费低于 $0.001，使按次计费的 Agent-to-Agent 微支付（Micropayment）成为可能；(2) **可编程托管**——ERC-8183 的 Escrow 合约让资金在验收通过前锁在不可篡改的合约里，传统支付需要第三方托管服务（Escrow.com 收取 0.89%-3.25% 手续费）；(3) **无许可接入**——任何 Agent 服务方不需要申请 Stripe 商户账号、不需要通过 KYC、不需要签银行协议，只需要部署一个支持 x402/MPP 的端点，这大幅降低了 Agent 经济的供给端门槛；(4) **可组合的支付与权限**——链上支付可以和 Dir3 的 Session Key/Policy 组合（"这个 Session Key 每天最多支付 100 USDC"），传统支付体系无法做这种编程级权限控制。Web3 不是"最终目标"，而是让机器支付从小额（>$5）扩展到微支付（$0.001-$5）的使能层。 |
| 3 | **角色分配？** | 用户/Agent Owner → 设定三层 Budget（全局预算上限、任务级预算分配、调用级限额），授权 Payment Intent 的签名权限，设置白名单服务方和黑名单，处理争议升级。Agent → 在 Budget 范围内发起 Quote 请求、比较服务方报价、生成并签名 Payment Intent（绑定 task+budget+payee+deadline）、下单、接收交付物、调用 Evaluator 验收、触发 Release 或 Refund。服务方 Agent → 返回签名 Quote（含价格/交付规格/过期时间）、在收到 Payment Intent 后开始交付、提供 Delivery Proof（链上 Receipt + 交付内容哈希）。Escrow 合约（ERC-8183）→ 管理资金状态机（Created→Funded→Delivered→Accepted→Released），持有托管资金，执行 Release/Refund/Dispute 逻辑。Evaluator → 独立验证交付质量（检查交付物是否匹配 Quote 规格），输出验收结果供 Escrow 合约使用。失败成本承担：服务方交付不达标→资金退回用户（Refund）；Agent 下单后不付款→服务方不交付（无损失）；交付争议→Evaluator 裁定，败诉方承担 Evaluator 费用。 |
| 4 | **自动化 vs 人工？** | 全自动：Budget 内的小额付款（如单次 API 调用 <5 USDC）、已验证服务方（历史交付成功率 >95%）的按次收费、重复性采购（每天自动购买算力用于定时推理任务）、标准交付物的程序化验收（API 返回数据 schema 校验、文件哈希比对）。需人工：首次授权（用户必须理解并批准 Budget 上限和服务方白名单）、超预算操作（Agent 请求超额时需要人工追加预算）、新服务方首次交易（无历史声誉的新服务方需人工审核）、高危操作（大额预付、approve unlimited、涉及新 token 类型）、争议升级（Evaluator 无法裁定或用户不认同裁定结果）。核心原则：规则明确且可程序化验证的操作全自动，涉及信任判断和服务方评估的操作必须人工介入——因为 Agent 可能被恶意服务方的营销材料欺骗。 |
| 5 | **如何验证？** | 双层验证机制：(1) **支付层验证**——链上收据（ERC-8183 的 Receipt 事件）+ Quote 签名对比。Agent 在收到交付物后，检查 Receipt 中的交付哈希是否匹配 Quote 中承诺的规格，验证 Quote 的签名是否来自已知服务方，验证 Payment Intent 是否在 Budget 范围内且未过期。这层验证成本极低（一次 RPC call + 一次 ecrecover 签名验签，总 gas <50k）。(2) **交付层验证**——对于可程序化验证的交付（API 返回数据、算力计算结果、文件生成），Agent 直接运行校验逻辑（schema 验证、哈希比对、结果重现）；对于不可程序化验证的交付（人工审核报告、创意输出、复杂分析），引入 Evaluator 角色——Evaluator 可以是另一个更专业的 Agent（如用更强模型验证弱模型的输出），也可以是人工审核者（提交链上 Attestation）。验证成本在支付层可以忽略不计；在交付层，程序化验证接近零成本，Evaluator 验证的成本取决于任务复杂度（从几美分到几美元）。与传统模式相比，链上验证的核心优势不是更便宜，而是**不可篡改**——Receipt 和验证结果一旦上链就无法被任何一方事后修改。 |
| 6 | **落地层？** | 三层架构，其中最核心的是**协议/标准层**：(1) **报价与支付协议**——Quote schema（签名报价/过期时间/交付规格）、Payment Intent schema（task+budget+payee+deadline）、x402（HTTP 402 支付标准）、MPP（多层 Budget 管理）、AP2（统一 Agent 支付接口）；(2) **托管与结算协议**——ERC-8183（Escrow 状态机：Created→Funded→Delivered→Accepted→Released，含 Refund/Dispute 分支）、链上 Receipt 标准；(3) **发现与聚合层**（中间件）——服务方注册表（Agent 去哪找服务方）、Quote 聚合器（类似 DEX aggregator 但聚合 API/算力报价）、Evaluator 市场（第三方验收服务）；(4) **应用层**——Agent 采购 UI（用户设定 Budget→Agent 比价下单→消费记录仪表盘）。当前协议层进展最快（x402 已有参考实现，ERC-8183 在 EIP 讨论中），但发现层和应用层几乎空白——没有"Agent 版 Yelp/淘宝"让 Agent 发现和比较服务方。 |
| 7 | **失败原因？** | 三重风险叠加：(1) **成本过高**——L1 上每次支付 gas 费 $1-50 让 MicroPayment（$0.001-$0.1 级别）完全不可行，这会把 Agent 支付锁死在"高频低额"场景之外。L2（Arbitrum/Optimism/Base）将 gas 降到 $0.001-0.01 可能缓解，但需要 L2 生态的 x402/MPP 端点部署成熟。(2) **用户不愿改变流程**——用户习惯了手动刷卡和企业采购审批流程，让 Agent 自动花钱的心理门槛极高。即使 Budget 设得很保守（"每月最多 50 USDC"），用户也会担心 Agent 被恶意服务方欺骗后把钱花在无效服务上。这需要一两个成功案例（比如一个知名 AI Agent 产品内置 MPP 支付且零安全事故运行 6 个月）才能建立信任。(3) **接口不成熟**——x402 和 MPP 的端点标准尚未统一，服务方接入成本高；ERC-8183 的 Escrow 合约需要 Evaluator 生态（谁来做验收、如何定价、怎么防 Evaluator 合谋）尚未建立；Quote 的签名格式和 Payment Intent 的 schema 在 EIP 层面仍有争议。最可能失败在"L1 gas 太高 + 没有服务方接入 + 用户不敢用"三重死锁中。 |





---

### Direction 2：Identity / Reputation / Capability / Interoperability

#### 一句话

Agent 需要一个可验证的身份才能被信任——谁拥有它（Ownership：EOA/Smart Account/Multisig/DAO）、它能做什么（Capability：schema+price+limits+failure conditions）、怎么调用它（Service Endpoint：A2A 协议端点+DID Document）、历史声誉如何（Reputation：per-task-type 评分+time decay+链上 attestation）。没有身份，Agent 之间无法建立长期信任；没有声誉，用户无法判断哪个 Agent 值得付款；没有可互操作的 Capability 声明，Agent 无法自动发现和调用彼此。ERC-8004 将 Identity/Reputation/Validation 三个 Registry 固化为链上标准，DID/VC（W3C 标准）+ Ethereum Attestation Service（EAS）为 Agent 提供可验证的声明与证明体系，A2A 协议解决 Agent-to-Agent 通信与能力发现——三者共同构成 Agent 经济的信任底座。
(信任底座)
#### 三问

- **解决什么真实问题？** 四个相互嵌套的问题：(1) **发现（Discovery）**——用户和 Agent 如何找到能完成特定任务的服务 Agent？MCP 和 A2A 解决了"怎么通信"（通信协议），但没有解决"怎么发现"（Agent 注册表和搜索）。需要类似 DNS 的 Agent 注册表——通过 ERC-8004 的 Identity Registry 登记 Agent Profile（身份+所有权+Service Endpoint+DID Document），让任何客户端都能查询"有哪些能做 X 任务的 Agent"。(2) **评估（Evaluation）**——如何判断一个 Agent 是否可信、能力是否真实、历史表现如何？Reputation 不能是简单的五星评分——必须 per-task-type（一个 Agent 可能在代码生成上 5 星但交易建议上 2 星），必须有 time decay（去年的好声誉不代表今天仍然可信），必须绑定链上 Attestation（EAS 的 issuer/subject/claim/evidence/expiration/revocation schema 确保声誉不可伪造）。(3) **能力声明（Capability）**——Agent 的能力描述（schema/price/limits/failure conditions）必须机器可读，否则服务方 Agent 无法自动发现和调用其他 Agent——这要求 Capability 绑定在 Agent Profile 中，且支持 schema 校验。(4) **互操作（Interoperability）**——不同框架（LangChain、Eliza、Rig）构建的 Agent 如何互相调用？A2A 协议 + DID Document 的 Service Endpoint 定义了统一的 Agent-to-Agent 通信标准，ERC-8004 的 Validation Registry 让调用方可以独立验证被调用方的推理结果。
- **AI 角色？Web3 角色？** AI：Agent 的自我描述层——身份声明（谁训练了我、我跑在什么模型上、我的 Knowledge Cutoff 是什么时间）、能力声明（我能做什么任务/支持什么 media type/价格/失败条件）、服务端点（我的 A2A endpoint URL/支持的 API schema）。但 AI 的输出本身不可信——任何 Agent 都可以声称自己"擅长 Solidity 审计"，需要外部验证。Web3：提供三根信任锚——(1) **不可篡改的注册表**（ERC-8004 的 Identity Registry：Agent Profile 上链后不可被第三方篡改，Ownership 支持 EOA/Smart Account/Multisig/DAO 降低单点风险）；(2) **可验证的声誉**（ERC-8004 的 Reputation Registry：链上 feedback 无法被刷评方删除，链下聚合算法（如 EigenTrust 改编）可以计算全局声誉但原始数据始终链上可查）；(3) **组合式验证层**（ERC-8004 的 Validation Registry：第三方验证者输出链上证明，可组合 zkML/TEE/重跑验证——EAS 的 Attestation schema（issuer/subject/claim/evidence/expiration/revocation）确保每条验证都可追溯）。DID/VC（W3C 标准）让 Agent 的身份和声明可以在不同链和系统间互操作，Gitcoin Passport 的 Stamp 体系已经验证了链上声誉在防 Sybil 场景的可用性。
- **落地层？** 协议/标准层 + 链上基础设施——核心是 ERC-8004 的三个 Registry（Identity Registry 存 Agent Profile、Reputation Registry 存 feedback 与评分、Validation Registry 存验证证明），外加链下聚合与发现层（声誉计算算法如 EigenTrust 改编版、Agent 搜索引擎/目录、验证者市场经济模型）。DID/VC（W3C）提供跨链互操作的身份框架，EAS 提供通用的链上 Attestation 基础设施（已在 Optimism/Arbitrum/Base 等多链部署），A2A 协议提供 Agent 间的发现与通信标准。这与 Dir1 不同——Dir1 需要应用层产品（"Agent 采购 UI"），而 Dir2 更接近基础设施层，它提供的身份/声誉/验证能力被其他五个方向共同依赖。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | 这个方向的特殊性在于：AI 不是工具而是**被信任对象**。没有 AI 时，身份/声誉系统仍然存在（ENS 域名、Gitcoin Passport 的 Stamp 体系、EAS 的链上 Attestation），但它们管理的是"人的身份"——静态且变化缓慢。AI Agent 让问题质变：(1) **身份的动态性**——同一个 Agent 可能今天跑 GPT-4o、明天换 Claude 4、后天切换为开源模型，模型升级/降级会改变其能力边界，能力声明（Capability）需要随模型更新同步刷新；(2) **所有权的复杂性**——Agent 的 Owner 可以是 EOA（个人）、Safe 多签（团队）、DAO 合约（社区治理）或 Smart Account（可编程权限），不同的所有权模型决定了"谁有权更新 Agent Profile、谁承担 Agent 行为后果"；(3) **被信任的客体的多样性和概率性**——Agent 的输出是概率生成，不是确定性的，信任不能只是"这人是不是本人"，而是"这个 Agent 在任务 X 上的准确率有多高、在什么条件下会失败"。没有 AI，Dir2 退化为普通链上身份系统（ENS + Passport）；有了 AI，Dir2 需要回答一个全新问题：**如何信任一个概率系统**。 |
| 2 | **没有 Web3？** | 不成立。传统 AI 生态中也有身份和评分——OpenAI 的 GPT Store 有 Agent 评分、HuggingFace 有模型排行榜、各大云厂商有服务 SLA。但它们做不到：(1) **无许可注册**——任何 Agent 都可以在 ERC-8004 的 Identity Registry 上自主注册身份（不需要像 GPT Store 那样通过平台审核），这降低了 Agent 经济的供给端门槛，但也带来了质量参差不齐的问题（需要声誉系统来过滤）；(2) **不可篡改的声誉**——GPT Store 的评分可以被平台删除、修改或选择性展示，而 ERC-8004 的 Reputation Registry 上的 feedback 一旦上链就无法被任何人（包括 Agent Owner 和平台）删除——这解决了"平台审查声誉"和"刷评后删除差评"的信任问题；(3) **可组合的验证**——ERC-8004 的 Validation Registry 让第三方验证者（独立的 zkML 验证服务、TEE 证明者、staker 重跑验证）可以输出链上 Attestation，调用方可以自由选择信任哪些验证者，而不是被迫信任平台指定的唯一验证方；(4) **跨平台互操作**——DID/VC（W3C 标准）让 Agent 的身份可以在不同链和应用间携带，而不是被锁定在单一平台的账号体系内。Gitcoin Passport 已证明链上声誉在防 Sybil 场景的可用性（通过链上 Stamp 和 Passport Score），EAS 已证明通用 Attestation 基础设施可行（在 Optimism/Base/Arbitrum 等链上已有大量 Attestation 记录）。 |
| 3 | **角色分配？** | Agent Owner（链上的法律实体——可以是 EOA/Smart Account/Multisig/DAO）→ 在 ERC-8004 的 Identity Registry 注册 Agent Profile（DID Document + Service Endpoint + Capability 声明 + Ownership 证明），更新能力声明（当模型升级或服务变更时）、转移所有权、处理声誉争议。Client/用户（人类用户或其他 Agent）→ 查询 Identity Registry 发现候选 Agent、查询 Reputation Registry 评估 agent 声誉（per-task-type 评分 + time decay + 链上 Attestation 验证）、请求 Validation Registry 的第三方验证、在使用后提交 feedback（giveFeedback）和 Attestation。第三方验证者 → 运行验证逻辑（zkML 证明生成、TEE 远程证明、staker 重跑推理对比结果），输出链上验证证明（validationResponse），收取验证费用。如果验证者作弊（出具虚假证明），其 stake 被 slashing（与 ERC-8004 的经济安全机制联动）。Registry 合约（ERC-8004）→ 作为不可篡改的存储层管理三个 Registry 的写入/查询、管理验证者的 stake/slashing、维护 Agent 的声誉记录（add-only，不可删除）。EAS 合约 → 提供通用的 Attestation 基础设施（issuer/subject/claim/evidence/expiration/revocation），让任何实体可以为 Agent 的能力/声誉/验证结果签发链上证明。失败成本承担：Agent 能力声明虚假→声誉下降 + 用户流失（市场惩罚）；验证者作弊→stake 被 slash；Client 被虚假 Agent 欺骗→损失由 Client 自行承担（Dir2 提供的是信任信号，不是保险）——这要求验证者和声誉系统本身足够可靠。 |
| 4 | **自动化 vs 人工？** | 全自动：身份注册（Agent Owner 签名→Identity Registry 上链）、能力声明更新（Agent 模型升级后自动更新 Capability 字段）、feedback 上链（用户使用后自动提交评分和 Attestation）、验证请求/响应（Client 自动请求 Validation Registry → 验证者自动运行验证→链上返回证明）、Repo 同步（Agent 的 Capability 变更后自动更新链上 Profile）。需人工：身份所有权转移（EOA→Multisig 或转让给新 Owner 时需要原 Owner 签名且通常涉及多方确认）、高价值验证的仲裁（当验证者之间意见分歧或 Client 质疑验证结果时，需要人工陪审团或仲裁合约裁决）、争议处理（Agent 声称被恶意差评——需要 Owner 提交链上证据申请仲裁，类似 Kleros 的陪审团机制）、首次注册审核（如果引入注册门槛以防止垃圾 Agent 泛滥，需要某种人工或 DAO 审核机制）。核心原则：信息记录和验证流程全自动，涉及权利转移和争议判断的需人工——但 Dir2 的终极目标是让"是否信任一个 Agent"这个决策也自动化（基于链上声誉+验证记录的程序化判断），这是区别于 Web2 评分系统的关键。 |
| 5 | **如何验证？** | ERC-8004 的三层验证体系：(1) **身份验证**——通过 Identity Registry 查询 Agent 的 Ownership 是否有效（Owner 签名验证）、Service Endpoint 是否可达（HTTP ping 检查）、Capability 声明是否被 Owner 签名（防止第三方篡改）。成本极低（链上查询 + 签名验签）。(2) **声誉验证**——通过 Reputation Registry 查询 Agent 的历史 feedback（per-task-type 评分），结合链下聚合算法（如 EigenTrust 改编版）计算全局声誉分数。time decay 机制确保过期 feedback 权重下降（如每 30 天衰减 50%），Attestation 的 expiration/revocation 机制确保过时或被撤销的证明不参与计算。需要注意的是：声誉分数本身是链下计算的（因为需要加权/衰减/归一化等运算），但原始 feedback 全部链上可查——任何人可以用自己的算法重新计算声誉分数，不存在单一的"权威评分"。成本中等（链上查询多次 feedback + 链下聚合计算），但远低于人工逐一调查每个 Agent 的费用。(3) **能力验证**——通过 Validation Registry 请求第三方验证：(a) zkML 证明：验证者运行模型推理并生成零知识证明（EZKL 把 ONNX 模型转 zk-circuit），证明"给定输入 X，模型输出 Y"而不暴露模型；但当前 zkML 的 proof 生成时间从数秒到数小时，仅适用于低频验证；(b) TEE 远程证明：验证者通过 Intel SGX/TDX 的 Remote Attestation（RA）报告证明"代码真的跑在隔离区且未被篡改"，Phala Network 已实现 Worker 注册机制让链上验证 RA 报告；TEE 验证比 zkML 快（毫秒到秒级），但依赖硬件厂商的信任根（Intel/AMD）；(c) Staker 重跑验证：多个 staker 各自运行推理并提交结果哈希，通过链上共识（多数一致）确定正确答案，作弊者 stake 被 slashing——这是一种经济安全方案，适合"推理结果可重现"的场景（如代码执行、数学计算）。验证成本因方案而异：zkML 最高（proof 生成需要 GPU 算力）、TEE 中等（硬件租赁成本）、staker 重跑最低（仅 gas 费 + 少量 stake 机会成本）。 |
| 6 | **落地层？** | **协议/标准层**——ERC-8004 的三个 Registry（Identity/Reputation/Validation）是核心链上标准，DID/VC（W3C）提供跨系统的身份互操作框架，EAS 提供通用 Attestation 基础设施，A2A 协议解决 Agent 发现与通信。**链下聚合与发现层**——声誉计算算法（EigenTrust 改编版支持 per-task-type + time decay）、Agent 搜索引擎/目录（类似"Agent 版 Google"——用户输入任务描述，返回匹配的 Agent 及声誉/验证评分）、验证者市场经济模型（Stake 金额、验证费用定价、Slashing 条件）。**应用集成层**——Agent 框架（LangChain/Eliza/Rig）内置 ERC-8004 客户端（自动注册身份、提交 feedback、请求验证）、钱包/DeFi 产品集成（Cobo Agentic Wallet 读取 Agent Reputation 判断是否授权、DeFi 协议基于 Agent 声誉给不同授权额度）。关键特点：Dir2 是**被其他五个方向共同依赖的基础设施层**——Dir1 的 Agent 支付需要 Reputation 判断服务方可信度（在付款前查询对方的 per-task-type 评分），Dir3 的权限系统需要 Identity/Ownership 判断"这个 Agent 的 Owner 是谁、是否被授权"，Dir5 的 Dev Tooling 需要 Capability 声明让 CI/CD 系统自动选择合适的审计 Agent，Dir6 的 Governance 需要 Reputation 防止 Sybil Agent 操纵投票。Dir2 的成功不是看它自己有多少用户，而是看其他方向是否默认集成它的 Registry。 |
| 7 | **失败原因？** | 三重风险：**(1) 信任不可建立（最大风险）**——声誉可刷（Sybil 攻击：一个 Agent Owner 创建 1000 个假身份互相给好评，链上 feedback 无法区分真假用户）；验证者合谋（多个验证者私下协议出虚假证明，Stake/slashing 金额不足以威慑）；链上声誉与链下实际服务质量脱钩（一个 Agent 在简单任务上保持高声誉，但在复杂边缘场景中频繁失败——per-task-type 评分可以缓解但无法消除）。Gitcoin Passport 的价值在于它是"人的唯一性证明"（通过链上活动 + 社交图谱 + 生物识别），Agent 没有这种唯一性——一个恶意 Actor 可以创建 10000 个 Agent Profile，每个都有不同的声誉。**(2) 冷启动问题**——新 Agent 没有 Reputation，用户只用有历史声誉的老 Agent，新 Agent 永远无法获得初始信任（需要引入"stake 作为初始信任"机制，但 stake 金额设太高阻挡了普通开发者，设太低无法过滤恶意 Agent）。**(3) 接口不成熟**——ERC-8004 仍在 EIP 讨论中（未最终确定 schema 和 gas 优化）、A2A 协议的 Capability 声明格式尚未统一（不同 Agent 框架对"能力"的描述方式不同）、DID/VC 的标准过于宽泛（W3C 的 VC Data Model 非常灵活但导致实现互操作困难）。最可能的失败路径：声誉系统被 Sybil 攻击攻破→早期用户因推荐了恶意 Agent 而亏损→社区对声誉系统丧失信心→没有服务方愿意接入注册表→整个方向停滞在"论文和 EIP 草稿"阶段。 |

---
#### 我的判断
解决了web3如何服务Agent使其更可信的问题,构建信任基座.

### Direction 3：Wallet / Permission / Safe Execution

#### 一句话

Agent 不可以接触主私钥——控制权不能交给一个概率系统，Agent 只能拿到可验证、可限制、可撤销的行动空间。技术栈由 ERC-4337 的 Smart Account 承载执行边界（Account Abstraction 让账户以合约规则表达权限，而非仅靠私钥控制），Rhinestone Smart Sessions 提供可组合的链上 Session Key（临时受限钥匙，必须约束时间、合约/方法白名单、单笔金额、总上限、代币类型、外部转账权限、可撤销性），Cobo Agentic Wallet 的 Pact + Policy Engine 定义任务级权限（Pact 写死任务目标与预算，Policy Engine 在服务端做确定性拦截），Safe 的 Modules + Guard 做确定性规则检查（Guard 负责拒绝越界动作——Agent 生成候选，Guard 强制执行边界），Tenderly Simulation 预演交易结果（展示付出什么、收到什么、授权变化、调用了哪个合约、失败成本、与原始意图是否一致），多层 Revocation 机制确保随时收回（用户可见的关闭开关 + 过期/额度耗尽/多次失败/异常检测/行为漂移/长期不活跃自动撤销）。核心理念来自 Agent Wallet 手册第 5 章：Agent 不应该拥有无限支付能力，只应该拿到具体任务、预算和收款方范围内的支付权限——Policy 越清楚，Agent 的执行空间越可控。

#### 三问

- **解决什么真实问题？** Agent 需要执行链上操作，但不能拥有无限权限。问题不是"AI 会不会花钱"，而是"AI 能在什么范围、额度、条件下花钱——以及如何立刻停下来"。手册知识节点 1-4 给出了分层答案：AA Wallet（ERC-4337）让账户表达规则而非仅靠私钥，Smart Account 提供可编程的执行边界（权限、恢复、自动化），Safe 的多签基础设施让 Agent 参与流程而非单独控制（Agent 生成草稿，多签确认），Session Key 则是一组受限能力而非"小号私钥"——必须约束时间期限、合约/方法白名单、单笔金额上限、总支出上限、代币类型、外部转账权限和可撤销性。没有这层设计，Agent 要么只能给建议不能执行，要么权限大得没人敢用。
- **AI 角色？Web3 角色？** AI：在授权范围内生成交易草稿、请求授权、自动执行低风险操作——但它是不受信任的概率组件，其输出必须被验证和约束（手册节点 5-7）。Web3：提供可编程的权限基础设施——Smart Account 承载规则（节点 2），Session Key 表达临时授权（节点 4），Policy 定义可检查的规则体系（每日上限、白名单合约、swap-only 禁止无限 approve、滑点阈值、NFT 转移始终需人工——节点 5），Guard 做确定性拦截（检查目标白名单、方法允许列表、金额上限、allowance 异常、Simulation 结果、市场状态变化——节点 6），Simulation 预演执行结果（节点 7，使用 Tenderly），签名由 MPC 分散持有（Cobo 方案）。分工原则来自手册：Agent 生成候选，Guard 强制执行——Guard 必须负责拒绝越界动作。
- **落地层？** 权限系统层 + 安全机制层 + 产品层。协议标准层：ERC-4337 的 Account Abstraction（UserOperation、EntryPoint、Bundler、Paymaster）+ Rhinestone Smart Sessions 的链上可组合权限。产品层：Cobo Agentic Wallet 的 Pact + Policy Engine + MPC 安全（Pact 写死"做什么、用什么协议、最大金额"，Policy Engine 在服务端拦截越界请求），Safe 的多签基础设施 + Modules + Guard 扩展。辅助层：Tenderly Simulation API 做预执行预览。手册节点 8-9 补充了 Revocation（用户可见关闭开关 + 自动撤销条件）和 Human Check（分层：低风险自动、中风险模拟+确认、高风险强制确认并展示影响、超出 Policy 自动拒绝——好的 Human Check 应该让用户看懂自己在批准什么，而不是只看到一串哈希）。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | 同样成立——传统多签/Safe 也需要权限管理，Safe 的 Modules + Guard 架构本身就是为人类多签设计的（手册节点 3）。但 AI 让场景质变：不是"人授权给人"，而是"人授权给一个概率系统"——模型可能被 Prompt Injection 诱导、被恶意合约描述欺骗、在市场波动时做出错误判断。这要求权限架构从"信任执行者"转向"默认不信任、层层拦截"：需要更多的自动化检查来补偿模型不确定性——Guard 做确定性规则拦截（手册节点 6：检查目标白名单、方法 allowlist、金额上限、allowance 异常、Simulation 结果），Simulation 预演交易结果暴露异常（手册节点 7，使用 Tenderly），Policy 写死可检查的规则体系（手册节点 5）。核心转变：非 AI 场景中权限管理是"授权给可信的人"，AI 场景中权限管理是"授权给不可信的系统并用确定性机制约束它"。 |
| 2 | **没有 Web3？** | 不成立。传统 Web2 的 API Key / OAuth 是中心化权限模型——权限粒度粗（有权/无权二元），额度不可编程，无法做到合约级白名单，撤销依赖中心化服务端。Web3 提供的能力链均不可替代：(1) ERC-4337 的 Account Abstraction 让账户本身以合约代码表达权限规则（手册节点 1），而非依赖外部服务；(2) Smart Account 提供可编程的执行边界——权限、恢复、自动化均可定制（手册节点 2）；(3) Session Key 是一组链上可验证的受限能力，而非中心化服务端发放的 token（手册节点 4，Rhinestone Smart Sessions 实现可组合的链上 Session Key）；(4) Policy/Guard 的拦截逻辑在链上或可验证层执行，用户无需信任任何中心化服务不会篡改规则（手册节点 5-6）；(5) Revocation 可在链上即时生效，不依赖中心化服务端的响应（手册节点 8）。Web3 的 Smart Account + Session Key + Policy + Guard 栈是 Agent 权限的目前唯一可行载体，传统 OAuth/API Key 模型无法提供等效的细粒度可编程权限。 |
| 3 | **角色分配？** | 用户/Agent Owner → 设定 Policy（手册节点 5：定义每日上限、白名单合约、swap-only 禁止无限 approve、滑点阈值、NFT 转移始终需人工），批准 Pact（Cobo 的 Pact 写死任务目标、预算和收款方范围），随时触发 Revocation（手册节点 8：用户可见关闭开关）。Agent → 在授权范围内生成交易草稿、请求执行低风险操作，但其输出被视为 untrusted——按手册节点 6 的分工原则：Agent 生成候选，Guard 强制执行边界。Guard/Policy 合约 → 做确定性拦截（检查目标白名单、方法 allowlist、金额上限、allowance 异常、Simulation 结果、市场状态变化——手册节点 6），不依赖模型自我约束。钱包基础设施层 → Cobo Agentic Wallet 的 Policy Engine 在服务端拦截越界请求 + MPC 分布式持有私钥分片（签名从不在单一位置完成），Safe 的 Modules + Guard 在链上执行确定性规则。Simulation 层 → Tenderly 预演交易结果（展示付出什么、收到什么、授权变化、调用了哪个合约——手册节点 7），为 Guard 和 Human Check 提供决策依据。失败成本承担：Policy 内但策略失误的损失由用户承担（因此 Policy 设定必须保守），Policy 外的请求被 Guard/Policy Engine 自动拒绝（无损失）。 |
| 4 | **自动化 vs 人工？** | 自动：Policy 内的低风险操作——白名单合约的固定额度转账、白名单方法的重复调用、swap-only 且不超过滑点阈值和日限额的交易（手册节点 5 的规则体系自动化执行）。人工必须确认（手册节点 9 的 Human Check 分层）：(a) 中风险操作需模拟+确认——超日限额但在周限额内的交易、白名单内但金额较大的转账，Tenderly Simulation 展示预期资产变化后由用户确认；(b) 高风险操作必须强制人工确认并展示影响——超预算、新合约首次加入白名单、高危方法（approve unlimited、NFT 转移、合约升级）、Session Key 的首次授权和续期；(c) 超出 Policy 边界的操作自动拒绝（不在白名单的合约、超过限额、不允许的方法签名）。核心理念来自手册节点 9：好的 Human Check 应该让用户看懂自己在批准什么（资产变化、权限变化、失败风险），而不是只看到一串哈希。异常情况自动暂停：多次失败、异常检测触发、行为漂移、市场剧烈波动（TVL 骤降、预言机价格偏离）时 Agent 应自动暂停并等待人工决策（手册节点 8 的自动撤销触发条件）。 |
| 5 | **如何验证？** | 三层验证体系。第一层——执行前模拟（手册节点 7）：Tenderly Simulation 在交易广播前预演结果，返回预期资产变化（付出多少、收到多少、授权变化、调用了哪个合约、gas 成本、是否会 revert），与 Policy 中的滑点上限和风险参数做自动化比对。验证成本低（一次 Simulation 约 1-2 秒），覆盖大多数场景。第二层——发送前确定性拦截（手册节点 6）：Guard 在交易发送前做规则检查——目标合约是否在白名单、调用的方法签名是否在 allowlist、金额是否在限额内、allowance 是否异常（如突然 approve 无限量）、Simulation 结果是否与 Policy 一致、是否触发异常市场状态（TVL 骤降、价格偏离）。这是确定性代码检查，不依赖模型输出，验证成本几乎为零。第三层——事后审计（手册节点 8）：链上收据记录每一笔交易（不可篡改），Cobo 的 Full Audit Trail 记录 Agent 的每次请求和 Policy Engine 的允许/拒绝/暂停决策（哪条规则触发、谁批准、何时撤销），任何越界行为或异常模式都有完整记录可追溯。关键原则：验证不是"信任 Agent 的报告"或"信任 Simulation 的结果"，而是用确定性系统在 Agent 行动前后做独立的多层检查。 |
| 6 | **落地层？** | 横跨四个层次。**协议/标准层**：ERC-4337 的 Account Abstraction（UserOperation、EntryPoint、Bundler、Paymaster——手册节点 1）+ Rhinestone Smart Sessions 的链上可组合 Session Key 标准（手册节点 4）。**权限系统层**：Session Key 的生命周期管理（创建、约束、续期、撤销——手册节点 4）+ Policy 的定义框架和检查引擎（手册节点 5）+ Guard 的确定性拦截逻辑（手册节点 6）。**安全机制层**：Simulation 预执行预览（Tenderly API——手册节点 7）+ Revocation 机制（用户可见关闭开关 + 自动撤销触发——手册节点 8）+ MPC 分布式签名（Cobo 方案——私钥分片从不完整出现）+ Human Check 分层确认体系（手册节点 9）。**产品层**：Cobo Agentic Wallet（Pact + Policy Engine + MPC 安全——目前最完整的 Agent 权限产品实现）+ Safe 多签基础设施（Modules + Guard 扩展 + 交易草稿审批流）+ 可能的钱包端集成（MetaMask Snaps 嵌入 Simulation 预览 + Human Check 界面）。与 Dir1 的关键区别：Dir1 解决"Agent 如何支付"，Dir3 解决"Agent 支付时走什么权限通道、被什么规则约束"。与 Dir4 的协同：Dir3 的 Policy/Guard/Revocation 是 Dir4 纵深防御栈中的"确定性拦截层"。 |
| 7 | **失败原因？** | 最大风险：**权限风险——Policy 的工程折中极难做对**（手册节点 5）。设得太宽等于没设（Agent 在白名单协议里可以做任何事，无常损失、rug pull、MEV 攻击仍然会发生），设得太窄 Agent 没法用（每换一个池子、每调整一次仓位都需要人工批准，失去了 Agent 的自动化价值）。这个折中无法通过技术本身解决，因为风险判断（"这个协议安全吗""这个池子的 APY 是真实的还是钓鱼"）是 AI 不擅长的——Agent 可能被恶意合约文档欺骗（手册节点 7 的 Simulation 无法检测合约逻辑恶意）。其次是**用户不愿改变流程**："让 AI 管理我的钱"的心理门槛远高于"让 AI 帮我点外卖"——手册节点 9 指出 Human Check 如果设计不当（显示一串哈希而非可读的影响展示），用户要么盲目批准要么弃用。第三是**接口不成熟**：Session Key 标准尚未统一（Safe 和 Rhinestone 的实现不完全兼容，不同钱包的 Session Key 无法互操作——手册节点 4），Simulation 覆盖不全（跨链操作、MEV 相关场景 Tenderly 无法准确模拟——手册节点 7），Policy 的表达能力受限于合约接口（不是所有协议的操作都能被白名单+限额充分约束）。最可能的失败场景：Agent 在一个用户批准的"看似安全"的白名单协议里亏了钱（无常损失、恶意池子、预言机操纵），用户永远不再信任任何 Agent 钱包。

---

### Direction 4：Privacy / Security / Sovereignty

#### 一句话

引入 AI 之后，Web3 要面对两件事：一是 AI 带来的全新攻击面（Security/Privacy）——Prompt Injection、密钥泄露、链上公开数据与 AI 私有记忆拼接；二是平台锁定风险（Sovereignty）——Agent 替你管钱包、记偏好、做决策，但数据能不能带走？模型能不能换？Agent 身份会不会被单点封掉？

#### 三问

- **解决什么真实问题？** 两层：(1) Security/Privacy — Agent 可被合约注释、网页、API 返回值注入恶意指令，诱导泄露密钥、修改交易目标、越权调用工具。(2) Sovereignty — 当前 AI 平台本质锁定用户：Agent 的记忆和身份留在平台，模型不可换，数据不可迁移，一旦平台封禁 Agent 的执行能力就消失。这是 AI × Web3 特有的平台风险，传统 AI 安全不谈这个。
- **AI 角色？Web3 角色？** AI 既是保护的对象（防注入、防滥用），也是威胁本身（幻觉、被恶意上下文诱导）。Web3 提供：(1) 确定性拦截层 — Guard/Policy/Simulation 在链上执行前拦最后一道；(2) 主权基础设施 — ERC-8004 让 Agent 身份跨平台、可迁移数据 + 多模型 fallback + 链上审计日志 + Local-first AI 减少对外部平台的依赖。
- **落地层？** Security/Privacy 是横向防御机制（渗透 Dir1-Dir6 每个环节）；Sovereignty 更接近价值底层（数据可迁移、模型可替换、身份可携带 = CROPS 在 AI 领域的应用）。Security 防的是外部攻击者，Sovereignty 防的是平台本身。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | Security/Privacy：不成立——Prompt Injection、Tool Abuse、Malicious Context 完全是 AI 带来的。Sovereignty：不成立——没有 AI 就没有"平台锁死你的 Agent"这回事 |
| 2 | **没有 Web3？** | Security/Privacy：同样成立，但错误上链无法回滚。Sovereignty：**不成立**——这是 Dir4 里 Web3 成分最重的一层。Censorship Resistance、Data Portability、Model Choice 是 DNA 里的 Web3 思想（去中心化、自托管、抗审查），传统 AI 平台商业模式就是锁用户 |
| 3 | **角色分配？** | 系统设计者 → 分层上下文 + 工具权限隔离 + 开放数据导出接口。平台 → 提供多模型切换、身份可迁移、Local-first 选项。用户 → 能查能改能撤能带走 |
| 4 | **自动化 vs 人工？** | 自动：Guard/Sandbox/Rate limit。人工：Prompt Injection 命中判断、模型切换后的高风险验证、数据导出/迁移的确认 |
| 5 | **如何验证？** | 技术层：Audit Log 全链路 + hash 锚定链上。主权层：用 CROPS 检查 — 身份抗审查吗？关键组件开源吗？数据可导出吗？权限可撤销吗？ |
| 6 | **落地层？** | Security/Privacy = 安全机制层（横向渗透）。Sovereignty = 价值底层 + 产品原则（Data Portability、Model Choice、Local-first 不是技术选型，是产品设计决策） |
| 7 | **失败原因？** | Security：信任不可建立（攻击面太大）。Sovereignty：**用户不愿改变流程**（习惯了便利，不愿为 Portability/Self-custody 付出摩擦成本） |

#### 三层拆解

| 层 | 核心问题 | 是传统 AI 安全吗？ | Handbook 来源 |
|:---|:---------|:-----------------:|:------------|
| **Security** | Prompt Injection、Tool Abuse、Malicious Context、Key Safety | ✅ 纯传统 AI 安全 | AI Security 章（8 节点） |
| **Privacy** | Data Boundary、Local AI、Minimal Disclosure、Secret Management | ⚠️ 半传统 + "链上公开"的紧迫感 | AI Privacy 章（7 节点） |
| **Sovereignty** | User Control、Data Portability、Model Choice、Censorship Resistance、d/acc、CROPS | ❌ 几乎纯 Web3 原生 | AI Sovereignty 章（7 节点） |

Security 防外部攻击者。Privacy 防数据泄露。Sovereignty 防的是**平台本身**——它不攻击你，它锁住你。

---

### Direction 5：Dev Tooling / Agent Workflow

#### 一句话

AI 不是取代 Web3 开发者的"自动驾驶"，而是嵌入工具链的"增强层"——从合约阅读、交易解码、测试生成到部署验证，AI 降低从意图到代码的翻译成本；Agent Workflow（Task Graph + State Machine + Human-in-the-loop）则把 AI 的辅助能力串成可暂停、可审计、可回滚的确定性流程，防止概率模型在高风险链上操作中自由发挥。

#### 三问

- **解决什么真实问题？** Web3 开发认知负担极高：未开源合约的字节码难以逆向理解意图、链上交易 revert 原因不直观且上下文碎片化、测试用例编写耗时且覆盖不全、跨协议交互的上下文分散在多个浏览器和文档中。AI 可以把"读字节码→理解逻辑""看 trace→定位原因""写测试→覆盖边界"的翻译成本降低一个数量级，同时 Agent Workflow 让 AI 的辅助行为有状态约束和人工断点，而不是黑箱输出。
- **AI 角色？Web3 角色？** AI：做上下文理解（自然语言→合约意图）、代码生成（意图→Solidity/测试脚本）、异常解释（revert trace→人类可读原因）、在 Agent Workflow 中担任计划生成和条件判断。Web3：提供不可替代的数据源（Blockscout 的已验证合约、Dune/The Graph 的链上数据索引）、执行沙箱（Tenderly Simulation 的预演环境）、合约标准库（OpenZeppelin 的审计后模板）、接口发现能力（whatsABI 从字节码提取 ABI 并解析代理）——AI 需要这些做"有根有据"的链上推理，而非凭空给建议。
- **落地层？** 开发者工具层（IDE 插件、CLI 助手、CI/CD 集成）+ Agent Workflow 方法论层（Task Graph / State Machine / HITL / Retry & Fallback / Trace / Eval Harness / Regression Set），以及桥接二者的编排框架层（LangChain/LangGraph 负责状态管理和工具调用）。重要的是区分两个子方向：AI-assisting-developers（工具嵌入）和 AI-becoming-the-developer（Agent 自主执行），后者是 Agent Workflow 的核心场景。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | 仍然成立——Foundry 的 cast/forge、Hardhat 的 console/tasks、Tenderly 的 Debugger、OpenZeppelin Wizard 都是 Web3 开发者已在用的成熟工具。但没有 AI 时，从"交易 revert"到"根因"的排查靠人工翻 trace 和 Etherscan，从"需求"到"合约代码"靠经验和模板，从"接口未知的合约"到"可用 ABI"靠手动反编译——每一步都是高摩擦的。AI 消除的不是开发本身，而是中间的翻译和检索成本。 |
| 2 | **没有 Web3？** | 部分成立——通用 AI 编程助手（Copilot/Cursor）已经可以辅助写 Solidity 语法。但 AI 的链上推理需要 Web3 独有的数据基础设施：whatsABI 提供字节码→ABI 的逆向解析、Tenderly 提供交易模拟沙箱、Blockscout 提供已验证合约源码、Dune/The Graph 提供结构化链上数据——没有这些，AI 只能给语法建议，无法做"这笔交易为什么失败""这个合约是否危险"这类有根有据的链上分析。 |
| 3 | **角色分配？** | 开发者：定义目标、审查 AI 输出、对安全和资产相关决策做最终确认、为 Agent Workflow 设置 HITL 断点。AI Agent：读取合约与交易上下文、生成候选代码/测试/部署脚本、解释执行结果、在 Task Graph 中推进步骤并在遇到边界时暂停。工具链：Foundry/Hardhat 提供测试与部署执行环境，Tenderly 提供模拟沙箱，OpenZeppelin 提供审计后合约库，Blockscout/Dune 提供可查询的链上数据源。 |
| 4 | **自动化 vs 人工？** | 自动：合约代码阅读摘要、交易 calldata 解码与意图解释、测试用例生成、gas 优化建议、文档生成、已知漏洞模式扫描。人工必须确认：主网合约部署、高危函数调用（upgrade/selfdestruct/unlimited approve）、安全审计结论、Agent 首次接触的新协议交互。Agent Workflow 的 HITL 原则是：只读分析全自动，交易草稿自动生成，高风险操作设强制人工断点——人确认时须能看懂资产变化、权限变化和失败风险。 |
| 5 | **如何验证？** | 三层验证。代码层：AI 生成的 Solidity/测试脚本通过 Foundry forge test 和 Hardhat test 在 Tenderly 模拟环境中实际执行，覆盖率报告确认边界。分析层：AI 对合约/交易的解读，用 Blockscout 已验证源码和实际链上状态做交叉验证——AI 说"这是个代理"时，whatsABI 的结果必须一致。流程层：Agent Workflow 的 Trace 记录每一步输入/输出/判断理由，Eval Harness + Regression Set 确保每次修改模型或工具后，Agent 不会在已知危险场景（错误链、无限 approve、恶意合约）中退化。 |
| 6 | **落地层？** | 偏向**开发者工具层**（Solidity Visual Auditor 插件、cast-ai CLI 助手、Foundry chisel REPL 集成、CI/CD 自动化测试生成）+ **Agent Workflow 方法论层**（Task Graph 做步骤拆解、State Machine 做状态持久化、HITL 做权限边界、Trace 做审计回溯、Eval Harness 做系统化安全评估）+ **编排框架层**（LangChain/LangGraph 实现状态管理和工具调用路由）。关键区分：AI-assisting-developers 是工具嵌入的渐进改良，AI-becoming-the-developer（Agent 自主执行链上操作）是 Agent Workflow 的激进场景，后者必须有 HITL 和 State Machine 才能投产。 |
| 7 | **失败原因？** | 最大风险：**AI 生成代码的安全性不可靠**——看起来语法正确的 Solidity 可能有重入漏洞、溢出风险或权限漏洞，开发者过度信任 AI 输出导致直接部署到主网。其次是**接口不成熟**：Foundry/Hardhat/Tenderly 的 AI 集成度参差不齐，缺乏统一的 Agent-to-Tool 协议（类似 MCP 但面向 Web3 工具链）。第三是**用户不愿改变流程**：资深开发者认为 AI 建议干扰思路，新人则容易把 AI 输出当正确答案而不加审查——两者都会导致工具被弃用或误用。

---

### Direction 6：Governance / Coordination / Public Goods

#### 一句话

AI 可以帮助 DAO 做提案总结、会议行动项提取、贡献记录追踪、预算审核和 Sybil 检测——让集体决策更高效，但 AI 绝对不能替代人类投票，因为治理是 AI 幻觉社会成本最高的场景。

#### 三问

- **解决什么真实问题？** DAO 治理的信息过载——社区成员面对几十页提案没有时间细读，贡献者工作难以量化导致薪酬分配不公，公共物品 funding（如 Optimism RetroPGF）靠几十个 badgeholder 人工评审数百个项目无法规模化，Sybil 攻击让一人一票系统失效。
- **AI 角色？Web3 角色？** AI：提案摘要与差异对比、会议纪要转行动项、贡献图谱自动生成、预算合理性检查、Sybil 模式识别、投票趋势分析。Web3：链上治理记录不可篡改、智能合约执行投票结果、去中心化身份（DID/Gitcoin Passport）防 Sybil、可追溯的公共物品资金流。
- **落地层？** 治理协作层——既有协议/标准（Snapshot 投票框架、Tally 委托投票、Aragon DAO 框架），也有应用层工具（AI 摘要插件、Coordinape 贡献圈、Kleros 争议仲裁），更有公共物品分配机制（Optimism RetroPGF、Gitcoin Grants）。MakerDAO 的 Endgame 计划已在探索 AI 辅助治理的边界，Nouns DAO 的实验性治理也提供了丰富的提案数据。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | 成立但效率极低——DAO 本来就由人类治理。但信息过载真实存在：Optimism RetroPGF 第三轮收到数百个项目申请，badgeholder 评审疲劳严重影响分配质量。AI 降低的是信息处理成本，不是替代决策本身 |
| 2 | **没有 Web3？** | 部分成立——Reddit 子版块也可以用 AI 辅助管理。但 Web3 的关键差异在于：投票结果需链上执行不可篡改、公共物品资金需可追溯、Sybil 防御需要去中心化身份（Gitcoin Passport 的 Stamp 体系）。没有链上约束，AI 的建议只是建议，无法触发真正的资源分配 |
| 3 | **角色分配？** | 贡献者 → 提交贡献记录 / 领取 Grant。社区成员 → 投票决策（最终权在人类）。AI → 摘要提案、标注差异、计算贡献权重、标记异常、推荐分配方案。链上合约 → 执行投票结果、锁定/释放资金。重点：AI 是顾问，永远不是 voter |
| 4 | **自动化 vs 人工？** | 自动：提案摘要生成、贡献数据聚合（如 Coordinape 的贡献图谱）、Sybil 风险评分、预算模板化审核。人工：最终投票（不可自动化）、争议仲裁（如 Kleros 需要陪审员）、高额资金分配决策、治理框架变更 |
| 5 | **如何验证？** | AI 摘要可通过原始提案全文对比验证（用另一个 LLM 交叉检查）。贡献记录可通过链上活动（提交、PR、交易）自动核实——Gitcoin Grants 已用链上数据验证项目活跃度。Sybil 检测对错可通过事后抓到的假账号验证。关键原则：AI 输出必须可追溯、可复审、可推翻 |
| 6 | **落地层？** | **治理协作层**——不是底层协议，也不是纯应用，而是架在治理框架之上的智能辅助层。Snapshot 提供投票基础设施，AI 插件做摘要分析；Coordinape 提供贡献评估框架，AI 做贡献图谱聚合；Kleros 提供争议仲裁，AI 做证据整理 |
| 7 | **失败原因？** | 最大风险：**信任不可建立**——社区不信任 AI 摘要的准确性（Hallucination 导致提案关键点被歪曲），且 AI 摘要若被治理捕获方操纵，将加剧中心化。其次是**用户不愿改变流程**（DAO 成员习惯了"TL;DR"靠 KOL 摘要），以及**接口不成熟**（现有 DAO 工具缺乏 AI 插件标准） |

---

### Applied Path：Agent DeFi Execution

#### 一句话

Agent DeFi Execution 是前六个方向的"试金石"——把 Dir1 的 Payment（支付结算）、Dir3 的 Wallet/Permission（权限分层）和 Dir4 的 Privacy/Security（纵深防御）放进一个真实的链上资产执行场景里检验：用户给 Agent 一个投资目标，Agent 在可编程权限边界内完成跨协议的 swap、流动性提供、yield farming，每一步都有模拟预演、确定性拦截和可审计记录。

#### 三问

- **解决什么真实问题？** DeFi 的策略执行窗口极短——最佳 swap 路由、最高 yield 池、最安全的清算线都在几分钟甚至几秒内变化，人类无法 7×24 监控和响应。同时，手动操作 DeFi 的认知门槛极高：需要理解 AMM 滑点、借贷健康因子、无常损失、MEV 风险和跨协议依赖。Agent 的价值不是"帮人点按钮"，而是在用户设定的风险参数内自动抓取机会，同时比人更快、更全面地扫描风险信号。
- **AI 角色？Web3 角色？** AI：理解用户的投资意图（"在风险可控范围内追求稳定收益"→ 翻译成具体的协议选择、仓位配置、再平衡触发条件），实时扫描链上数据（池子深度、APY 变化、清算风险、异常价格偏离），生成候选交易草稿并请求执行。但它也是概率系统——可能被恶意合约描述欺骗、误判无常损失、或在市场剧烈波动时做出错误决策。Web3：提供三层机制——(1) **可编程权限边界**（Cobo Agentic Wallet 的 Pact 定义额度/目标/方法白名单，Safe 的 Session Key 给临时授权，Policy Engine 做确定性拦截）；(2) **执行前验证**（Tenderly Simulation 预演交易结果，Guard 在交易发出前检查是否越界，MEV 保护通过 CowSwap/1inch Fusion 的 intent-based 执行避免 sandwich attack）；(3) **不可篡改的审计记录**（每一步 swap、存款、提款都有链上收据，Cobo 的 Full Audit Trail 记录允许/拒绝/暂停决策）。
- **落地层？** 这是一个**端到端的应用场景**，不是单一协议或产品。它垂直整合了 Dir1 的支付结算（Agent 需要支付 gas、支付协议费用、跨协议结算）、Dir3 的权限系统（Pact / Session Key / Policy Engine 构成可编程权限栈）和 Dir4 的安全防御（Simulation + Guard + MPC + Audit Trail 构成纵深防御栈），在 DeFi 协议层（Uniswap/Aave/Yearn/CowSwap）之上运行。Cobo 的 Agentic Wallet 是这个路径的参考实现——Pact 定义"做什么、用什么协议、最大金额"，Policy Engine 在服务端拦截越界请求，MPC 确保私钥从不完整出现。

#### 7 问评估

| # | 问题 | 回答 |
|:-:|------|:----|
| 1 | **没有 AI？** | 仍然成立——人类可以手动在 Uniswap 上 swap、在 Aave 上存款、在 Yearn 上存 vault。但 AI 解决的是三个不可替代的问题：(1) **7×24 实时响应**——最优 swap 窗口、yield 变化、清算风险活跃在凌晨和周末，人类无法持续盯盘；(2) **多维度并行扫描**——Agent 同时追踪 gas 价格、多个 DEX 的池子深度、预言机价格偏离、借贷协议健康因子，人类的注意力只能串行；(3) **意图到策略的翻译**——用户说"追求稳定收益"，Agent 需要判断具体是存 Aave 还是 Yearn vault、拆分多少比例、什么条件触发再平衡，这是需要上下文理解和动态判断的任务。AI 不是取代人做决策，而是把"意图→策略→执行"链路上的人类瓶颈消除。 |
| 2 | **没有 Web3？** | 不成立。传统金融中也有算法交易和 robo-advisor（Betterment、Wealthfront），但它们做不到：(1) **无需托管**——用户资产始终在 Smart Account 里，Agent 的权限可随时撤销，传统 robo-advisor 需要你把钱打进它的账户；(2) **可编程权限粒度**——Pact 可以精确到"每天最多 swap 1000 USDC、只能用 Uniswap V3 的 ETH/USDC 池、slippage 不超过 1%"，传统金融的授权是二元的（有权/无权）；(3) **可组合的策略执行**——Agent 可以在 Uniswap swap 后自动把产出存入 Aave 作为抵押品再借出稳定币存入 Yearn vault，这种跨协议的可组合操作在传统金融中需要多个中介、多天结算；(4) **链上审计不可篡改**——每一笔交易和权限决策都有链上记录，传统 robo-advisor 的内部账本可以被篡改或选择性披露。 |
| 3 | **角色分配？** | 用户/Agent Owner → 设定 Pact（定义任务目标、协议白名单、金额上限、滑点容忍度、风险参数），批准首次授权，随时撤销。Agent → 在 Pact 范围内读取链上数据、生成策略草稿、请求执行 swap / 存款 / 提款 / 再平衡，但不能超出 Pact 边界。Cobo Agentic Wallet / Safe → 作为执行层承载 Session Key 和 Policy Engine，在 Agent 请求执行时做确定性拦截（额度检查、白名单校验、slippage 校验）。Tenderly / Simulator → 预演交易结果，返回预期资产变化和风险信号。MPC 钱包（Cobo）→ 分布式持有私钥分片，签名从不在单一位置完成。失败成本的承担：超出 Pact 边界的请求被 Policy Engine 自动拒绝（无损失）；在 Pact 内但策略失误（如无常损失）的损失由用户承担——这要求 Pact 的风险参数设定足够保守。 |
| 4 | **自动化 vs 人工？** | 自动：Pact 内的低风险操作——白名单协议的 swap（固定限额）、稳定币存款/提款、触发条件的仓位再平衡（如健康因子低于阈值自动补仓）、yield 下降时自动迁移到更高收益池。人工必须确认：新协议首次加入白名单、超过日限额的大额交易、涉及新 token 类型的操作、Pact 参数修改、异常市场条件下（TVL 骤降 >50%、预言机价格偏离 >10%、协议出现安全公告）Agent 应自动暂停并等待人工决策。核心原则：能写进 Pact 的规则自动执行，需要"判断这个协议是否安全"的决策必须人工介入——因为 AI 可能被恶意合约文档欺骗。 |
| 5 | **如何验证？**  | 三层验证：(1) **执行前模拟**——Tenderly Simulation 在交易发送前预演结果，返回预期资产变化（收到多少 token、健康因子变化、是否触发清算），与 Pact 中的 slippage 上限和风险参数做自动化比对；(2) **确定性拦截**——Policy Engine 在交易广播前做规则检查：目标合约是否在白名单、金额是否在限额内、slippage 是否超标、调用的方法签名是否允许。这层验证不依赖模型输出，是确定性代码；(3) **事后审计**——链上收据记录每一步交易，Cobo 的 Full Audit Trail 记录 Agent 的每次请求和 Policy Engine 的允许/拒绝决策。验证成本中等（一次 Simulation 约 1-2 秒，一次 Policy check 即时），但远低于人工逐一审查每笔交易。关键原则：验证不是"信任 Agent 的报告"，而是"用确定性系统在 Agent 行动前后做独立检查"。 |
| 6 | **落地层？** | 偏向**端到端的应用场景层**——它不是一个独立协议，而是把 Dir1（支付结算）+ Dir3（权限系统）+ Dir4（安全防御）垂直整合在 DeFi 协议层之上，面向最终用户交付一个"设定目标→Agent 执行→风险可控"的完整体验。技术栈包括：权限层（Cobo Pact + Safe Session Key + ERC-4337）、安全层（Tenderly Simulation + Policy Engine Guard + MPC 分片签名）、执行层（Uniswap V3/V4 swap、Aave V3 借贷、Yearn V3 vault、CowSwap/1inch Fusion intent-based 执行防 MEV）、数据层（链上 RPC + The Graph 索引 + Chainlink 预言机价格）。与 Dir1 的关键区别：Dir1 解决的是"Agent 如何支付"的基础设施问题，这个路径解决的是"Agent 支付了之后要干什么"的端到端场景问题——Dir1 是水管，这个路径是花园灌溉系统。 |
| 7 | **失败原因？** | 最大风险：**信任不可建立 + 权限风险**的叠加。用户需要同时信任：(a) AI 不会在 Pact 边界内做出错误策略（误判无常损失、追逐虚假高 APY 的 rug pull 池、在预言机被操纵时仍按偏离价格交易），(b) Pact 的边界设定足够保守以至于策略失误的损失可控，(c) 整个技术栈（Simulation/Policy/MPC）没有实现漏洞。这三个信任条件太容易连锁崩溃——比如 Simulation 显示安全但实际执行时被 sandwich attack（因为 Simulation 无法预测 mempool 排序），或者 Policy Engine 的规则被 bypass（白名单中的一个协议被攻击后变成恶意合约）。其次是**用户不愿改变流程**——"让 AI 管理我的钱"的心理门槛远高于"让 AI 帮我点外卖"。第三是**接口不成熟**——Session Key 标准尚未统一（Safe 和 Cobo 的实现不完全兼容），Simulation 覆盖不全（跨链操作、MEV 相关场景无法准确模拟），DeFi 协议的接口变更频繁（Uniswap V4 的 hook 机制完全改变了交互模式）。最可能先失败在"Agent 在一个看似安全的白名单协议上亏了用户的钱，用户永远不再信任任何 Agent"这一场景。 |

#### 我的判断

Agent DeFi Execution 是六个方向中最"重"的——它不是在白板上画架构图，而是把 Dir1/3/4 的理论框架放进真实资产的熔炉里检验。核心张力不是"AI 够不够聪明"，而是**自主执行 vs 安全边界**的工程折中：Pact 设得太宽等于没设（Agent 可以在白名单协议里做任何事），设得太窄 Agent 没法用（每换一个池子都需要人工批准）。真正的突破可能不是在一个方向做深，而是在三个方向之间找到最小可行的"交叉点"：用 Dir3 的 Session Key + Policy 做权限边界，用 Dir1 的托管支付做 gas 管理和结算，用 Dir4 的 Simulation + Audit Trail 做安全验证——三个机制叠加后才能让 Agent 在 1000 USDC 级别上真正跑起来。Cobo 的 Pact + Policy Engine 是目前最接近这个交叉点的实现，但离"用户放心让 Agent 管理 10 万 USDC"还有很长的路。
