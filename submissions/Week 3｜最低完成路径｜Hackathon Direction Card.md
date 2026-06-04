# Week 3 — Hackathon Direction Card

> 赛道确认 · 项目概要 · 最低完成路径
> 作者：Calciux | 日期：2026-06-04

---

## 参赛赛道

**Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements**

---

## 项目名

**Trustless Agent Work Agreements**

---

## 目标用户

- **Client 侧**：想让自己的 Agent 自主外包分析/执行任务的开发者
- **Provider 侧**：想让自己的 Agent 接单干活、通过链上托管收报酬的开发者

---

## 要解决的问题

Agent 之间互不信任，无法直接雇佣.**互不信任的 Agent 之间，如何安全地完成一次「你干活、我付钱、第三方验收」的经济活动？**

---

## 最小功能（MVP）

一条 Happy Path：

```
createJob → setBudget → fund → submit → complete → 付款
```

链上：ERC-8183 Escrow 合约（Solidity），部署 Sepolia 测试网。

链下：Client Agent 发包 + fund、Provider Agent 接单 + submit、LLM Evaluator 对照 checklist 验收。


---

## 技术路径

| 层 | 内容 |
|----|------|
| 协议标准 | ERC-8183 Agentic Commerce — 6 状态 Escrow 状态机 |
| 智能合约 | Solidity，Remix/Hardhat 部署到 Sepolia |
| 钱包 | Cobo Agentic Wallet（Pact 任务级预算授权） |
| 验收 | LLM Evaluator（GLM-5.1/DeepSeek API）→ checklist 评分 → Accept/Reject |
| Agent 逻辑 | Python 脚本（Client/Provider/Evaluator 各一个） |
| Demo | 命令行 + Etherscan 验证，展示全流程状态流转 |


---

## 主要风险

| 风险 | 级别 | 缓解 |
|------|:---:|------|
| Evaluator 误判 | 🔴 高 | checklist 逐项评分（≥4/5），理由公开可复查 |
| Evaluator 单点信任 | 🟡 中 | MVP 单 Evaluator，未来多仲裁 |
| L1 gas 太高 | 🟡 中 | Sepolia 测试网，极小金额（0.001 ETH） |
| 合约漏洞 | 🟡 中 | Remix 先行验证，测试网多轮手动测试 |
