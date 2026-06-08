# Week 4 Sprint Plan

> Hackathon 开发冲刺 · 任务清单 · 真实实现 vs Mock/Fallback
> 作者：Calciux | 更新：2026-06-07
> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements
> 工具链：Foundry（forge/cast/anvil）+ CAW CLI + Python

---

## 总览：Week 4 目标

一条 Happy Path 链上跑通：`createJob → setBudget → fund → submit → complete → 付款`

**Tier 策略**：

| Tier | 内容 | 触发条件 |
|:----:|------|----------|
| **Tier 1（靶心）** | 合约 + CAW + 3 Agent 脚本全自动 | 默认目标 |
| Tier 2（缩减） | 合约 + CAW + 减少 Agent / 简化 Pact | CAW 集成卡住超 4h |
| Tier 3（保底） | 合约 + CAW + cast 手动交互 | Agent 脚本问题 |
| Tier 4（底线） | 合约部署 + cast 手动调 + Etherscan 验证 | 只要合约在 Sepolia 上状态流转正确 |

---

## 模块 A：智能合约 — ERC-8183 Escrow

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| A1 | ~~Hardhat 环境搭建~~ | — | **已取消**，已切换为 Foundry ✅ |
| A2 | Foundry 环境就绪 + forge build 通过 | ✅ 真实 | `forge build` 编译 interfaces，零 error ✅ |
| A3 | ERC-8183 合约实现 | ✅ 真实 | `contracts/ERC8183Escrow.sol`：状态机 + 权限检查 + ERC-20 转账 |
| A4 | MockERC20 测试代币 | 🎭 Mock | `test/mocks/MockERC20.sol`：mint + approve 测试用 |
| A5 | Foundry 测试 | ✅ 真实 | `test/ERC8183Escrow.t.sol`：Happy Path + 异常路径 |
| A6 | Sepolia 部署 | ✅ 真实 | `forge script` 或 `forge create` → 合约地址 + tx hash |

### 验证 Checklist

- [ ] `createJob` → 状态 Open，emit JobCreated
- [ ] `setBudget` → budget 存储，emit BudgetSet
- [ ] `fund` → ERC-20 transferFrom 进合约，状态 Funded，emit Funded
- [ ] `submit` → 状态 Submitted，emit Submitted
- [ ] `complete` → ERC-20 transfer 给 Provider，状态 Completed，emit Completed
- [ ] `reject`（Open 时 Client 调）→ 状态 Rejected，emit Rejected
- [ ] `reject`（Funded/Submitted 时 Evaluator 调）→ 退款给 Client
- [ ] `claimRefund` → 过期后任何人调，退款给 Client，emit Expired
- [ ] ⚠️ Funded 后 Client 不能调 reject（应 revert）
- [ ] ⚠️ 非 Evaluator 不能调 complete / reject（Submitted 时）
- [ ] ⚠️ claimRefund 不被任何 modifier 拦截

### Go/No-Go

合约必须 Sepolia 部署 + 6 状态 + 3 条安全约束全部通过 `forge test`。做不到 → 不进其他模块。

---

## 模块 B：CAW 钱包集成

> Cobo 赛道硬要求：Agent 须通过 CAW 持有和管理资金。

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| B1 | CAW 环境确认 | ✅ 真实 | caw CLI 可用 + MPC 钱包已 active + Sepolia 余额 |
| B2 | Pact 模板构造 | ✅ 真实 | policies（合约白名单 + 函数选择器 + 金额上限）+ completion_conditions |
| B3 | Pact 提交 + App 审批 | ✅ 真实 | `caw pact submit` → App 弹窗 → 人点批准 |
| B4 | caw tx call 调 fund() | ✅ 真实 | Pact 激活后通过 CAW 调 ERC-8183.fund() |
| B5 | tx hash 验证 | ✅ 真实 | `caw tx get` → tx hash → Sepolia Etherscan |

### 验证 Checklist

- [ ] Pact 提交成功后 App 收到审批通知
- [ ] Pact 的 policies 白名单限制生效（调未授权合约被拒绝）
- [ ] caw tx call fund() → 返回 tx hash → Etherscan 查到 confirmed
- [ ] CAW 钱包余额变化可验证

### Fallback

如果 CAW API 中断或 TSS 超时：
- **Fallback A**：用 cast send（EOA 私钥）替代 caw tx call，Pact 流程以截图/日志展示
- **Fallback B**：全程 cast send + web3.py，CAW 作为架构图组件出现在 README

---

## 模块 C：Agent 脚本

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| C1 | Client Agent | ✅ 真实 | Python：createJob → setBudget → approve → fund（通过 CAW 或 cast） |
| C2 | Provider Agent | ✅ 真实 | Python：读 Job → 链下执行任务 → submit |
| C3 | Evaluator Agent | ✅ 真实 | Python：获取 deliverable → checklist 评分 → complete/reject |
| C4 | 3 Agent 串联 | ✅ 真实 | 一键脚本或分步执行，展示全流程自动化 |

### 验证 Checklist

- [ ] Client Agent 成功 fund，Etherscan 上看到 Funded 事件
- [ ] Provider Agent 成功 submit，deliverable hash 可验证
- [ ] Evaluator checklist 评分有明确通过/不通过理由
- [ ] Evaluator complete() 后 Provider 钱包余额增加
- [ ] Evaluator reject() 后 Client 收到退款

### Mock 说明

| 项 | 做法 |
|----|------|
| Provider 任务 | 脚本硬编码一个简单任务（如「生成 Sepolia 最近 5 笔 tx 摘要」） |
| Evaluator 评分 | 用 checklist 5 项 yes/no，≥4 为 Accept |
| 多 Provider 竞价 | 硬编码 1 个 Provider，Demo 时诚实说明 |

---

## 模块 D：Demo 与提交包

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| D1 | CLI 录屏 | ✅ 真实 | 分步展示全流程，每步标 tx hash |
| D2 | Etherscan 截图 | ✅ 真实 | 6 个事件在 Sepolia 链上全部可见 |
| D3 | README 完善 | ✅ 真实 | 架构图 + 部署地址 + 运行步骤 + 局限声明 |
| D4 | 提交包整理 | ✅ 真实 | repo + 录屏 + 截图 + proposal 汇总 |

### 验证 Checklist

- [ ] Demo 能从头到尾跑通一遍不回滚
- [ ] 每个步骤有对应的 tx hash 或 Etherscan 截图
- [ ] README 包含「如何复现」的完整步骤
- [ ] 结尾坦诚说明已知局限（Evaluator 单点信任、单 Provider）

---

## 依赖关系

```
模块 A（合约）
    ↓
模块 B（CAW 集成）← 依赖合约地址
    ↓
模块 C（Agent 脚本）← 依赖 CAW Pact + 合约地址
    ↓
模块 D（Demo + 提交包）
```

**Go/No-Go 链**：A 不通过 → 停。B 不通过 → Fallback。C 不通过 → Tier 降级。
