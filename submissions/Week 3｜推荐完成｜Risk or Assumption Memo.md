# Week 3 — Risk / Assumption Memo

> 项目成立前提 · 最可能失败点 · Week 4 Fallback Plan
> 作者：Calciux | 日期：2026-06-05
> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements

---

## 一、项目成立依赖哪些前提

以下前提如果有一条不成立，整个项目从根上就无法 work——不是 demo 不好看的问题，是跑不通的问题。

### 前提 1：ERC-8183 标准本身安全正确

**假设**：ERC-8183 定义的 6 状态状态机、角色权限矩阵、`claimRefund` 不可 Hook、`fund()` 的 `expectedBudget` 防 front-running——这些设计本身没有安全漏洞。

**实际情况**：ERC-8183 是 **Draft ERC**，不是 Final Standard。虽然状态机逻辑经过了社区讨论，但历史上 Draft 阶段的 ERC 在被正式实现和审计前出过问题。我们没有审计能力去验证标准本身的安全性——我们在信任标准作者。

**如果前提不成立**：合约实现再正确也没用，协议层漏洞无法通过应用层修补。

### 前提 2：Solidity 合约实现零关键 bug

**假设**：能从 ERC-8183 标准文本准确翻译到 Solidity 代码，状态转移条件、权限检查、事件发射全部正确。

**实际情况**：这是第一个完整 Solidity 合约项目。标准文本中的约束（如"Funded 后 Client 不能 withdraw""Submitted 后只有 Evaluator 能动""claimRefund 不可 Hook"）需要正确编码为 modifier + require/revert。任何一处遗漏或逻辑错误都可能导致：
- 资金锁死（claimRefund 被意外拦截）
- 权限绕过（非 Evaluator 调了 complete）
- 状态卡死（转移条件写错导致永远进不了 Submitted）

**如果前提不成立**：测试网上丢的是测试 ETH，但 Demo 展示出 bug 直接致命。

### 前提 3：LLM Evaluator 评分一致性

**假设**：同一个交付物，LLM Evaluator 多次评分结果落在可接受范围内——即"应该通过的交付物"不会因为 LLM 的随机性被判 Reject。

**实际情况**：这是本项目最脆弱的假设。LLM 是概率模型，对同一输入两次输出可以不同。Temperature 设为 0 可以减少但不消除方差。checklist 逐项评分（5 个 yes/no）比开放式判断稳定，但：
- 如果交付物在"边界"上（3-4 项 yes），两次评分可能一次 ≥4 一次 <4
- 不同 LLM（GLM-5.1 vs DeepSeek）对同一交付物的判断可能不同
- Prompt 微调可能导致评分偏移

**如果前提不成立**：Provider 交了合格的活但 Evaluator 判 Reject，整个 trustless 叙事崩了——"你的 trustless 系统判错了，然后呢？"没有然后，因为 ERC-8183 本身没有争议机制。

### 前提 4：单 Evaluator 不作恶

**假设**：MVP 只有一个 Evaluator，假设它不偏袒 Client，不偏袒 Provider，按 checklist 诚实评分。

**实际情况**：这个假设在 demo 阶段可以控制（Evaluator 是我们自己部署的），但作为系统设计这是一个已知的信任洞。ERC-8183 标准原文自行标出："Evaluator is a single point of trust — once Submitted, it can decide arbitrarily." 标准作者自己都承认这一点。

**如果前提不成立**：Evaluator 偏袒 Client → Provider 白干。偏袒 Provider → Client 白付钱。MRC（多仲裁委员会，ERC-8004）是未来的解，不在 MVP 范围。

### 前提 5：Sepolia 测试网可用

**假设**：Hackathon 期间 Sepolia RPC、水龙头、Etherscan 正常服务。

**实际情况**：公共测试网在 Hackathon 期间可能拥堵（很多人同时部署测试）。Etherscan Sepolia 被 Cloudflare 阻挡的历史问题（已遇到过——需要手动存 HTML 到本地读）。

**如果前提不成立**：退到本地 Hardhat node 跑状态流转，但失去"链上可验证"这个关键叙事。Etherscan tx hash 是 Demo 的核心证据来源。

### 前提 6：CAW API 可用且文档准确

**假设**：Cobo Agentic Wallet 的 API 可正常调用；文档中的 Pact 创建流程、Policy Engine 拦截逻辑、MPC 签名接口与实际行为一致。

**实际情况**：CAW 是完全不熟悉的系统。API 稳定性未知，文档可能滞后于实际实现。赛道要求集成 CAW——如果 API 有坑，花在调试上的时间不可预测。

**如果前提不成立**：CAW 是必选项，没有降级空间——必须投入时间攻克集成问题。赛道对齐要求 CAW 在任何交付路径中都不可移除。

### 前提 7：评审者理解 Trustless 边界

**假设**：Hackathon 评审者能理解"ERC-8183 提供 trustless 的执行（资金托管+结算），但验收判断不是 trustless"——这个区分是本项目的核心叙事，如果评审期望"全链路 trustless"那项目天然不符合。

**实际情况**：不是所有评审都有 Web3 技术背景。"trustless"这个词在 Hackathon 场景下容易被简化理解为"不需要信任任何人"——但我们的项目明确说 Evaluator 是 single point of trust。

**如果前提不成立**：需要在 Demo 和 README 中非常明确地讲清楚这个边界，否则评审会认为项目没完成"trustless"的目标。

---

## 二、最可能失败在哪里

按真实概率排，不按"哪个听起来更体面"排。只列有实际杀伤力的。

### 🔴 失败点 1：Evaluator 误判 → 整个 trustless 叙事崩盘

**概率**：最高。**影响**：毁灭性。

LLM Evaluator 对边界交付物的判断不稳定是结构性的（见前提 3），不是工程上能"修好"的。Demo 时如果 Evaluator 判错一次——Provider 交了明显合格的活但被 Reject，或者交了明显不合格的活但被 Complete——整个 trustless 叙事就崩了。评审会问："所以你的 trustless 系统判错了，用户怎么办？" 答："复查 Evaluator 理由。" 追问："那 trustless 在哪？还是要人判断？"

**这不是一个能通过"多测几次"解决的问题**——因为 Demo 只演示一次，这一次不能出错。而 LLM 判断就是有出错概率。

**真实缓解**：
- Demo 场景选一个"明显合格"的交付物——checklist 5/5，不给 Evaluator 留判断空间
- 在 Demo 叙事中主动标出这个局限，而不是等评审发现
- 考虑固定 Evaluator 评分（不做真的 LLM 调用）——Demo 展示的是"Evaluator 这个角色在流程中的位置"，不是 LLM 的准确性

### 🔴 失败点 2：合约 bug 导致状态卡死或资金锁死

**概率**：中高。**影响**：致命。

ERC-8183 状态机的安全属性（特别是 `claimRefund` 不可 Hook 和 Funded 后 Client 不能撤资）完全依赖于合约实现正确。几个最容易出错的地方：

| 出错点 | 后果 |
|--------|------|
| `claimRefund` 被 modifier 意外拦截 | 资金永久锁死——没有其他退款通路 |
| `submit()` 后状态没正确切换到 Submitted | Evaluator 无法 complete/reject，卡死 |
| `complete()` 放款逻辑写错（转了错误的金额或错误地址） | 钱去了不该去的地方 |
| `fund()` 的 `expectedBudget` 防 front-running 写错 | 可被 front-run 被多锁资金 |
| 事件发射遗漏或参数错误 | Etherscan 上看不到正确的状态流转 |

**真实缓解**：
- Remix 先部署，走完所有 6 状态 + 所有转移路径 + 边界测试（非 Happy Path），再进 Hardhat
- 极小金额（0.0001 ETH）先跑通所有路径
- 写一个状态转移测试检查清单：每个转移条件是否按标准原文实现

### 🟡 失败点 3：CAW 集成时间失控

**概率**：中高。**影响**：中等——CAW 是必选项，无降级空间，但可通过提前熟悉 API 降低阻塞风险。

不熟悉 API + 不熟悉 MPC 钱包模型 + Hackathon 时间压力 = 可能花一整天调试一个 API 调用。CAW 文档可能和实际行为不一致，Policy Engine 的拦截规则可能比文档描述的更严格。

**真实缓解**：
- **不要**在 Week 4 第一天才开始看 CAW——Week 3 结束前至少跑通 CAW 的"创建钱包 → 查余额"最基本的流程
- MVP 先用 EOA 跑通全流程，CAW 作为替换层接入
- CAW 集成是硬性要求，遇到阻塞时调整策略而非降级——例如先用最简路径跑通 Pact 创建 + MPC 签名，再逐步叠加 Policy Engine 等高级功能

### 🟡 失败点 4：端到端联调地狱

**概率**：高。**影响**：中等。

四个组件第一次联调必然出问题：

| 组件 | 常见坑 |
|------|--------|
| 合约 | ABI 不匹配、事件签名错误 |
| Client Agent | nonce 管理、gas 估算、交易确认等待 |
| Provider Agent | 同上 + `submit()` 参数格式 |
| Evaluator | `complete()`/`reject()` 权限检查、事件解析 |

每个坑单独都不难，但四个组件串起来时，定位问题跨多个日志来源（合约事件 + Python 输出 + Etherscan），调试效率低。

**真实缓解**：
- 每个 Agent 脚本先单独对着已部署的合约测试（Remix 手动创建 Job → Python 脚本读状态）
- 联调时每步都先查合约状态（不要信 Agent 的输出，去 Etherscan 或直接调 `getJob()`）
- 写好调试辅助脚本：`python check_status.py <jobId>` 直接返回当前状态

### 🟡 失败点 5：时间不够

**概率**：高。

Week 4 实际可用的开发天数可能只有 3-4 天（取决于 Week 3 任务完成进度和时间分配）。四个组件 + 联调 + Demo 录制 + README + 提交包——即使一切顺利，时间也很紧。任何一个组件卡住超过半天，就需要做出取舍。

**真实缓解**：见第三节 Fallback Plan。

---

## 三、Week 4 Fallback Plan

核心原则：**宁可交付一个范围小但跑通的 demo，也不要交付一个范围大但半成品的东西。**

### Tier 1 — 理想路径（全量 MVP）

**交付**：合约 + CAW + 3 个 Agent 脚本（Client/Provider/Evaluator）全自动端到端 Demo + 视频 + README。

**前提**：所有前提成立，没有组件卡住超过 2 小时。

**时间分配**：
| 任务 | 预计 |
|------|:---:|
| ERC-8183 合约编码 + Remix 部署 + 全状态测试 | 4h |
| Client Agent 脚本 | 2h |
| Provider Agent 脚本 | 2h |
| Evaluator 脚本 | 2h |
| CAW 集成 | 2h |
| 端到端联调 | 3h |
| Demo 视频录制 | 1h |
| README + 提交包 | 1h |

**触发条件**：Week 4 Day 1 结束时合约已部署并在 Remix 上走通所有 6 状态转移。

### Tier 2 — 降级 A：简化实现，CAW 保留

**触发条件**：整体进度落后，多个组件卡住，需收缩范围但不可移除 CAW。

**交付**：合约 + CAW（Pact + MPC 签名）+ 简化 Agent 脚本 + 端到端 Demo。

**变化**：
- CAW 集成保留：Pact 创建 + MPC 签名完整链路——CAW 是必选项，不可降级
- Agent 脚本简化：去掉非核心错误处理、日志装饰，只保留 Happy Path 关键逻辑
- 联调范围收缩：只覆盖一条完整 Happy Path（createJob → fund → submit → evaluate → complete）
- Evaluator 可使用固定评分（非真实 LLM 调用），聚焦展示 Evaluator 在流程中的角色位置

**时间重新分配**：
| 任务 | 预计 |
|------|:---:|
| CAW 集成（Pact + 签名） | 2h |
| 简化 Agent 脚本（2-3 个） | 3h |
| 联调（Happy Path 单线） | 2h |

**原则**：CAW 在任何交付路径中都是必选项。降级的是 Agent 复杂度、联调覆盖范围和 Evaluator 实现深度，而非移除 CAW。

### Tier 3 — 降级 B：去 Agent 自动化，手动分步 Demo

**触发条件**：Agent 脚本联调持续失败（非合约问题），或 Week 4 Day 3 结束时端到端仍未跑通。

**交付**：合约 + Remix 手动交互 + Evaluator 手动运行 + 状态截图。

**变化**：
- 不写 Python Agent 脚本（或只写辅助查询脚本）
- Demo 流程：Remix 调 `createJob` → `setBudget` → `fund` → `submit` → 手动运行 Evaluator 评分 → Remix 调 `complete`/`reject`
- 每一步截图 Etherscan 上的事件日志和状态变化
- 重点展示"合约状态机流转正确"+"Etherscan 事件可验证"+"Evaluator checklist 评分逻辑"

**时间释放**：省下 Client Agent 2h + Provider Agent 2h + 联调 3h — 但多了手动操作和截图的时间（约 2h）。

**关键保留**：合约正确性 + 状态机完整性 + 链上可验证——这三样是核心。

### Tier 4 — 底线：纯合约展示

**触发条件**：仅剩不到 1 天，必须交付。

**交付**：ERC-8183 合约部署在 Sepolia + Remix 手动走完 6 状态 + Etherscan 验证 + README 说明完整设计。

**变化**：
- 不写任何链下代码
- Demo = 合约地址 + Etherscan 事件截图 + Mermaid 状态机图 + 设计文档
- 重点讲清楚"这个合约解决了什么问题"+"AI 在哪些环节介入"+"为什么 chain + AI 组合才是解"

**最低可接受交付**：一个正确的 ERC-8183 合约 + 清晰的叙事。如果连合约都写不出来，那就没有交付。

---

## 四、最残酷的真实评估

- **Evaluator 误判问题不会在 Hackathon 期间解决**——这是研究问题，不是工程问题。checklist 缓解但不消除。Demo 时我们能做的最好的事情是选一个"5/5 明显合格"的交付物，然后坦诚说这个局限。
- **单 Evaluator 是一个设计缺陷，不是一个"未来改进"**——但 MVP 只能这样。在 Demo 中不要试图解释"为什么一个 Evaluator 也够安全"，直接承认它不够安全，指出 MRC（多仲裁委员会，ERC-8004）是解。
- **CAW 集成是赛道硬性要求，Demo 中必须 live 展示**——Pact 预算授权 + MPC 签名流程需要完整跑通并呈现在 Demo 中。重点展示：Agent 通过 CAW Pact 授权交易额度 → CAW MPC 签名 → 合约交互上链。这是与赛道对齐的核心证据。Policy Engine 拦截逻辑在测试网上不易自然触发，可在 Demo 旁白中说明其在生产环境的安全价值。
- **Trustless 边界是项目最容易被误解的点**——如果评审说"这不完全 trustless"，回答不是"但我们有 checklist"，而是"对。ERC-8183 的 trustless 只管到资金托管和结算执行。验收判断天生不是 trustless 的——标准自己承认 Evaluator 是 single point of trust。AI 在这里的角色不是消除信任，是让信任变得可复查——公开 checklist 评分和理由，让人在事后能判断 Evaluator 判得对不对。"
