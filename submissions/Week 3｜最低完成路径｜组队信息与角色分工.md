# Week 3 — 组队信息与角色分工

> 作者：Calciux | 日期：2026-06-07
> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements
> 形式：Solo

---

## 队员

| 姓名/ID | 角色 |
|----------|------|
| Calciux | PM + Engineering + Design + Docs（全栈 solo） |

---

## 角色分工

| 角色 | 负责人 | 具体职责 |
|------|:------:|----------|
| **PM / Research** | Calciux | 定义问题、整理 Sponsor 需求、维护 proposal 和 scope、风险分析 |
| **Engineering** | Calciux | Solidity 合约开发（ERC-8183）、Foundry 测试 + 部署、CAW CLI 集成、Python Agent 脚本、hackrepo 维护 |
| **Design / Demo** | Calciux | 用户流程设计、Demo story、CLI 录屏、Etherscan 证据截图 |
| **Docs / Ops** | Calciux | README、接口规范文档、验证材料、提交包、路演材料 |

---

## 各模块负责人

| 模块 | 内容 | 负责人 |
|------|------|:------:|
| ERC-8183 Escrow 合约 | Solidity 合约 + Foundry 测试 + Sepolia 部署 | Calciux |
| MockERC20 测试代币 | Sepolia 测试 ERC-20 | Calciux |
| CAW 钱包集成 | Pact 构造 + CLI 调用 + App 审批 | Calciux |
| Client Agent 脚本 | Python：创建 Job → setBudget → approve → fund | Calciux |
| Provider Agent 脚本 | Python：接单 → 执行任务 → submit | Calciux |
| Evaluator Agent 脚本 | Python：checklist 评分 → complete/reject | Calciux |
| Demo 录制 | CLI 全流程录屏 + Etherscan tx hash 截图 | Calciux |
| 文档 | README + 接口规范 + 提交包 | Calciux |

---

## 沟通方式

- **自我管理**：Hermes Agent 辅助审查 + VS Code Source Control diff 审视
- **Spnsor / Mentor**：通过 Hackathon 渠道提交问题，异步沟通
- **紧急决策**：优先跑通 Happy Path，砍功能用 Scope Review 已列清单

---

## Week 4 可投入时间

| 时段 | 可投入 |
|------|:------:|
| 工作日 | 晚上 3-4h |
| 周末 | 全天 8-10h |
| **Week 4 总计估算** | ~30-35h |

---

## Solo 风险与应对

| 风险 | 应对 |
|------|------|
| 一个人兼所有角色，无 code review | Hermes Agent 做 second pair of eyes；Foundry 测试做自动化验证 |
| 某个模块卡住没人接手 | Sprint Plan 按 Go/No-Go 拆分：合约不通不进 CAW，CAW 不通不进 Agent |
| 时间不够 | Tier 降级策略已写在 Sprint Plan（Tier 4 底线：合约部署 + Etherscan 验证） |
