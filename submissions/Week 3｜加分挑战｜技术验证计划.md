# Week 4 技术验证计划

> 开发时对照此清单，逐项打勾。每项至少一条可验证证据（tx hash / 截图 / 日志 / API 返回）。
> 作者：Calciux | 日期：2026-06-06
> 项目：Trustless Agent Work Agreements · Cobo 02 赛道

---

## 1. 合约级验证（链上确定性行为）

必须 Sepolia 部署后逐条验证，不做假设。来源：ERC-8183 状态机 + Sprint Plan 模块 A。

| # | 验证项 | 验证方法 | 通过标准 | ✓ |
|---|--------|----------|----------|---|
| 1.1 | `createJob(client, provider, evaluator)` → 状态 `Open`，`jobId` 递增 | Remix/Hardhat 调合约，读 `jobs(jobId)` | 状态字段 = Open，jobId = 预期值 | |
| 1.2 | `setBudget(jobId, amount)` → budget 存储 | 调 setBudget 后读 `jobs(jobId).budget` | budget == amount | |
| 1.3 | `fund(jobId)` payable → 转账进合约，状态 `Funded` | msg.value 转入，查合约余额 + 状态 | 合约余额增 amount，状态 = Funded | |
| 1.4 | `submit(jobId, deliverable)` → 状态 `Submitted`，交付物存链上 | 调 submit 后查 job 状态 + Event 日志 | 状态 = Submitted，事件 deliverableSubmitted 含 IPFS hash/文本 | |
| 1.5 | `complete(jobId)` → budget 转给 Provider，状态 `Completed` | 查 Provider 余额变化 + 状态 | Provider 余额增 budget，合约余额减 budget，状态 = Completed | |
| 1.6 | `reject(jobId)` → budget 退给 Client，状态 `Rejected` | 查 Client 余额变化 + 状态 | Client 余额增 budget，合约余额减 budget，状态 = Rejected | |
| 1.7 | `claimRefund(jobId)` 超时退款 → 状态 `Refunded` | 过 deadline 后调 claimRefund，查余额 | Client 余额增 budget，状态 = Refunded | |
| 1.8 | `expire(jobId)` → 无人 fund 超时关闭 | 过 creationDeadline 后调 expire | 状态 = Expired | |

### 1A. 权限边界验证（必须被拒绝的操作）

| # | 验证项 | 预期行为 | 证据 | ✓ |
|---|--------|----------|------|---|
| 1A.1 | Funded 后 Client 调 withdraw | revert | tx receipt status=0 / Etherscan 显示 failed | |
| 1A.2 | 非 Evaluator 调 `complete()` | revert（onlyEvaluator modifier） | tx receipt status=0 | |
| 1A.3 | 非 Evaluator 调 `reject()` | revert | tx receipt status=0 | |
| 1A.4 | 非 Client 调 `claimRefund()` | 预期 **不拦截**（ERC-8183 设计：任何人可触发超时退款） | 验证非 Client 地址成功执行 claimRefund | |
| 1A.5 | 重复 `fund()` 同一 job | revert 或正确处理 | 确认行为符合设计意图 | |

---

## 2. CAW / SDK 调用验证（Cobo 赛道硬要求）

来源：Sprint Plan 模块 B。每条 CAW API 调用需要有日志/trace 可查。

| # | 验证项 | 验证方法 | 通过标准 | ✓ |
|---|--------|----------|----------|---|
| 2.1 | Cobo 账号注册成功，API Key 可用 | `curl` 测试 API Key 鉴权 | 返回 200，含 account info | |
| 2.2 | Client CAW MPC 钱包创建 | CAW API 创建钱包 → 拿到 wallet_id + 地址 | 地址格式 0x...，Cobo Dashboard 可见 | |
| 2.3 | Provider CAW MPC 钱包创建 | 同上 | 两个钱包不同地址 | |
| 2.4 | Client CAW 钱包有 Sepolia ETH 余额 | Faucet/Cobo 内置水龙头充值 | Etherscan 查余额 > 0 | |
| 2.5 | Pact 创建 → 状态 ACTIVE | Python 脚本调 CAW API 提交 Pact（预算上限 + 合约地址 + 时间窗口）| CAW API 返回 Pact ID + 状态 ACTIVE | |
| 2.6 | 通过 CAW API 调 `fund()` → 链上交易 | Agent 脚本 → CAW API → MPC 签名 → 链上 | 拿到 tx hash → Etherscan 可查，合约余额增加 | |
| 2.7 | 通过 CAW API 调 `complete()` → Provider 收款 | Evaluator 脚本 → CAW API → 转账 | tx hash → Etherscan，Provider 余额增 | |
| 2.8 | CAW API 错误处理 | 故意传无效参数 | 返回结构化错误信息，脚本优雅处理而非 crash | |

### 2A. CAW Audit Log 可追溯性

| # | 验证项 | 通过标准 | ✓ |
|---|--------|----------|---|
| 2A.1 | 每条 CAW API 发起的链上交易有 Audit Log | Log 含：发起者 wallet_id、操作类型、金额、tx hash、时间戳 | |
| 2A.2 | Audit Log 可通过 Cobo Dashboard 查询 | Dashboard 可见完整操作历史 | |
| 2A.3 | Pact 边界拦截（Policy Engine） | 发送超出 Pact 预算/时间窗口的操作 → CAW 拒绝，Audit Log 记录拒绝原因 | |

---

## 3. Agent 脚本行为验证

来源：Sprint Plan 模块 C。每个 Agent 脚本独立可运行，输出结构化日志。

### 3A. Client Agent 脚本

| # | 验证项 | 通过标准 | ✓ |
|---|--------|----------|---|
| 3A.1 | 脚本成功初始化 CAW 连接 | 启动不报错，输出 "Connected to CAW, wallet_id=xxx" | |
| 3A.2 | 创建 Pact + `createJob` + `setBudget` + `fund` 串联执行 | 每步输出当前状态 + tx hash，最后输出 "Job xxx funded, tx: 0x..." | |
| 3A.3 | 超时重试机制 | CAW API 临时故障时重试 2-3 次，不永久 hang | |
| 3A.4 | 脚本 exit code 正确 | 成功 = 0，失败 = 非 0 | |

### 3B. Provider Agent 脚本

| # | 验证项 | 通过标准 | ✓ |
|---|--------|----------|---|
| 3B.1 | 脚本成功连接 CAW | 输出 "Connected, Provider wallet_id=xxx" | |
| 3B.2 | 监听/查询 Open 状态的 Job | 找到 jobId → 输出 Job 信息 | |
| 3B.3 | `submit(jobId, deliverable)` 成功 | tx hash 输出，Etherscan 可查 | |

### 3C. LLM Evaluator 脚本

| # | 验证项 | 通过标准 | ✓ |
|---|--------|----------|---|
| 3C.1 | 正确读取 Job 信息（req + deliverable） | 日志输出 Job 原文 | |
| 3C.2 | Checklist 5 项逐项评分（完整性/匹配度/格式/逻辑/可验证性）| 每项 yes/no + 理由，格式一致 | |
| 3C.3 | ≥4 yes → `complete()`；<4 yes → `reject()` | 逻辑正确 | |
| 3C.4 | Temperature=0 稳定性 | 同一交付物跑 5 次，评分一致（或至少 5 次结论相同） | |
| 3C.5 | LLM API 错误处理 | API 超时/限流 → 重试或安全降级，不误判 | |

---

## 4. 日志与可观测性（Agent Trace）

开发时自己能看到每一步发生了什么。所有 Agent 脚本统一日志格式。

| # | 验证项 | 通过标准 | ✓ |
|---|--------|----------|---|
| 4.1 | 统一日志格式 | `[时间戳] [Agent角色] [操作] [状态] [详情]` — 例：`[2026-06-06 14:30:01] [Client] [createJob] OK | jobId=1 tx=0xabc...` | |
| 4.2 | 每步链上操作输出 tx hash | 任何 sendTransaction 调用 → 日志含 tx hash | |
| 4.3 | 每步 CAW API 调用输出请求摘要 | 日志含 API endpoint + 参数摘要 + 返回状态码 | |
| 4.4 | 错误日志含上下文 | 出错时输出：哪个操作失败、失败原因、已尝试次数 | |
| 4.5 | `check_status.py` 调试脚本可用 | `python check_status.py <jobId>` → 输出：合约状态、余额、事件历史、相关 tx hash 列表 | |
| 4.6 | 日志可输出到文件 | 每轮运行生成 `logs/run-<timestamp>.log` | |

---

## 5. Demo 证据收集（截图/录屏/Tx Hash）

来源：Sprint Plan 模块 D。提交时必须有的可验证证据。

| # | 证据项 | 具体要求 | ✓ |
|---|--------|----------|---|
| 5.1 | Sepolia 合约部署 tx | Etherscan 截图/URL + 合约地址 | |
| 5.2 | `createJob → fund` 流程 tx | 至少 2 笔 tx hash：createJob + fund | |
| 5.3 | `submit` tx | Provider submit 的 tx hash | |
| 5.4 | `complete` tx（Happy Path） | Evaluator complete → Provider 收款的 tx hash | |
| 5.5 | 全流程 CLI 录屏 | 终端录屏：所有 Agent 脚本依次运行 → 每步输出 tx hash → 在 Etherscan 逐笔确认 | |
| 5.6 | CAW Dashboard 截图 | Audit Log 列表 + Pact 状态页面 | |
| 5.7 | Mermaid 状态机图（含标注） | 在每个状态转换上标注实际的 tx hash | |
| 5.8 | Evaluator checklist 评分截图 | 展示 5 项评分 + 最终结论 | |

---

## 6. 端到端联调验证（全流程一条线）

来源：Sprint Plan 模块 C 联调查验。`demo.py` 或手动依次运行。

| Step | 操作 | 验证点 | 证据 | ✓ |
|------|------|--------|------|---|
| 6.1 | Client 创建 Job + Pact | Pact ACTIVE? jobId 输出? | CAW API 返回 + 日志 | |
| 6.2 | Client fund | tx hash? 合约余额 = budget? | Etherscan + `check_status.py` | |
| 6.3 | Provider submit | tx hash? 合约状态 Submitted? | Etherscan + `check_status.py` | |
| 6.4 | Evaluator 评分 | checklist 5 项? 总分 ≥4? | 日志输出评分详情 | |
| 6.5 | Evaluator complete | tx hash? Provider 余额增加? | Etherscan（查 Provider 地址余额变化） | |
| 6.6 | 复盘验证 | 全流程状态流转是否完整? | `check_status.py` 显示状态 Completed | |

---

## 7. 异常路径验证（Buffer 时间富裕时）

非必需，但如果主线顺利跑通后补上，Demo 更有说服力。

| # | 验证项 | 通过标准 | ✓ |
|---|--------|----------|---|
| 7.1 | `reject` 路径 | Evaluator 评分 <4 → reject → Client 退款 tx | |
| 7.2 | `claimRefund` 路径 | 超时后 claimRefund → Client 退款 | |
| 7.3 | `expire` 路径 | 无人 fund + 超时 → expire 成功 | |
| 7.4 | CAW Policy 拦截验证 | 故意超 Pact 预算发送 tx → CAW 拒绝，Audit Log 记录 | |
| 7.5 | Evaluator 稳定性（5 次重复） | 同一交付物跑 5 次，记录每次评分 → 结论一致率 100% | |
| 7.6 | 并发场景（两个 Provider 同时 submit） | 只有一个成功（或被正确处理） | |

---

## 8. 权限与安全速查表（快速对照）

每次改合约或 Agent 逻辑后，跑一遍此表。

| # | 检查项 | 预期 | 实测 | ✓ |
|---|--------|------|------|---|
| 8.1 | 只有 Evaluator 能 complete | revert 非 Evaluator 调用 | | |
| 8.2 | 只有 Evaluator 能 reject | revert 非 Evaluator 调用 | | |
| 8.3 | 只有 Client 能 setBudget | revert 非 Client 调用 | | |
| 8.4 | Funded 后 Client 不能 withdraw | revert（资金锁定在合约） | | |
| 8.5 | claimRefund 任何人可触发 | 非 Client 地址成功执行 | | |
| 8.6 | Evaluator 不能动资金（只能判结果） | Evaluator 地址余额不变 | | |
| 8.7 | CAW Pact 预算上限不可超 | Policy Engine 拦截 | | |
| 8.8 | 重入攻击防护 | 合约无重入漏洞（检查状态更新在外部调用之前） | | |

---

## 验证优先级

按开发顺序排列，做完一个模块立即验证，不攒到最后。

```
Priority 1（合约阶段）: 1.1-1.8 → 1A.1-1A.5
Priority 2（CAW 集成）: 2.1-2.8 → 2A.1-2A.3
Priority 3（Agent 脚本）: 3A → 3B → 3C → 4.1-4.6
Priority 4（联调）: 6.1-6.6
Priority 5（Demo）: 5.1-5.8
Priority 6（Buffer）: 7.1-7.6
```

---

> 原则：**每一项打勾之前必须有一条可验证证据（tx hash / 截图 / 日志 / API 返回），不允许凭感觉打勾。**
