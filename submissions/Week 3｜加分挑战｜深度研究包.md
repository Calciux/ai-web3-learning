# 深度研究包 — 阅读摘要 Skeleton

主方向：Trustless Agent Work Agreements（ERC-8183 + CAW）


## 1. ERC-8183 — Agentic Commerce Escrow ✅ 已研究清楚

> 详细笔记：[notes/ai×web3/ERC-8183-Agentic-Commerce详解.md](../notes/ai%C3%97web3/ERC-8183-Agentic-Commerce%E8%AF%A6%E8%A7%A3.md)
> Draft 原文：https://eips.ethereum.org/EIPS/eip-8183

### 解决什么问题

一个「存钱 → 干活 → 验收 → 放款」的链上工作托管协议。Client 锁定资金进 Escrow，Provider 提交工作，Evaluator 裁决完成或拒绝。

三个角色各司其职：

| 角色 | 能力 | 不能 |
|------|------|------|
| Client（雇主） | createJob / fund | Funded 后不能撤资 |
| Provider（接单方） | submit 交付物 | 不能裁决放款 |
| Evaluator（裁决者） | complete / reject | 只能裁决 Submitted 后的 Job |

6 状态状态机：Open → Funded → Submitted → Completed（放款）/ Rejected（退款）/ Expired（退款）

核心设计：Submitted 后只有 Evaluator 能裁决，Client 不能单方面 withdraw，保护 Provider 开工后的权益。claimRefund 是唯一不可 Hook 的函数，保证退款通路永远存在。

### 边界是什么

**协议本身的边界**：

- 「Agentic」不是指 AI Agent。草案全文未出现 AI 字样，三个角色都不要求 AI。8183 解决的是机器间自动化托管结算，Provider 可以是脚本、预言机或 AI Agent——合约不关心
- AI 真正出现的位置只有 **Provider** 这个角色：链下干活、链上提交、收钱
- **Evaluator 是单点信任**：Submitted 后它可以任意决定 complete 或 reject，协议本身无争议仲裁机制
- **无声誉系统内置**：推荐通过 Hook 集成 ERC-8004 实现，但非强制
- 费用模型：Completed 时扣除平台费 + Evaluator 费（bps），Rejected/Expired 不扣

**Hook 扩展边界**：

- 每个 Job 可绑定一个 Hook 合约，在核心函数前后插入自定义逻辑
- 典型 Hook：FundTransferHook（两阶段托管，Agent 代执行 swap）、BiddingHook（多 Agent 竞价）
- claimRefund 故意不可 Hook，保证退款通路不被恶意锁死

### 还缺什么

1. **Evaluator 去信任化**：目前 Evaluator 是单点，高价值场景需要多签 Evaluator 或 zkProof 自动验证，但协议未标准化这部分
2. **跨链**：8183 假设单链 ERC-20 支付，不支持跨链 Job（Client 在 Sepolia fund、Provider 在 Base 收钱）
3. **争议升级机制**：只有 complete/reject 二元裁决，无中间态（如「部分完成付 50%」）
4. **与 CAW 的集成标准化**：8183 只管合约层托管结算，不管 Agent 怎么获得钱包权限——这恰好是 CAW 的职责，但两者没有联合规范
5. **链下交付物验证**：deliverableHash 只是哈希指针，链上不验证交付物内容。Provider 可能提交垃圾哈希，Evaluator 需要独立获取和验证链下数据

> 以上局限在我们的项目中已部分处理：Evaluator 单点信任通过 checklist 公开评分 + 低金额测试（0.001 ETH）+ 人可事后介入来缓解；CAW 弥补了 Agent 钱包权限控制的缺口。


## 2. Cobo Agentic Wallet (CAW)

- 解决什么问题：
- 边界是什么：
- 还缺什么：


## 3. ERC-7683 — Cross-Chain Intents

- 解决什么问题：
- 边界是什么：
- 还缺什么：
