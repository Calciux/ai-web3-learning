# Week 4 Sprint Plan

> Hackathon 开发冲刺 · 每天交付什么 · 真实实现 vs Mock/Fallback
> 作者：Calciux + Hermes Agent | 日期：2026-06-05
> 赛道：Cobo · Agentic Commerce · 02 Trustless Agent Work Agreements
> 关联：Scope Review / Risk Memo

---

## 总览：Week 4 目标

一条 Happy Path 链上跑通：`createJob → setBudget → fund → submit → complete → 付款`

做完是 3 个真实组件 + 1 个 fallback：

| 组件 | 实现方式 | 标记 |
|------|---------|:---:|
| ERC-8183 Escrow 合约 | Solidity，Remix 先行 → Hardhat，Sepolia 部署 | ✅ 真实 |
| Client Agent | Python + web3.py，EOA 私钥签名 | ✅ 真实（Tier 2） |
| Provider Agent | Python + web3.py，EOA 私钥签名 | ✅ 真实（Tier 2） |
| Evaluator | Python + LLM API（checklist 5 项评分 ≥4 通过） | ✅ 真实 |
| CAW 集成 | 延后。Week 4 用 EOA，读文档产集成评估笔记 | 🎭 Tier 2 Fallback |
| Provider 选择 | 硬编码单地址 | 🎭 Mock |
| Hook 系统 | 完全不实现 | ✂️ 砍掉 |
| Web UI | 完全不实现 | ✂️ 砍掉 |

**Tier 策略**（来自 Risk Memo 第三节）：
- Tier 1（理想）：合约 + CAW + 3 Agent 脚本全自动 → 概率低
- **Tier 2（现实目标）**：合约 + EOA + 3 Agent 脚本 → 这是我们的靶心
- Tier 3（保底）：合约 + Remix 手动交互 → Day 3 结束时判断是否降级
- Tier 4（底线）：合约部署 + Etherscan 验证 → 最后手段

---

## Day 1（周五 6/6）— 合约编码

### 上午目标

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| Hardhat 环境搭建（hackrepo） | ✅ 真实 | `npx hardhat init` → TypeScript 项目，安装 `@nomicfoundation/hardhat-toolbox` |
| 创建 ERC-8183 Escrow 合约骨架 | ✅ 真实 | 文件：`contracts/TrustlessWorkAgreement.sol`。状态枚举 + 结构体 + 事件声明 |

### 下午目标

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| 核心状态机函数编码 | ✅ 真实 | `createJob()` / `setBudget()` / `fund()` / `submit()` / `complete()` / `reject()` / `claimRefund()` / `expire()`。每个函数带 modifier 权限检查 + require 状态前置条件 |
| Remix 手动部署 + 冒烟测试 | ✅ 真实 | 部署到 Remix VM 先，确认所有函数不 revert |

### 下午验证清单

- [ ] `createJob(jobId, evaluator)` → 状态 Open，事件 JobCreated
- [ ] `setBudget(jobId, budget)` → budget 存储，事件 BudgetSet
- [ ] `fund(jobId, expectedBudget)` → 转账进合约，状态 Funded，事件 Funded
- [ ] `submit(jobId)` → 状态 Submitted，事件 Submitted
- [ ] `complete(jobId)` → 转账给 Provider，状态 Completed，事件 Completed
- [ ] `reject(jobId)` → 退款给 Client，状态 Rejected，事件 Rejected
- [ ] `claimRefund(jobId)` → Client 能从 Open/Funded 退款，事件 RefundClaimed
- [ ] ⚠️ Funded 状态 Client 不能 withdraw（仅 Evaluator 能动）
- [ ] ⚠️ 非 Evaluator 不能调 complete/reject
- [ ] ⚠️ claimRefund 没有被任何 modifier 意外拦截

### 今天不做

| 不做 | 原因 |
|------|------|
| Hook（FundTransferHook / BiddingHook） | ✂️ 砍掉 |
| setProvider 动态选择 | 🎭 明天 Day 2 硬编码 |
| Hardhat 测试脚本 | Day 2 做。Day 1 用 Remix 肉眼确认 |

### Day 1 死线

**今天结束时合约必须部署到 Remix VM 且 6 状态转移 + 退款路径全部手动走通。**
做不到 → Go/No-Go 判断：如果连 Remix 都跑不通，Day 2 不进 Hardhat/测试网，继续在 Remix 上修。

---

## Day 2（周六 6/7）— 合约完善 + Agent 脚手架

### 上午：合约进 Hardhat + 部署 Sepolia

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| 合约从 Remix 迁移到 Hardhat | ✅ 真实 | 粘贴到 `contracts/`，确认编译通过 |
| 写 Hardhat 部署脚本 | ✅ 真实 | `scripts/deploy.ts` → 用 private key + Sepolia RPC |
| 部署到 Sepolia 测试网 | ✅ 真实 | 合约地址 + tx hash 截图 |
| Hardhat 手动测试脚本 | ✅ 真实 | `scripts/test-flow.ts`：程序化走完所有 8 个转移路径（含含 expire/claimRefund 非 Happy Path），每步调 `getJob()` 验证状态 |

### 下午：Agent 脚本脚手架

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| 项目结构建立 | ✅ 真实 | `agents/` 目录，`requirements.txt`（web3.py, openai 或 deepseek sdk） |
| Client Agent 脚本 | ✅ 真实 | `agents/client_agent.py`：加载私钥 → 连接 Sepolia → `createJob()` → `setBudget()` → `fund()`。硬编码 jobId、budget、provider 地址 |
| Provider Agent 脚本 | ✅ 真实 | `agents/provider_agent.py`：加载私钥 → `submit()`。接受 jobId 参数 |
| Provider 地址硬编码 | 🎭 Mock | Client Agent 中 `PROVIDER_ADDRESS = "0x..."` 写死。Demo 解释时诚实说明"当前为单 Provider 演示" |
| 调试辅助脚本 | ✅ 真实 | `agents/check_status.py <jobId>` → 读取合约当前状态、余额、事件。联调时每步先跑这个确认 |

### 今天不做

| 不做 | 原因 |
|------|------|
| CAW 集成 | 🎭 Tier 2 Fallback。读 5 分钟文档，知道 API URL 在哪即可。不动手集成 |
| Evaluator 脚本 | Day 3 |
| 端到端联调 | Day 4（先让每个 Agent 单独对着合约跑通） |

### Day 2 死线

**今天结束时合约部署到 Sepolia + 所有状态转移用 Hardhat 脚本验证通过 + Client Agent 能单独调合约 + Provider Agent 能单独 submit。**

---

## Day 3（周日 6/8）— Evaluator + 端到端联调

### 上午：LLM Evaluator

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| Evaluator 脚本 | ✅ 真实 | `agents/evaluator.py`：接收 jobId → 读链上 job 信息 → 构造 prompt → 调 LLM API → 对 checklist 逐项 yes/no → 总分 ≥4 → `complete()`，<4 → `reject()` |
| Checklist 设计 | ✅ 真实 | 5 项逐条评分：1. 交付物完整性 2. 与 job 描述匹配度 3. 格式规范 4. 逻辑一致性 5. 可验证性。每项 yes/no + 一句话理由 |
| Temperature = 0 | ✅ 真实 | 最大限度减少 LLM 随机性 |
| Demo 交付物选择 | ✅ 真实 | 选一个"5/5 明显合格"的交付物文本，不给 Evaluator 留判断空间。在 Demo 叙事中主动标出"LLM 判断有概率错误"这个局限 |

### 下午：端到端联调

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| Script 1: Full Happy Path | ✅ 真实 | `scripts/demo_full_flow.sh` 或 Python 编排脚本：依次调 Client Agent → Provider Agent → Evaluator。每步之间 sleep 等交易确认，中间调 `check_status.py` 打状态 |
| 联调顺序（一次一步） | ✅ 真实 | ① Client Agent 手动跑 → 看 Etherscan 确认 Funded → ② Provider Agent 手动跑 → 看 Etherscan 确认 Submitted → ③ Evaluator 手动跑 → 看 Etherscan 确认 Completed |
| 全自动 Demo 脚本 | ✅ 真实 | 手动跑通后，串成一个 `demo.py`：一次性跑完所有步骤 |

### 联调每步检查清单

```
Step 1 (Client):  python check_status.py <jobId>  →  Funded? 合约余额 = budget?
Step 2 (Provider): python check_status.py <jobId>  →  Submitted?
Step 3 (Evaluator): python check_status.py <jobId>  →  Completed? Provider 余额增加?
```

### 今天不做

| 不做 | 原因 |
|------|------|
| 多 Provider 竞价 | 🎭 Mock |
| 异常路径测试（reject/claimRefund） | 如果有时间再做，不阻塞 Happy Path |

### Day 3 死线

**今天结束时 Happy Path 全流程在 Sepolia 上跑通至少一次，有 tx hash 证据。**

### Go/No-Go 判断点

- ✅ 全流程跑通 → Day 4 做 CAW 文档 + Demo 视频 + README
- ❌ 合约正常但 Agent 脚本联调一直失败 → **降级到 Tier 3**：Day 4 改用 Remix 手动交互 + Evaluator 手动运行 + 状态截图。不写 Python Agent 脚本
- ❌ 合约都有 bug → **降级到 Tier 4**：Day 4 只修合约 + Etherscan 验证 + 写清楚设计文档

---

## Day 4（周一 6/9）— 收尾 + Buffer

### 优先任务（所有 Tier 共享）

| 任务 | 真实/Mock | 说明 |
|------|:---:|------|
| CAW 文档阅读 | 🎭 只读不集成 | 读 Cobo CAW 文档，产出一份简短集成评估笔记（API 端点、认证方式、Pact 创建流程、已知坑）。不写代码 |
| Demo 视频录制 | ✅ 真实 | CLI 录屏：全流程跑一遍，每步展示 Etherscan tx hash |
| README 完善 | ✅ 真实 | 加入：架构图、状态机 Mermaid、合约地址、tx hash、已知局限（Evaluator 单点信任 / 无 CAW / 单 Provider） |
| Hackathon 提交包整理 | ✅ 真实 | 按提交要求打包：合约地址 + repo + Demo 视频 + 设计文档 |

### Buffer 任务（如果时间有富裕）

| 任务 | 说明 |
|------|------|
| 异常路径测试 | `reject()` / `claimRefund()` / `expire()` 在 Sepolia 上走一遍留 tx hash |
| Evaluator 稳定性测试 | 同一交付物跑 5 次 Evaluator，记录评分方差 |
| Proposal Memo 更新 | 加入实际 tx hash + 合约地址 |

### Day 4 死线

**Hackathon 提交包完成。最晚周一晚上能提交。**

---

## Day 5（周二 6/10）— 纯 Buffer

这一天是安全网。理想情况下 Day 4 已经交完了，Day 5 什么都不用做。

如果 Day 4 被阻塞了，Day 5 是最后一天补。

### Day 5 优先级

1. 修合约 bug（如果有）
2. 补联调缺口
3. 提交

### 如果连 Day 5 都做不完

降级到 Tier 4（合约部署 + Etherscan 验证 + README 设计文档），不再碰 Agent 脚本。

---

## 附录 A：真实 vs Mock/Fallback 速查表

| 功能 | 实现 | 标记 | 降级条件 |
|------|------|:---:|------|
| ERC-8183 核心状态机（6 状态） | Solidity 合约 | ✅ 真实 | — |
| createJob / setBudget / fund | 合约函数 | ✅ 真实 | — |
| submit / complete / reject | 合约函数 | ✅ 真实 | — |
| claimRefund / expire | 合约函数 | ✅ 真实 | — |
| Client Agent 发包 + fund | Python + web3.py + EOA | ✅ 真实 | Tier 3: Remix 手动 |
| Provider Agent 接单 + submit | Python + web3.py + EOA | ✅ 真实 | Tier 3: Remix 手动 |
| LLM Evaluator checklist 评分 | Python + LLM API | ✅ 真实 | — |
| CAW 钱包集成 | 只读文档，不写代码 | 🎭 Tier 2 Fallback | — |
| CAW Pact 预算授权 | 不实现 | 🎭 Tier 2 Fallback | — |
| Provider 选择 | 硬编码单地址 | 🎭 Mock | — |
| 多 Provider 竞价 | 不实现 | 🎭 Mock | — |
| Hook（FundTransfer/Bidding） | 不实现 | ✂️ 砍掉 | — |
| Web UI / 前端 | 不实现 | ✂️ 砍掉 | — |
| ERC-8004 声誉注册表 | 不实现 | ✂️ 砍掉 | — |
| 多 Evaluator 仲裁 | 不实现 | ✂️ 砍掉 | — |

---

## 附录 B：Fallback 降级决策点

```
Day 1 结束 → 合约 Remix 跑通 6 状态？
  YES → Day 2 进 Hardhat + Sepolia
  NO  → Day 2 继续 Remix 修合约

Day 2 结束 → 合约 Sepolia 部署 + Agent 脚手架跑通？
  YES → Day 3 进 Evaluator + 联调
  NO  → Day 3 继续补合约/Agent 脚本

Day 3 结束 → 全流程 Sepolia 跑通至少一次？
  YES → Day 4 收尾（CAW 文档 + Demo + README）
  NO  → 降级 Tier 3：Day 4 Remix 手动交互 + Evaluator 手动运行

Day 4 结束 → 提交包完成？
  YES → Done 🎉
  NO  → Day 5 Buffer 补

Day 5 结束 → 仍然没交？
  降级 Tier 4：合约地址 + Etherscan + README 设计文档
```

---

## 附录 C：时间预算（Tier 2 靶心）

| 天 | 任务 | 时间 |
|----|------|:---:|
| Day 1 | 合约编码 + Remix 验证 | 4-6h |
| Day 2 | Hardhat 部署 + Agent 脚手架 | 4-5h |
| Day 3 | Evaluator + 端到端联调 | 4-5h |
| Day 4 | 收尾（文档 + 视频 + 提交） | 3-4h |
| Day 5 | Buffer | 0-4h |

**总计：15-24h usable，对应 3-5 个开发日。**

---

> 核心原则（来自 Risk Memo）：**宁可交付一个范围小但跑通的 demo，也不要交付一个范围大但半成品的东西。** 砍掉的都是好东西，但它们不是本周的优先级。
