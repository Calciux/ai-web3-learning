# Week 3 — Sponsor / Mentor 问题清单

> 作者：Calciux | 日期：2026-06-05
> 用途：Week 3 推荐任务 — 向 sponsor、mentor 或助教请教的实现向问题
> 项目：Cobo 02 · Trustless Agent Work Agreements · ERC-8183 Escrow

---

## 问题 1：ERC-8183 Hook 机制 — MVP 阶段要不要实现？

**背景**：ERC-8183 定义了 `IHook` 接口，允许在状态转移前后插入自定义逻辑（如白名单检查、费率计算）。标准明确写 `claimRefund` 不可被 Hook 拦截——这是安全底线。但标准没有强制要求实现 Hook。

**具体问题**：
- MVP 阶段（一条 Happy Path）是否应该在合约中实现 Hook 接口，还是留空函数体、后续再补？
- 从评委/赛道方视角看：一个干净的「无 Hook、只走核心状态机」的合约，和一个「预留了 Hook 但 Hook 里只做日志」的合约，哪个更被接受？
- 你们见过的 ERC-8183 参考实现里，Hook 层的复杂度和合约主体代码的比例大概是多少？

---

## 问题 2：LLM Evaluator 的验收可靠性 — 有什么实战验证过的模式？

**背景**：Evaluator 用 LLM 对照 checklist 打分（≥4/5 → Accept）。但 LLM 对同一交付物两次判断可能不同——这是概率模型的根本局限，不是调 prompt 能彻底消除的。目前计划是「checklist 逐项评分 + 理由公开存储」，但还没落地验证。

**具体问题**：
- 有没有在 Hackathon 或生产项目里实际跑过 LLM-as-Evaluator 的案例？他们怎么处理「同一个交付物两次打分不一致」的问题？
- 除了 checklist + 阈值，有没有其他低成本提升一致性的手段？（比如多次采样取多数票？retry 时换模型？）
- 对于 Hackathon Demo 场景，评委一般接受「LLM 验收是概率性的」这个前提吗？还是期望在 Demo 里看到某种确定性保障？

---

## 问题 3：CAW 集成的最佳实践 — 新手最容易踩的坑有哪些？

**背景**：赛道要求集成 Cobo Agentic Wallet（CAW），当前合约和 Agent 脚本都还没写。CAW 的 Pact 机制和 Policy Engine 是必选项——接入意味着要理解 CAW API、Pact 创建和审批流程、MPC 签名流程。

**具体问题**：
- 从零开始集成 CAW，有没有推荐的上手顺序？Pact 创建 → Policy Engine → MPC 签名的步骤中，哪一步最容易出问题？
- CAW 的 Pact 审批需要 Owner 手机 App 确认——Demo 时这个步骤怎么展示？有没有 mock 模式或者自动化审批的方式？
- 你们内部评估一下：30 分钟（缺口诊断里对 CAW 文档阅读的预估）够真正读懂 CAW 文档并判断接入工作量吗？还是我低估了？

---

## 备注

- 以上问题都是**真实阻塞点**，不是在凑数。项目当前状态：合约零代码，Agent 零代码，CAW 零接触。这些问题的答案直接影响 Week 4 怎么排时间。
- 如果 mentor 时间有限，优先回答**问题 3**（CAW 集成实战）——它决定了 Week 4 怎么最高效地推进 CAW 接入。
