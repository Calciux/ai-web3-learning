# ERC-8183: Agentic Commerce — 详解

> Draft，作者 Davide Crapis 等，2026-02-25
> https://eips.ethereum.org/EIPS/eip-8183

---

## ⚠️ "Agentic" 指的不是 AI Agent

ERC-8183 的 "Agentic Commerce" 应理解为 **"自动化商业"**，不是 "AI Agent 商业"。

证据：草案全文从未出现 AI、LLM、大模型等词汇。三个角色（Client / Provider / Evaluator）都不要求 AI——Provider 可以是传统脚本，Evaluator 可以是纯合约。AI Agent 只是 Provider 的一种可能实现方式，不是协议本身的假设。

所以 8183 解决的是"机器之间如何自动完成托管、交货、验收和结算"，这些机器可以是脚本、预言机、AI Agent——合约不关心。**真正的 AI 工作不在合约里，在链下的 Agent 身上。**

## 一句话

一个"存钱 → 干活 → 验收 → 放款"的链上工作托管协议。Client 锁定资金，Provider 提交工作，Evaluator 裁决完成或拒绝。

## 为什么需要它

很多场景只需要一个最小协议：

- Client 锁定资金
- Provider 提交工作
- 一个裁决者（Evaluator）说"做完了" → 触发付款
- 或者 Client 拒绝 / 超时 → 触发退款

不需要复杂的争议仲裁，不需要多层声誉系统。ERC-8183 定义了这层最小合约面，保持小体积和可组合性。

## 核心：6 状态状态机

```
                   ┌──────────┐
                   │   Open   │ ← 创建 Job，可设预算，可拒绝
                   └────┬─────┘
                        │ fund() ← Client 存入托管
                   ┌────▼─────┐
                   │  Funded  │ ← 资金已锁定，Provider 可以干活
                   └────┬─────┘
                        │ submit() ← Provider 交付工作
                   ┌────▼──────┐
                   │ Submitted │ ← 已提交，等待裁决
                   └────┬──────┘
                        │ complete() ← Evaluator 说"完成"
                   ┌────▼─────────┐
                   │  Completed   │ ✅ 资金释放给 Provider
                   └──────────────┘
```

| 状态 | 含义 |
|:----|:-----|
| **Open** | 已创建，可设 budget、可 fund、可 reject |
| **Funded** | 资金已托管。Provider 可 submit；Evaluator 可 reject；超时任何人可 claimRefund |
| **Submitted** | 已提交。**只有 Evaluator** 能 complete 或 reject |
| **Completed** | 终态。托管金释放给 Provider（扣平台费） |
| **Rejected** | 终态。退款给 Client |
| **Expired** | 终态。同 Rejected，退款给 Client |

### 关键设计决策

- **Submitted 后只有 Evaluator 能裁决** — Client 不能单方面 withdraw，保护 Provider 开工后的权益
- **Client = Evaluator 是合法的** — 不需要第三方，覆盖"你自己验收"的场景
- **Expired 保护双方** — 超时后任何人可触发退款，不会永远锁死
- **claimRefund 不可 Hook** — 唯一一个不可被 Hook 拦截的函数，保证退款通路永远存在

## 三种角色

| 角色 | 谁 | 能做什么 | 不能做什么 |
|:----|:---|:---------|:----------|
| **Client** | 雇主 | createJob → setBudget → fund → reject（Open 阶段） | Funded 后不能撤回资金 |
| **Provider** | 接单方 | setBudget（议价）→ submit（交付工作） | 不能调用 complete 或 reject |
| **Evaluator** | 裁决者 | complete（放款）/ reject（退款） | 只能裁决 Submitted 后的 Job |

### 角色设计的精妙之处

- Client 在 Open 阶段可以随时 reject（还没花钱）
- 一旦 Funded，**只有 Evaluator 能 reject** — 防止 Client 赖账
- Provider 只负责交付，**不参与资金裁决** — 避免利益冲突
- Evaluator 可以是**合约** — 比如验证 zkProof 后自动 complete，无需人

## Job Data 结构

```
client:      address      // 雇主
provider:    address      // 接单方（可一开始不设，后补）
evaluator:   address      // 裁决者（必须设）
description: string       // 任务描述
budget:      uint256      // 预算金额
expiredAt:   uint256      // 过期时间戳
status:      enum         // Open/Funded/Submitted/Completed/Rejected/Expired
hook:        address      // 可选 Hook 合约
```

支付使用单一 ERC-20 token（全局或每个 Job 指定）。

## 核心函数调用流程（标注 AI 在哪）

```
createJob(provider?, evaluator, expiredAt, description, hook?)
  ▲ Client = 人                    ← AI 不在这里（人发起需求）

setBudget(jobId, amount)           ← AI 不在这里（价格协商，可协议化）
fund(jobId, expectedBudget)        ← AI 不在这里（资金从人钱包托管）
   ↓
submit(jobId, deliverableHash)     ← AI 作为 Provider 提交工作 🔑
   ↓
complete(jobId, reason?)           ← Evaluator 裁决（可以是人，也可以是合约）
reject(jobId, reason?)             ← 同上
claimRefund(jobId)                 ← 超时自动退款
```

### AI Agent 实际出现的位置

| 阶段 | AI 做什么 | 是否必需 |
|:----|:---------|:--------:|
| **创建 Job 前** | AI 解析人意图 → 决定要雇什么服务、预算是多少 | ✅ 有 AI 才有"智能" |
| **链下竞价（BiddingHook）** | 多个 AI Agent 评估任务、签名报价、参与竞价 | ✅ 没有 AI，谁来自动报价？ |
| **跟 Client 谈判** | AI 作为 Provider 跟人讨价还价（调 setBudget 的次数） | ❌ 可选，固定价格也可 |
| **执行任务** | AI 链下干活——读取链上数据、分析、生成报告、执行 swap | ✅ **这是 AI 的核心价值** |
| **submit()** | AI 调用 submit，提交 deliverable hash 指向交付物 | ✅ AI 干的活要交上去 |
| **裁决（Evaluator）** | Evaluator 可以是合约（自动验证 zkProof），也可以是 AI | ❌ 用合约是最可靠的 |

### 所以 8183 本身不涉及 AI

**8183 只是一个"托管 + 裁决"的合约标准。** AI 在不在这张图里，取决于谁扮演这三个角色：

```
       ┌──────────┐
       │  Client  │ ← 人 / 或代表人的 Agent
       └────┬─────┘
            │ fund()
       ┌────▼─────┐
       │  Escrow  │ ← 8183 合约（纯合约，无 AI）
       └────┬─────┘
            │ submit()
       ┌────▼───────┐
       │  Provider  │ ← 🔑 **AI Agent** 在这里（干活 + 提交）
       └────┬───────┘
            │ complete()
       ┌───────────┐
       │ Evaluator │ ← 合约（自动验证）/ 人 / AI
       └───────────┘
```

**真正用到 AI Agent 的只有一行：Provider。** AI 做链下的活，交链上的货，收链上的钱。其他角色（Client 创建 Job、Evaluator 裁决）可以不涉及 AI，或者用合约替代。

## Hook 系统（关键扩展点）

Hook 是 ERC-8183 最灵活的设计。每个 Job 可绑定一个 Hook 合约，在核心函数**之前/之后**插入自定义逻辑。

### 接口

```solidity
interface IACPHook {
    function beforeAction(uint256 jobId, bytes4 selector, bytes calldata data) external;
    function afterAction(uint256 jobId, bytes4 selector, bytes calldata data) external;
}
```

### 哪些函数可 Hook

| 函数 | 可 Hook | 说明 |
|:----|:-------|:-----|
| setProvider | ✅ | 可在之前做 KYC 检查 |
| setBudget | ✅ | 验证预算范围 |
| fund | ✅ | 可在之前检查 approve 额度 |
| submit | ✅ | 可在之前 pull 产出 token |
| complete | ✅ | 可在之后写 ERC-8004 声誉 |
| reject | ✅ | 可在之后清理状态 |
| **claimRefund** | ❌ | 故意不可 Hook，保证退款通路 |

### Example 1：FundTransferHook（两阶段托管）

用户说"帮我用 USDC 换 DAI"——需要先把 USDC 给 Agent，Agent 执行后再把 DAI 返回。

```
1. createJob → hook = FundTransferHook
2. setBudget(jobId, serviceFee, optParams={buyer, transferAmount})
    → hook 存储 {buyer, transferAmount}
3. fund(jobId, ...)
    → hook.before: 检查 Client 已 approve hook 的 transferAmount
    → core: pull serviceFee 进 escrow
    → hook.after: pull transferAmount 从 Client 转给 Provider（本金）
4. Provider 用本金 swap 成 DAI ← 链下执行
5. submit(jobId, deliverable)
    → hook.before: pull transferAmount（等值的 DAI）从 Provider 转入 Hook
    → core: 状态置为 Submitted
6. complete(jobId)
    → core: 释放 serviceFee 给 Provider
    → hook.after: 释放 DAI 给 Buyer
∟ 失败时：reject 原路退回，claimRefund 退回 serviceFee
```

**这个例子里，Client 就是"你"，Provider 就是"Agent 替你去执行 swap"，Evaluator 可以是合约自动验证 swap 结果。** 跟你之前说的"让 AI 选 router 干活"完全对应。

### Example 2：BiddingHook（竞价）

想找最便宜的 Agent 但不提前知道谁接单。

```
1. createJob(provider=0, evaluator, ..., hook=BiddingHook)
2. setBudget → hook 存储 biddingDeadline
3. 链下竞价：Providers 签名 bid(price)
4. Client 收集 bid，选最优
5. setProvider(jobId, winner, optParams={bidAmount, signature})
    → hook.before: 恢复签名者，验证 == provider，校验价格
6. setBudget(jobId, bidAmount)
    → hook.before: 强制 budget == 竞标价（不能改）
7. 后续正常 fund → submit → complete
```

## ERC-8004 集成

草案标准推荐在 Hook 中集成 ERC-8004：

- **complete** → `afterAction` 在 ERC-8004 写入 positive reputation
- **reject** → 写入 negative/neutral signal
- Hook 也可以在 `beforeAction` 中**查询 ERC-8004 声誉**来决定是否允许某操作（比如不允许声誉低于阈值的 Provider 接单）

## 费用模型

- 平台费：按 basis points（bps）从 Completed 中扣除，归 treasury
- Evaluator 费：同样 bps，归 evaluator
- totalFee ≤ 10000（100%）
- 仅 Completed 时扣费，Rejected/Expired 不扣

## Security Considerations

- **Evaluator 是单点信任** — Submitted 后它可任意决定。高价值场景需搭配 ERC-8004 声誉或 staking
- **一旦 Funded，Client 不可 withdraw** — 保护 Provider，但也意味着 Client 必须信任 evaluator
- **无争议仲裁** — reject/expire 即终局
- **Hook 是安全的柔点** — claimRefund 不可 Hook，确保不被恶意 Hook 锁死资金

## 与你已有 Workflow 的映射

```
你的 Workflow                ERC-8183
──────────────────────────────────────
你（人）说"帮我换"        → Client createJob
AI 读余额/报价             → 链下（未被标准化）
AI 生成交易草稿            → setBudget + fund
你人工确认审核             → Evaluator = 你，complete()
AI 构建并签名交易          → 合约自动释放资金
AI 验证链上结果            → 链上收据 + ERC-8004 event
```

ERC-8183 把你的"AI 辅助人的 Workflow"升维成了"**人雇 AI 干活的标准合约**"——这是从工具到商业的本质跳跃。
