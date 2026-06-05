# Week 3 — Scope Review：Week 4 不做什么

> 作者：Calciux + Hermes Agent | 日期：2026-06-05
> 课程：AI × Web3 School Bootcamp Week 3
> 关联：Hackathon Cobo 02 — Trustless Agent Work Agreements

---

## 一、MVP 范围回顾

Week 4 只做一条 Happy Path：

```
createJob → setBudget → fund → submit → complete → 付款
```

| 层 | 交付物 | 状态 |
|----|--------|:---:|
| 合约 | ERC-8183 Escrow 最小合约（Solidity），Sepolia 部署 | 未开始 |
| 钱包 | CAW（Cobo Agentic Wallet）集成 | 未开始 |
| Agent 脚本 | Client Agent（发包+fund）、Provider Agent（接单+submit） | 未开始 |
| Evaluator | LLM Evaluator（checklist 评分 → Accept/Reject） | 未开始 |
| Demo | CLI 跑通全流程 + Etherscan tx hash 验证 | 未开始 |

---

## 二、砍掉 / 延后 / Mock 清单

### ✂️ 砍掉（Week 4 不做，也不在 Demo 中出现）

| # | 功能 | 理由 | 替代方案 |
|---|------|------|---------|
| 1 | **ERC-8004 声誉注册表** | 声誉是 commerce 闭环的下一步，但 MVP 只需要证明「托管→验收→付款」能跑通。8004 是独立合约，开发+集成至少额外半天 | Week 4 完全不碰。Demo 结尾口头提及「未来可接入 ERC-8004 写声誉」 |
| 2 | **Web UI / 前端界面** | CLI + Etherscan 已足够展示全流程状态流转。前端开发（React/Next.js + 合约交互）至少 1-2 天，挤占合约+Agent 核心开发时间 | Demo 全程命令行，Etherscan 截图做验证证据 |

### ⏸️ 延后（Week 4 不做，Demo 后可继续）

| # | 功能 | 理由 | 替代方案 |
|---|------|------|---------|
| 3 | **Hook 系统（FundTransferHook / BiddingHook）** | Proposal 中的场景 A（Agent 代客 Swap）和场景 B（竞价接单）都依赖 Hook，但 Hook 是 ERC-8183 的扩展点而非核心状态机。核心状态机跑通后再加 Hook | Week 4 合约不含任何 Hook。Demo 场景用最简单的「Provider 交付文本报告、Evaluator 对照 checklist 验收」 |

### 🎭 Mock（Week 4 做假的替代，保持 Demo 完整）

| # | 功能 | 理由 | 替代方案 |
|---|------|------|---------|
| 5 | **多 Provider 竞价/选择** | 真正的链上竞价需要签名验证+BiddingHook，超出 MVP 范围。但 Demo 需要展示「Client 发包 → Provider 接单」的完整叙事 | 脚本中硬编码一个 Provider 地址。Client Agent 直接 `setProvider(硬编码地址)`。Demo 解释时诚实说明「当前为单 Provider 演示」 |
| 6 | **多 Evaluator 仲裁** | ERC-8183 本身不支持多仲裁，标准层面是单 Evaluator 终局。多仲裁是上层设计问题，不是 Week 4 该解决的 | 单 Evaluator，checklist 5 项评分，理由公开可复查。Demo 结尾坦诚说明「Evaluator 单点信任是当前已知局限」 |

---

## 三、砍掉后的 Week 4 实际范围

```
合约：ERC-8183 核心状态机（无 Hook）
钱包：EOA 私钥 + CAW 集成
Agent：Client + Provider + Evaluator 三个 Python 脚本
验收：LLM checklist 评分（5 项 ≥4 通过）
Provider：硬编码单地址（无竞价）
Demo：CLI + Etherscan tx hash
```

**不做的事一句话总结**：无 Hook、无前端、无声誉、无竞价、无多仲裁。

---

## 四、反范围膨胀规则

| 规则 | 说明 |
|------|------|
| **新功能必须通过「砍掉测试」** | 任何想在 Week 4 加的功能，先问：删掉它 Happy Path 还能跑通吗？能 → 不加 |
| **Demo 叙事诚实** | Mock 的地方直接说 Mock，延后的地方直接说延后。不假装有、不画饼 |
| **时间预算硬上限** | Week 4 共约 6 个工作日。合约 2 天 + Agent 脚本 2 天 + 联调 Demo 2 天。超出即砍 |
| **「挺好但不必要」= 砍** | 声誉、竞价、Hook 都属于这类——有意义，但不是「跑通 Happy Path」的必要条件 |

---

## 五、如果时间有富裕（仅在所有核心交付完成后）

优先级从高到低：

1. Demo 视频录制 + 剪辑 — 1h
2. README 完善 + Hackathon 提交包整理 — 30min

---

> 核心原则：**Week 4 的目标是「一条 Happy Path 跑通并有链上证据」，不是「功能齐全的产品」。砍掉的都是好东西，但它们不是本周的优先级。**
