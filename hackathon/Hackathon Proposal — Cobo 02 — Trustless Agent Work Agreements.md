# Hackathon Proposal — Trustless Agent Work Agreements

> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements
> 作者：Calciux | 日期：2026-06-04
> 仓库：https://github.com/Calciux/ai-web3-learning

---

## 一句话

基于 ERC-8183 实现 Agent 间去信任工作协议：发包方 Agent A 发布任务并托管资金 → 接单方 Agent B 交付结果 → LLM Evaluator 自动验收 → 通过则付款释放，不通过则退款。

---

## 赛道对齐

| 赛道要求 | 本项目 |
|----------|--------|
| Agentic Commerce | Agent B 提供有偿服务，Agent A 购买服务 |
| CAW 角色 | 每个 Agent 持有 CAW 钱包，托管资金 + 接收报酬 |
| ERC-8183 标准 | Escrow 状态机（Created→Funded→Submitted→Accepted/Rejected→Released） |

---

## 目标用户

- 想把重复性分析任务外包的 Agent 开发者
- 想提供付费 Agent 服务并得到链上支付保障的服务提供者
- Hackathon Demo 场景：Research Agent 发包给 Analyst Agent 做 EIP 分析，自动验收付款

---

## Week 2 方向对齐

本项目属于 **Dir1（Payment / Commerce / Settlement）** 的范畴，对应课程模块 B 的完整 commerce 链路。验收（evaluator）是 Dir1 的内在环节，不是 Dir2 的外部附加。

```
Dir1（Payment / Commerce / Settlement）← 主
    完整 commerce 链路：发布→托管→交付→验收→结算→争议
    → ERC-8183 Escrow = 资金托管状态机（执行层）
    → LLM Evaluator = 验收角色（Dir1 验证层）
    → CAW = 预算控制 + 审计记录

Dir2（Identity / Reputation / Verification）← 未来增强
    跨交易的信任基座——ERC-8004 三注册表
    → 通过 8183 Hook 集成（complete → writeReputation）
    → MVP 暂不做，架构预留入口
```

| Week 2 方向 | 在本项目的角色 | 参考 |
|------------|--------------|------|
| **Dir1（主）** | Commerce 全链路：托管合约管理资金状态机 + Evaluator 验收作为验证层环节 | [模块 A Dir1](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%202%EF%BD%9C%E4%BA%A4%E5%8F%89%E9%A2%86%E5%9F%9F%EF%BD%9C%E6%A8%A1%E5%9D%97A-%E9%97%AE%E9%A2%98%E7%A9%BA%E9%97%B4%E4%B8%8E%E6%96%B9%E5%90%91%E5%9C%B0%E5%9B%BE.md) |
| Dir2（辅） | 未来方向：ERC-8004 声誉系统通过 8183 Hook 集成，使验收结果聚合为 Agent 历史声誉 | [模块 A Dir2](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%202%EF%BD%9C%E4%BA%A4%E5%8F%89%E9%A2%86%E5%9F%9F%EF%BD%9C%E6%A8%A1%E5%9D%97A-%E9%97%AE%E9%A2%98%E7%A9%BA%E9%97%B4%E4%B8%8E%E6%96%B9%E5%90%91%E5%9C%B0%E5%9B%BE.md) |
| Dir3 | 间接关联——CAW 提供 Agent 的钱包权限边界（预算/合约/时间窗口） | - |
| Applied Path | 无直接关系——本项目不涉及 DeFi 执行 | - |

---

## 问题定义

核心问题是 Dir1 的 commerce 问题：Agent 之间如何完成一次可追溯、可验证、有兜底的经济活动。

拆成 Dir1 四层框架里的两个关键子问题：

1. **执行保障（验证层）**：交付物是否合格？谁来验收、标准是什么？判断结果是否可复查？
2. **执行保障（协议层）**：判断做出后，资金如何安全地从托管中释放？双方都不能单方面动钱。

Cobo 02 赛道描述精确对应这个结构：「发布→托管→交付→验收/驳回→付款」——这是 Dir1 的完整 commerce 链路，验收在链路内，不是外部附加。

---

## 设计依据：Agentic Commerce 手册

参考：[AI × Web3 School Handbook — Agentic Commerce](https://aiweb3.school/zh/handbook/tracks/agentic-commerce/)

手册提出的三个核心概念直接支撑本项目的设计：

### Payment Intent（支付意图）

手册定义：用户授权 Agent 花钱之前的结构化表达，应比一句"帮我买最合适的服务"更具体。

本项目 `createJob` 的结构化字段对应 Payment Intent：

| Payment Intent 字段 | 本项目实现 |
|---------------------|-----------|
| 任务目标 | `description` — "分析 ERC-8004 的核心机制" |
| 预算 | `budget` — 0.01 ETH 赏金 |
| 验收标准 | `checklist` — 5 个 yes/no 问题（如"是否覆盖三个 Registry？"） |
| 退款条件 | 超时 → `claimRefund`；验收不通过 → `reject` |
| 有效期 | `expiredAt` — 截止时间戳 |

### Budget Control（预算控制）

手册定义：预算应该分层——任务预算、服务预算、时间预算、风险预算、失败预算。MVP 实现单层任务预算（Escrow 托管金额），架构预留多层能力：

| 预算层 | MVP | 未来（CAW Pact） |
|--------|:---:|:---:|
| 任务预算 | ✅ Escrow 金额 | 同 |
| 服务预算 | — | 单次调用上限 |
| 时间预算 | — | 每小时/每天总额度 |
| 风险预算 | — | 新 Agent 首次交易需人工确认 |
| 失败预算 | — | 连续拒绝 N 次后暂停 |

### Proof of Task Completion（任务完成证明）

手册定义：不同服务类型需要不同的交付证明。本项目属于「人工服务/内容生成」类——证据 = 交付物 + 验收记录 + 争议窗口：

| 证明要素 | 本项目实现 |
|---------|-----------|
| 交付物 | Agent B 提交的分析报告（deliverableHash 指向内容） |
| 验收记录 | LLM Evaluator 的 checklist 评分 + 理由（公开存储，可复查） |
| 链上收据 | `complete()` 交易：payer/provider/amount/tx hash/timestamp |
| 争议窗口 | MVP 不做，留 `Dispute` 入口 |

手册还特别提醒：**高价值或主观结果不应该只靠模型自动放款**——本项目 MVP 场景为低价值（0.001 ETH 测试），且验收理由公开可复查，符合手册建议。

---

## 核心功能（MVP）

```
Agent A（发包方）                      Agent B（接单方）
     │                                      │
     │  ① createJob(描述, 赏金, 截止时间)     │
     │  → 资金进入 Escrow 合约                │
     │                                      │
     │                    ② applyForJob() ←─┤
     │                                      │
     │  ③ confirmProvider(B的地址)            │
     │                                      │
     │                    ④ submit(交付内容) ←┤
     │                                      │
     │  ⑤ LLM Evaluator 自动验收              │
     │     ├─ 合格 → acceptJob() → 付款给B    │
     │     └─ 不合格 → rejectJob() → 退款给A  │
```

**链上部分**：ERC-8183 标准 Escrow 合约（Solidity）

**链下部分**：
- Agent A：发布任务、确认接单方（可 AI 辅助生成任务描述）
- Agent B：接单、调用 LLM 完成分析、提交结果
- LLM Evaluator：调用 GLM-5.1 API，对比交付物和任务要求，输出 Accept/Reject + 理由

**Demo 场景**：A 发布「分析 ERC-8004 的核心机制」，B 提交一份分析报告，Evaluator 验收通过，资金释放给 B。

---

## 统一判断框架（7 问）——以 Dir1 Commerce 全链路为主视角

| # | 问题 | 回答 |
|---|------|------|
| 1 | **没有 AI？** | 仍然成立——人可以手动发包、验收。但 AI 提供 Dir1 链路中的关键适应性：(1) 不同任务需要不同验收方式，AI 可根据任务描述自适应生成验收 checklist；(2) 7×24 独立验收——人做 Evaluator 是单点瓶颈；(3) 在授权边界内做适应性判断——不只执行规则，而是理解上下文后决定 Accept/Reject |
| 2 | **没有 Web3？** | 部分成立——传统 Escrow.com 可托管资金。但 Web3 提供：(1) 无许可托管——任何 Agent 无需 KYC 即可接入（ERC-8183）；(2) 链上收据不可篡改——验收结果和结算记录上链后无法被任何一方删除；(3) 可组合性——托管合约可与 Dir3 权限层（CAW Pact）和 Dir2 声誉层（ERC-8004 Hook）组合。传统 Escrow 是封闭产品，链上托管是可编程积木 |
| 3 | **角色分配？** | 用户→设定预算边界（金额/合约/时间窗口，通过 CAW Pact）、处理争议升级。Agent A（发包方）→创建任务+托管赏金。Agent B（接单方）→接单+执行+交付。LLM Evaluator → Dir1 验证层角色：检查交付物+输出 Accept/Reject+理由。Escrow 合约（ERC-8183）→ Dir1 协议层：管理资金状态机（Open→Funded→Submitted→Completed/Rejected）。CAW→ Dir3 辅助：Pact 限制 Agent 能花多少、在哪花。失败成本：Evaluator 误判 → A 或 B 受损（最大风险）；A 不付款 → B 不交付（制衡） |
| 4 | **自动化 vs 人工？** | 全自动：任务发布、接单、交付、LLM 验收、Accept→付款。需人工：争议升级（对验收结果不服→人工复查 Evaluator 理由）、首次授权设置 Pact 边界。原则：验收标准和预算边界由人设定，边界内 Agent 自主执行，边界外自动拒绝或升级 |
| 5 | **如何验证？** | Dir1 课程三层：**支付层**——链上收据+Escrow 余额可查（成本极低）。**交付层**——Evaluator 的 checklist 逐项评分 + 验收理由公开存储，任何第三方可事后复查。**记录层**——所有状态变更 emit 事件，不可篡改。核心原则：链上记录让纠纷有据可查，不可抵赖 |
| 6 | **落地层？** | Dir1 课程四层框架：**场景层**（Agent B 提供 EIP 分析服务）→ **流程层**（发布→托管→交付→验收→付款）→ **验证层**（LLM Evaluator + checklist 评分 + 理由公开）→ **协议层**（ERC-8183 托管状态机 + CAW Pact 权限边界 + 未来 ERC-8004 Hook 声誉集成） |
| 7 | **失败原因？** | (1) Evaluator 误判——LLM 验收标准不稳定。缓解：具体 checklist（5 个 yes/no），得分≥4 通过；理由公开可复查。(2) 用户不敢让 Agent 自动花钱——需成功案例。(3) 争议时钱卡在合约——MVP 只做 Happy Path，Dispute 留入口。(4) Evaluator 是单点信任——未来需多 Evaluator 仲裁 + ERC-8004 声誉辅助 |

---

## 技术栈

| 层 | 技术 | 说明 |
|----|------|------|
| 智能合约 | Solidity + ERC-8183 参考实现 | Escrow 状态机：createJob → fundJob → applyForJob → confirmProvider → submitWork → acceptJob/rejectJob |
| 部署 | Remix / Hardhat | 部署到 Sepolia 测试网 |
| CAW 集成 | Cobo Agentic Wallet API | Agent A/B 各自持有 CAW 钱包，托管资金 + 接收报酬 |
| LLM Evaluator | GLM-5.1 API / DeepSeek API | 接收「任务要求 + 交付内容」→ 输出 Accept/Reject + 理由 |
| Agent 逻辑 | Python 脚本 | Agent A：创建任务+托管资金。Agent B：接单+调用 LLM 写分析+提交。Evaluator：调 LLM API 做验收判断 |
| 前端 Demo | 命令行 / 简单 HTML | 展示全流程状态流转 |

---

## 技术风险评估

| 风险 | 概率 | 缓解 |
|------|:----:|------|
| Solidity 合约写错 | 中 | 用 Remix 部署，在 Sepolia 测试，金额极小（0.001 ETH） |
| CAW API 不熟悉 | 中 | 先查 Cobo 文档，MVP 先用普通 EOA 钱包代替 CAW 先跑通 |
| LLM Evaluator 判断不稳定 | 高 | 验收逻辑用具体 checklist（5 个 yes/no 问题），得分≥4 才通过 |
| Hackathon 时间不够 | 中 | MVP 只做 Happy Path（验收通过），Dispute 分支只留代码入口不做实现 |

---

## 开发计划（Week 4 冲刺）

| 日 | 任务 | 交付物 |
|----|------|--------|
| Day 1 | Hardhat 环境搭建 + ERC-8183 最小合约编码 | 合约代码 + 编译通过 |
| Day 2 | 合约部署到 Sepolia + 手动测试状态流转 | 部署地址 + tx hashes |
| Day 3 | Agent A/B Python 脚本（创建任务+接单+提交） | 脚本可跑通 |
| Day 4 | LLM Evaluator 验收逻辑 + 端到端联调 | 完整 Demo 流程 |
| Day 5 | CAW 集成（如果时间允许）+ 前端/Demo 准备 | 可展示的 Demo |
| Day 6 | 录制 Demo 视频 + README + 提交材料 | 提交包 |

---

## Demo 展示计划（3 分钟）

```
0:00-0:30   场景设定："Agent A 想找人分析 ERC-8004，出 0.01 ETH 赏金"
0:30-1:00   链上操作：createJob → 资金进入 Escrow → Etherscan 验证
1:00-1:30   Agent B 接单 + 调用 LLM 写分析 → submit 交付 → 链上状态变更为 Submitted
1:30-2:00   LLM Evaluator 验收：展示 checklist 评分 → Accept → 付款给 B
2:00-2:30   Etherscan 验证：B 收到赏金，Escrow 清空
2:30-3:00   总结 + 风险说明 + 未来计划（Dispute 机制、多 Evaluator 仲裁）
```

---

## 补充：为什么不是 Cobo 其他方向

- **01 Agent-Native Payments**：需要 x402/HTTP 402 协议——偏离 ERC-8183，另起炉灶
- **03 Agent Resource Procurement**：需要聚合多个服务方 API——MVP 复杂度过高
- **04 Autonomous Trading**：需要 DeFi 策略——用户还没学到 DeFi 深度
- **05 A2A Economy**：多 Agent 协调——单 Agent 场景都还没跑通，跳太远

方向 02 是 Cobo 赛道里唯一有现成标准（ERC-8183）可以锚定、且 AI 角色（Evaluator）和 Web3 角色（Escrow）都有明确边界的方向。
