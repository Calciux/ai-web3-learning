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

本项目落在两个方向的交叉点上，以 Dir2 为主、Dir1 为辅：

```
Dir2（Identity / Reputation / Verification）← 主
    Agent A 凭什么信任 Agent B？
    → Evaluator 验收 = 第三方验证者的具体实现
    → 验收结果上链 = Reputation 原始数据
    → 每个 Agent 的身份 + 历史记录 = Identity Registry 入口

Dir1（Payment / Commerce / Settlement）← 辅
    信任判断做出后，钱怎么安全流动？
    → ERC-8183 Escrow = 资金托管状态机
    → 验收通过 → 结算释放
```

| Week 2 方向 | 在本项目的角色 | 参考 |
|------------|--------------|------|
| **Dir2（主）** | 信任基座：Agent 身份注册、Evaluator 验收作为第三方验证、结果上链留痕 | [模块 A Dir2](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%202%EF%BD%9C%E4%BA%A4%E5%8F%89%E9%A2%86%E5%9F%9F%EF%BD%9C%E6%A8%A1%E5%9D%97A-%E9%97%AE%E9%A2%98%E7%A9%BA%E9%97%B4%E4%B8%8E%E6%96%B9%E5%90%91%E5%9C%B0%E5%9B%BE.md) |
| **Dir1（辅）** | 执行管道：托管合约管理资金状态机，验收通过后结算 | [模块 A Dir1](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%202%EF%BD%9C%E4%BA%A4%E5%8F%89%E9%A2%86%E5%9F%9F%EF%BD%9C%E6%A8%A1%E5%9D%97A-%E9%97%AE%E9%A2%98%E7%A9%BA%E9%97%B4%E4%B8%8E%E6%96%B9%E5%90%91%E5%9C%B0%E5%9B%BE.md) |
| Dir3 | 间接关联——CAW 提供 Agent 的钱包权限边界 | - |
| Applied Path | 无直接关系——本项目不涉及 DeFi 执行 | - |

---

## 问题定义

核心问题是 Dir2 的信任问题：Agent 之间无法互相雇佣——**发包方怕接单方拿钱不干活，接单方怕发包方白嫖不给钱**。

这拆成两个子问题：

1. **信任判断（Dir2 主）**：谁来判断交付物是否合格？判断结果是否可信、可复查？
2. **执行保障（Dir1 辅）**：判断做出后，资金如何安全地从托管中释放？双方都不能单方面动钱。

这不是纯 AI 问题（AI 可以写分析报告但不能提供可信的第三方验证记录），也不是纯 Web3 问题（托管合约可以管钱但不知道交付物是否合格）。必须两条线交汇：Dir2 的验证层做判断，Dir1 的托管层做执行。

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

## 统一判断框架（7 问）——以 Dir2 信任基座为主视角

| # | 问题 | 回答 |
|---|------|------|
| 1 | **没有 AI？** | Dir2 的信任问题仍然存在——人可以手动审核交付物、手动写验收规则。但 AI 提供可规模化的独立验收（LLM Evaluator 代替人工审核），以及自动生成验收 Criteria。没有 AI，第三方验证就是人类瓶颈 |
| 2 | **没有 Web3？** | Dir2 的信任问题无法用传统方式解决——中心化平台可以做评分（GPT Store），但做不到：验收记录不可篡改（Evaluator 判断上链后无法被任何一方删除）、身份无许可注册（任何 Agent 可自主注册而不需平台审核）、可组合验证（调用方可自由选择信任哪个 Evaluator）。Dir1 托管层同理——传统 Escrow 收 0.89%-3.25% 手续费 |
| 3 | **角色分配？** | Agent Owner → 注册 Agent 身份（Dir2 Identity Registry 入口）+ 托管赏金（Dir1 Escrow）。Agent A（发包方）→ 创建任务。Agent B（接单方）→ 接单+交付。LLM Evaluator → Dir2 第三方验证者：检查交付物 → 输出 Accept/Reject + 理由上链。Escrow 合约 → Dir1 执行层：管理资金状态机。失败成本：Evaluator 误判 → A 或 B 损失赏金（最大风险）；A 不付款 → B 不交付（互相制衡） |
| 4 | **自动化 vs 人工？** | 全自动：任务发布、接单、交付、LLM 验收评分、Accept→付款。需人工：争议升级（A 或 B 对验收结果不服 → 人工复查 Evaluator 的判断理由），Agent 身份的首次注册确认 |
| 5 | **如何验证？** | 三层——身份层：Agent A/B 的链上身份可查（Dir2 Identity）。判断层：Evaluator 的验收理由（checklist 逐项评分）公开存储，任何第三方可复查（Dir2 Validation）。执行层：Escrow 所有状态变更 emit 事件，余额可查（Dir1 链上收据）。核心原则：信任判断（Dir2）和执行结果（Dir1）都留痕，不可篡改 |
| 6 | **落地层？** | Dir2 协议层——Agent 身份注册 + 验收结果上链（为未来 ERC-8004 Registry 留入口）。Dir1 协议层——ERC-8183 Escrow 状态机。应用层——Agent A/B 交互 + Evaluator 验收逻辑 + Demo UI |
| 7 | **失败原因？** | Dir2 最大风险：LLM Evaluator 验收标准不稳定（同一交付物两次判断不一致）。缓解：用具体 checklist（5 个 yes/no 问题），得分≥4 才通过；验收理由公开可复查。Dir2 次要风险：Evaluator 是单点信任（MVP 只有一个 Evaluator，未来需多 Evaluator 仲裁）。Dir1 次要风险：争议时钱卡在合约里需要人工介入 |

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
