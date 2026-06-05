# Week 4 Sprint Plan

> Hackathon 开发冲刺 · 按模块列出检查清单 · 真实实现 vs Mock/Fallback
> 作者：Calciux | 日期：2026-06-05
> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements

---

## 总览：Week 4 目标

一条 Happy Path 链上跑通，在 CAW 钱包中完成全流程：`createJob → setBudget → fund → submit → complete → 付款`

**Tier 策略**：
- **Tier 1（靶心）**：合约 + CAW + 3 Agent 脚本全自动 — 本周目标
- Tier 2（降级）：合约 + EOA + 3 Agent 脚本 — 如果 CAW 集成卡死超过 4 小时
- Tier 3（保底）：合约 + Remix 手动交互
- Tier 4（底线）：合约部署 + Etherscan 验证

---

## 模块 A：智能合约 — ERC-8183 Escrow

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| A1 | Hardhat 环境搭建（hackrepo） | ✅ 真实 | `npx hardhat init`，安装依赖 |
| A2 | ERC-8183 合约骨架 | ✅ 真实 | `contracts/TrustlessWorkAgreement.sol`：状态枚举 + 结构体 + 事件 |
| A3 | 核心函数编码 | ✅ 真实 | `createJob` / `setBudget` / `fund` / `submit` / `complete` / `reject` / `claimRefund` / `expire` |
| A4 | Remix VM 冒烟测试 | ✅ 真实 | 手动走通所有 8 个转移路径 |
| A5 | Sepolia 部署 | ✅ 真实 | Hardhat 部署脚本 → 合约地址 + tx hash |

### 验证 Checklist

- [ ] `createJob` → 状态 Open
- [ ] `setBudget` → budget 存储
- [ ] `fund` → 转账进合约，状态 Funded
- [ ] `submit` → 状态 Submitted
- [ ] `complete` → 转账给 Provider，状态 Completed
- [ ] `reject` → 退款给 Client，状态 Rejected
- [ ] `claimRefund` → 超时退款
- [ ] ⚠️ Funded 后 Client 不能 withdraw
- [ ] ⚠️ 非 Evaluator 不能调 complete/reject
- [ ] ⚠️ claimRefund 不被任何 modifier 拦截

### Go/No-Go

合约必须 Sepolia 部署 + 6 状态全部走通。做不到 → 不进其他模块，继续修合约。

---

## 模块 B：CAW 钱包集成 — Agent 资金账户

> Cobo 赛道硬要求：Agent 必须通过 CAW 持有和管理资金。

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| B1 | Cobo 账号注册 + API Key 创建 | ✅ 真实 | 开发者身份注册，生成 API Key |
| B2 | 创建两个 CAW MPC 钱包 | ✅ 真实 | Client Agent 钱包 + Provider Agent 钱包，记录 wallet ID |
| B3 | 阅读 CAW 关键文档 | ✅ 真实 | 5-min Quickstart / Pact 提交 / 转账 / 合约调用 / Audit Log |
| B4 | 分离 Agent 钱包与合约调用者 | ✅ 真实 | CAW 钱包存资金 → Agent 脚本调 CAW API → CAW 签名 → 链上合约执行 |
| B5 | Client CAW 钱包充值 | ✅ 真实 | Sepolia Faucet 或 Cobo 内置水龙头 → 转入测试 ETH |
| B6 | Pact 提交 | ✅ 真实 | 每条 Job 提交一个 Pact：任务意图 + 预算上限 + 合约/时间窗口 |
| B7 | 通过 CAW API 执行 fund() | ✅ 真实 | Agent 脚本 → CAW API → Policy Engine 检查 → MPC 签名 → 链上交易 |
| B8 | 通过 CAW API 执行转账 | ✅ 真实 | Provider 收款 + 结算走 CAW |

### 验证 Checklist

- [ ] Client CAW 钱包有余额（Sepolia ETH）
- [ ] Provider CAW 钱包创建成功
- [ ] Pact 创建 → 状态 ACTIVE
- [ ] CAW API 返回 tx hash → Etherscan 可查
- [ ] Audit Log 记录完整（谁发起、金额、操作类型、状态）
- [ ] 超出 Pact 边界的操作被 Policy Engine 拒绝（验证拦截能力）

### Tier 2 降级条件

**只有 CAW 集成卡死超过 4 小时无进展时才考虑降级。** 降级后 Agent 直接用 EOA 私钥签名调合约，Pact 预算控制改为「合约 require 逻辑 + 硬编码预算上限」模拟。

---

## 模块 C：Agent 脚本 — Client / Provider / Evaluator

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| C1 | 项目结构 | ✅ 真实 | `agents/` 目录，`requirements.txt` |
| C2 | Client Agent 脚本 | ✅ 真实 | 调 CAW API → 提交 Pact → `createJob` → `setBudget` → `fund` |
| C3 | Provider Agent 脚本 | ✅ 真实 | 调 CAW API → `submit` |
| C4 | Provider 地址 | 🎭 Mock | 硬编码单地址 `PROVIDER_WALLET = "0x..."` |
| C5 | 调试脚本 | ✅ 真实 | `check_status.py <jobId>` → 合约状态、余额、事件 |
| C6 | LLM Evaluator 脚本 | ✅ 真实 | 读 job 信息 → 构造 prompt → 调 LLM API → checklist 5 项 → ≥4 `complete`，<4 `reject` |
| C7 | Checklist 设计 | ✅ 真实 | 5 项 yes/no + 理由：完整性 / 匹配度 / 格式 / 逻辑 / 可验证性 |
| C8 | Temperature = 0 | ✅ 真实 | 降低 LLM 随机性 |
| C9 | Demo 交付物 | 🎭 Mock | 预选明显合格的文本，确保 Demo 不被误判打断 |
| C10 | 端到端联调 | ✅ 真实 | `demo.py` 全流程：Client → Provider → Evaluator，Etherscan 每步确认 |

### 联调查验

```
Step 1 (Client):  Pact ACTIVE? → fund tx hash? → 合约余额 = budget?
Step 2 (Provider): submit tx hash? → 合约状态 Submitted?
Step 3 (Evaluator): checklist 评分? → complete tx hash? → Provider 余额增加?
```

### Go/No-Go

全流程 Sepolia + CAW 跑通至少一次。跑不通 → 降级 Tier 2（EOA 替代 CAW）。

---

## 模块 D：Demo & 提交

### 任务清单

| # | 任务 | 真实/Mock | 说明 |
|---|------|:---:|------|
| D1 | Demo 视频录制 | ✅ 真实 | CLI 录屏：全流程 + 每步 Etherscan tx hash + CAW Audit Log |
| D2 | README 完善 | ✅ 真实 | 架构图、Mermaid 状态机、合约地址、tx hash、CAW 集成说明、已知局限 |
| D3 | 提交包整理 | ✅ 真实 | 合约地址 + repo + Demo 视频 + README + CAW 集成证据 |
| D4 | Proposal Memo 更新 | ✅ 真实 | 加入实际 tx hash + 合约地址 + CAW wallet ID |

### Buffer（时间富裕）

| 任务 | 说明 |
|------|------|
| 异常路径测试 | `reject` / `claimRefund` / `expire` 在 Sepolia + CAW 上走一遍 |
| Evaluator 稳定性 | 同一交付物跑 5 次评分，记录方差 |
| Policy 拦截验证 | 故意发送超边界操作，录下 CAW 拒绝的证据 |

---

## 砍掉的功能

| 功能 | 原因 |
|------|------|
| Hook | ERC-8183 标注 OPTIONAL，MVP 不实现 |
| 多 Provider 竞价 | 硬编码单地址 |
| ERC-8004 声誉 | Dir2 未来增强 |
| 多 Evaluator 仲裁 | MVP 单 Evaluator |
| Web UI | CLI Demo 够用 |

---

## 附录 A：真实 vs Mock/Fallback 速查

| 功能 | 实现 | 标记 |
|------|------|:---:|
| ERC-8183 合约（6 状态） | Solidity | ✅ 真实 |
| CAW 钱包创建 + 资金管理 | Cobo API | ✅ 真实 |
| CAW Pact 任务级授权 | Cobo API | ✅ 真实 |
| CAW API → fund / 转账 | Agent 脚本调 CAW | ✅ 真实 |
| Client Agent | Python + CAW API | ✅ 真实 |
| Provider Agent | Python + CAW API | ✅ 真实 |
| LLM Evaluator | Python + LLM API | ✅ 真实 |
| Provider 选择 | 硬编码 | 🎭 Mock |
| Demo 交付物 | 预选合格文本 | 🎭 Mock |
| Hook / ERC-8004 / Web UI | 不实现 | ✂️ 砍掉 |

---

## 附录 B：Fallback 降级决策

```
模块 A 完成（合约 Sepolia 部署 + 6 状态跑通）？
  YES → 进模块 B + C
  NO  → 继续修合约

模块 B 完成（CAW 集成：钱包 + Pact + API 调合约）？
  YES → 进模块 C 联调
  NO（卡死 >4h）→ 降级 Tier 2：EOA 替代 CAW

模块 C 完成（全流程 Sepolia 跑通至少一次）？
  YES → 进模块 D 收尾
  NO  → 降级 Tier 3：Remix 手动 + Evaluator 手动

模块 D 完成（提交包）？
  YES → Done 🎉
  NO  → Tier 4：合约地址 + Etherscan + 设计文档
```

---

## 附录 C：时间预算

| 模块 | 内容 | 预估 |
|------|------|:---:|
| A | 合约编码 + Remix + Hardhat + Sepolia | 6-8h |
| B | CAW 注册 + 钱包创建 + Pact + API 集成 | 3-5h |
| C | Agent 脚本 + Evaluator + 联调 | 4-6h |
| D | Demo 视频 + README + 提交 | 3-4h |

**总计：16-23h。**

---

> 核心原则：**宁可交付一个范围小但跑通的 demo，也不要交付一个范围大但半成品的东西。** CAW 集成是 Cobo 赛道的硬要求——必须做实。
