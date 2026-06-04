# Proposal Memo — Trustless Agent Work Agreements

> Cobo 02 · Agentic Commerce · Calciux · 2026-06-04
> 完整 Proposal：[Hackathon Proposal](./Hackathon%20Proposal%20%E2%80%94%20Cobo%2002%20%E2%80%94%20Trustless%20Agent%20Work%20Agreements.md)

---

## 赛道

Cobo · Agentic Commerce · **02 Trustless Agent Work Agreements**

基于 ERC-8183 实现 Agent 间去信任工作协议：Client Agent 发布任务托管资金 → Provider Agent 交付 → Evaluator 验收 → 通过付款，不通过退款。

---

## 目标用户

- **Client 侧**：想让自己的 Agent 自主外包分析/执行任务的开发者
- **Provider 侧**：想让自己的 Agent 接单干活、通过链上托管收报酬的开发者

---

## 真实场景
为Agentic Commerce提供基础设施:互不信任的Agent之间如何进行任务交付-验证-结算的流程.
例如Web3中, 当有人想做Swap, 它可以用自己的agent发布job, 那么网络上也可以有很多AI agent service provider, 这两个agent之间就可以直接交互完成任务.但进行swap是一个涉及到真实资金的问题, 在这个时候就需要充分利用链上的trustless特性,以此确保资金的安全, 也需要确保接单的service provider正确完成了任务.

即使在Web2场景中, 这个agreement也有应用场景.在Agent Commerce中, Google提出了UCP(Universal Commerce Protocol), 在整个购物流程中互操作, 完成在电商中发现商品, 协商, 支付, 下单的流程.但是这中间就会产生信任问题: 我的钱已经交出去了,如何确保资金安全?如何确保服务Provider提供的产品质量?如何防止抵赖/欺骗行为? 那这就是Trustless agnet work agreements的应用场景: 通过Web3本来的trustless属性来解决这个问题.




---

## 最小功能（MVP）

一条 Happy Path：`createJob → setBudget → fund → submit → complete → 付款`

---

## 验证方式

| 验证什么 | 怎么验证 |
|---------|---------|
| 资金托管 | Etherscan 查 Escrow 余额 + Funded 事件 |
| 交付质量 | Evaluator checklist 评分（5 项 ≥4 通过），理由公开可复查 |
| 流程可追溯 | 链上事件日志（JobCreated→Funded→Submitted→Completed） |

---

## 风险边界

| 风险 | 级别 | 说明 |
|------|:---:|------|
| Evaluator 误判 | 🔴 高 | LLM 输出不稳定，checklist + 理由公开缓解 |
| Evaluator 单点信任 | 🟡 中 | MVP 一个 Evaluator，未来多仲裁 |
| L1 gas 太高 | 🟡 中 | 测试网 + 极小金额 |
| 合约漏洞 | 🟡 中 | Remix 部署，Sepolia 测试 |
