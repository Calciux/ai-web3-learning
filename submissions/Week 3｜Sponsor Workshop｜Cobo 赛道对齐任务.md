# Week 3 — Cobo 赛道对齐

> Sponsor Workshop 任务：Cobo 赛道对齐
> 作者：Calciux | 日期：2026-06-04
> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements

---

## AI Agent 如何持有钱包

每个 Agent 通过 Cobo Agentic Wallet（CAW）持有一个 MPC 钱包。私钥分片存储，不完整出现在任何单一设备上——签名需要多方协作，单点被攻破不影响资产安全。

```
Client Agent ── CAW 钱包 A ── 发包、fund、托管赏金
Provider Agent ── CAW 钱包 B ── 接单、接收报酬
```

Agent 不接触私钥，不能绕过 CAW 直接签名。所有链上操作走 CAW API。

---

## 如何管理预算

两级预算控制：

| 级别 | 谁设定 | 内容 |
|------|--------|------|
| **Pact（任务级）** | Client Agent 提交，Owner 审批 | 单次任务的目标、预算上限、可调用合约、时间窗口、失败处理策略 |
| **Policy Engine（基础设施级）** | Owner 在 CAW 后台配置 | 全局规则：per-transaction 上限、rolling window 限额、白名单地址 |

Pact 的关键约束——Agent 只能在 Pact 定义的边界内操作：

- 任务结束或预算用完 → Pact 自动终止
- 超出 Pact 范围的操作 → Policy Engine 在基础设施层拒绝，不到链上
- Owner 随时可撤回 Pact——链上操作立即停止

---

## 如何执行支付 / 交易

本项目的支付路径：

```
① Client Agent 提交 Pact（任务意图 + 预算 + 时间窗口 + 操作范围）
   → Owner 审批（手机 App 确认或自动通过）
   → Pact 进入 ACTIVE 状态

② Client Agent 调 CAW API 执行 fund()
   → Policy Engine 检查：这笔金额在 Pact 预算内吗？目标合约在白名单里吗？
   → 通过 → CAW 签名 → 链上 ERC-8183 合约.fund() → 资金进入 Escrow

③ Evaluator complete() → 合约释放资金给 Provider
   → CAW 审计日志记录：谁发起、谁收款、金额、交易哈希、时间戳
```

交易不在 Agent 本地签名——CAW 在服务端做 MPC 签名，同时 Policy Engine 做确定性拦截。Agent 只生成候选操作，基础设施强制执行边界。

---

## 如何记录风险边界

三层记录：

| 层 | 记录什么 | 记录在哪 |
|----|---------|---------|
| **授权层** | Pact 的边界设定（金额/合约/时间窗/操作类型）——出事后可查「当时谁批了什么」 | CAW 审计日志 |
| **执行层** | 每笔链上操作（fund/submit/complete/reject）——交易哈希、调用者、参数、状态变更 | 链上事件日志 + Etherscan |
| **验收层** | Evaluator 的 checklist 评分 + Accept/Reject 理由——出事后可查「为什么判过/不过」 | 链下公开存储（可被复查） |

本项目的已知风险边界：

| 风险 | CAW 管得了吗 | 说明 |
|------|:---:|------|
| Agent 超预算花钱 | ✅ | Pact 预算上限 + Policy Engine 拦截 |
| Agent 调未授权合约 | ✅ | Pact 白名单 + Policy Engine |
| Evaluator 误判 | ❌ | 概率模型根本局限，需 checklist + 理由公开缓解 |
| Evaluator 偏袒某一方 | ❌ | 单点信任风险，未来多仲裁 + ERC-8004 |

CAW 管**执行边界**——钱花多少、花在哪、花多久。不管**判断质量**——交付物好不好、Evaluator 判得对不对。后者是协议层的风险，不是钱包层能解决的。

---

## 与 ERC-8183 的分工

```
CAW：钱包 + 权限 + 审计           ERC-8183：托管 + 交付 + 结算

「能不能花这笔钱」                 「钱花了之后怎么锁、怎么放」
 Pact 边界                        Escrow 状态机
 Policy Engine                    6 状态转移
 Audit Log                        Evaluator 裁决
 MPC 安全签名                     链上收据不可篡改
```

CAW 管事前（能不能花），ERC-8183 管事中和事后（钱怎么锁、交付怎么验、结算怎么执行）。两者组合才构成完整的 Agentic Commerce 链路。
