# 钱包交互地图：从连接到验证的完整链路

> 配合「Web3 运行原理」课程使用 | 测试网：Sepolia | 工具：MetaMask

---

## 一、全景流程图

```mermaid
flowchart TB
    A(["开始
    🌐 打开 dApp"]) --> B{钱包已安装？}
    B -->|是| C[连接钱包<br>Connect]
    B -->|否| B1[安装 MetaMask] --> C

    C --> D{网络匹配？}
    D -->|否| E[切换网络<br>Switch Network]
    D -->|是| F[读取链上信息<br>Read]

    subgraph Read [🔍 只读操作 · 无 Gas · 无状态改变]
        F --> G[查余额<br>eth_getBalance]
        F --> H[查代币信息<br>Contract Call]
        F --> I[查授权额度<br>allowance()]
    end

    G & H & I --> J{下一步操作？}

    J -->|签名消息| K[签名消息<br>Sign Message]
    J -->|发送交易| L[发送交易<br>Send Tx]

    subgraph Sign [✍️ 签名 · 仅私钥签名 · 无链上写入]
        K --> K1[弹窗：签名请求<br>个人化签名 / EIP-712]
        K1 --> K2{人工确认<br>签的是什么？}
        K2 -->|拒绝| Z[流程结束]
        K2 -->|通过| K3[返回 signature<br>✓ 完成]
    end

    subgraph Write [📝 链上写入 · 需 Gas · 改变状态]
        L --> L1[构造交易：<br>to / data / value / nonce]
        L1 --> L2[MetaMask 弹窗：<br>确认交易详情]
        L2 --> L3{人工确认}
        L3 -->|拒绝| Z
        L3 -->|通过| L4[签名 + 广播<br>eth_sendRawTransaction]
        L4 --> L5[等待收据<br>txReceipt]
        L5 --> M[查看 Explorer]
    end

    M --> Z(["结束"])
```

---

## 二、每一步的详细拆解

### 1. 连接钱包 (Connect Wallet)

**技术本质**：dApp 通过 `window.ethereum` 请求 `eth_requestAccounts` → 用户选择授权哪些地址 → dApp 获得地址列表

| 项目 | 内容 |
|------|------|
| 底层 RPC 调用 | `eth_requestAccounts` |
| 链上状态改变 | ❌ 否 — 纯前端握手，不产生交易 |
| 需要 Gas | ❌ 否 |
| 用户看到什么 | MetaMask 弹出：*「连接此网站？」* → 列出钱包地址 → 点击「连接」 |
| 关键检查点 | ✅ 确认左上角显示的是测试网 |
| | ✅ 确认地址正确（与 faucet 领水地址一致）|

**用户应该确认的信息**：
- 连接的网站域名是否真实（不是 `sepolia-etherscan.phishing.com`）
- 请求连接的地址是否正确
- dApp 是否明确告知要访问哪些信息

---

### 2. 切换网络 (Switch Network)

**技术本质**：dApp 调用 `wallet_switchEthereumChain`（或 `wallet_addEthereumChain`）→ MetaMask 弹窗确认 → 网络切换

| 项目 | 内容 |
|------|------|
| 底层 RPC 调用 | `wallet_switchEthereumChain({ chainId: "0xaa36a7" })` |
| 链上状态改变 | ❌ 否 — 仅改变本地 RPC 端点 |
| 需要 Gas | ❌ 否 |
| 用户看到什么 | MetaMask 弹出：*「此网站请求切换到 Sepolia」* → 点击「切换网络」|
| 关键检查点 | ✅ chainId 是否正确（Sepolia = 11155111） |
| | ✅ RPC URL 是否可信 |

**链 ID 速查表**：

| 网络 | Chain ID (十进制) | Chain ID (十六进制) |
|------|------------------|--------------------|
| Ethereum Mainnet | 1 | 0x1 |
| Sepolia 测试网 | 11155111 | 0xaa36a7 |
| Polygon | 137 | 0x89 |
| Arbitrum One | 42161 | 0xa4b1 |

> 🚨 **安全红线**：如果 dApp 让你切到 Mainnet 但看起来像测试网，**别切**。

---

### 3. 只读操作：查余额、查代币、查授权 (Read)

**技术本质**：调用链上合约的 `view` / `pure` 函数 → 节点本地执行 → 返回结果。**不产生交易，不签名，不消耗 Gas。**

| 操作 | 底层调用 | 用户看到什么 |
|------|---------|------------|
| 查 ETH 余额 | `eth_getBalance(address, "latest")` | 直接在 MetaMask 主页看到余额 |
| 查代币余额 | `balanceOf(address)` 合约调用 | dApp 页面显示余额数字 |
| 查授权额度 | `allowance(owner, spender)` 合约调用 | dApp 显示「USDC 授权额度：1000」|

**用户应该确认的信息**：
- 余额数字是否和预期一致
- 授权额度：别人（spender 地址）最多能花你多少钱

> 🧠 **AI 背景视角**：这些调用本质上是对以太坊状态的 **KV 读操作**。EVM 的状态树是一个 (address, storageSlot) → value 的巨型映射，view 函数就是读这个映射。节点本地执行，不广播到网络。

---

### 4. 签名消息 (Sign Message)

**技术本质**：用私钥对一段数据签名 → 返回 `(r, s, v)` 签名值 → **不广播到链上，不消耗 Gas。**

| 项目 | 内容 |
|------|------|
| 底层 RPC 调用 | `personal_sign` / `eth_signTypedData_v4` (EIP-712) |
| 链上状态改变 | ❌ 否 — 纯签名，链上无记录 |
| 需要 Gas | ❌ 否 |
| 用户看到什么 | MetaMask 弹出签名请求：一段消息原文或结构化数据 |

**三种签名类型对比**：

| 类型 | 用户看到什么 | 风险等级 | 典型用途 |
|------|------------|---------|---------|
| `personal_sign` | 一段明文 + 地址 | ⚠️ 中等 — 用户可能看不懂 | 登录验证 (Sign in with Ethereum) |
| `eth_sign` | 一串十六进制 | 🔴 **高危** — 盲签，不推荐 | 已被多数钱包禁用 |
| `eth_signTypedData_v4` | 结构化表格（金额、过期时间等） | 🟢 安全 — 每条字段都展示 | Permit / 授权转账、订单签名 |

**用户应该确认的信息**（特别是有结构化签名时）：
- 签名请求来自哪个域名
- 消息内容是否合理（"Sign this message to log in" 正常，但一串看不懂的 hex 要警惕）
- 如果是 EIP-712 结构化数据，检查**每一项字段的值**：
  - `owner` — 是不是你的地址
  - `spender` — 谁将获得授权
  - `value` — 授权多少钱
  - `nonce` — 是否存在重放风险
  - `deadline` — 过期时间是否合理

> 🚨 **Permit 钓鱼警示**：EIP-2612 (Permit) 允许用一个链下签名代替 `approve()` 交易。攻击者可以让你签一个「看起来无害」的消息，实际上授权他们花光你的 USDC。

---

### 5. 发送交易：授权 / 转账 / Swap (Write)

**技术本质**：构造交易 → 私钥签名 → 广播到 Mempool → 矿工/验证者打包进区块 → 执行 → 状态根更新

| 项目 | 内容 |
|------|------|
| 底层 RPC 调用 | `eth_sendRawTransaction` |
| 链上状态改变 | ✅ **是** — 改变账户余额、合约存储等 |
| 需要 Gas | ✅ **是** |
| 用户看到什么 | MetaMask 弹出交易确认窗口：发送金额 + Gas 费 + 目标合约 |

**交易结构拆解**：

```
交易 = {
    from:    0x...  ← 你的地址（唯一标识谁付Gas）
    to:      0x...  ← 合约或钱包地址
    value:   0.01 ETH ← 发送的 ETH 数量（不含代币）
    data:    0x...  ← 合约调用数据（函数选择器 + 编码参数）
    nonce:   5      ← 该地址已发送交易数（防重放）
    gas:     21000  ← Gas Limit（简单转账），合约调用更高
    maxFeePerGas:  50 gwei
    maxPriorityFeePerGas: 2 gwei    ← 小费给验证者加速
    chainId: 11155111 ← 链ID（防跨链重放）
}
```

**Gas 计算**：
```
交易费 = Gas Used × (baseFeePerGas + priorityFeePerGas)
       = 21000 × (30 + 2) gwei
       = 672,000 gwei = 0.000672 ETH
```

**用户应该确认的信息**（每项都必须看！）：
| 字段 | 问自己 |
|------|--------|
| `to` 地址 | 这是不是我知道且信任的合约？拼写检查！ |
| `value` | 我确实想转这么多 ETH 吗？ |
| `data` | 这个合约调用在做什么？（MetaMask 会解析常见合约） |
| `maxFeePerGas` | Gas 上限是否合理？设太高会被烧掉，设太低卡住 |
| 总金额 | 发送金额 + Gas 费 ≤ 我的余额？ |

> 🧠 **AI 背景视角**：交易签名本质上是一个 **非对称加密的一次性授权**。你用私钥对交易的 RLP 编码哈希签名，矿工用你的公钥恢复出地址（`ecrecover`），验证 `from` 字段匹配，然后执行。整个过程不暴露私钥，只暴露签名值 (r, s, v)——这也是 ECDSA 的设计目标。

---

### 6. 查看区块浏览器 (Explorer)

**技术本质**：区块浏览器是对链上数据的**只读索引**——它运行自己的归档节点，索引所有区块、交易、事件日志，提供 SQL 般的搜索接口。

| 操作 | URL 模式 | 用户看到什么 |
|------|---------|------------|
| 查地址 | `sepolia.etherscan.io/address/0x...` | 余额、交易历史、代币持有 |
| 查交易 | `sepolia.etherscan.io/tx/0x...` | 状态 ✓、Gas 费、事件日志 |
| 查区块 | `sepolia.etherscan.io/block/123456` | 时间戳、交易数、Fee Recipient |
| 查合约 | `sepolia.etherscan.io/address/0x...` | 源码（如已验证）、ABI、读写函数 |

**交易详情页的关键字段**：

```
Transaction Hash:  0xabc...     ← 交易的唯一指纹
Status:            Success ✓     ← 成功 / 失败（Fail ✗）
Block:             3456789       ← 被包含在哪个区块
Timestamp:         42 secs ago   ← 确认时间（不是绝对时间，是区块时间）
From:              0x...         ← 发起者
To:                0x...         ← 目标合约 / 接收方
Value:             0.01 ETH      ← 发送的 ETH
Transaction Fee:   0.000672 ETH  ← 实际支付的 Gas 费
Gas Price:         32 Gwei       ← 实际 Gas 单价
Gas Limit & Usage: 21000 / 21000 ← 上限 & 实际消耗
Logs:              2 events      ← 合约发出的事件（Transfer、Swap 等）
```

**用户应该确认的信息**：
- ✅ **Status: Success** — 交易成功了？还是回滚了？
- ✅ 目标地址是否正确（与交易确认页一致）
- ✅ Gas 费是否合理
- ✅ Logs 里的事件是否符合预期（比如 Transfer 的 from/to 正确）

---

## 三、操作分类矩阵：Read / Sign / Write

| 操作 | 分类 | 链上状态改变 | Gas | 签名 | 私钥参与 |
|------|------|:----------:|:---:|:---:|:-------:|
| 查看余额 | 🔍 Read | ❌ | ❌ | ❌ | ❌ |
| 查看代币信息 | 🔍 Read | ❌ | ❌ | ❌ | ❌ |
| 查看授权额度 | 🔍 Read | ❌ | ❌ | ❌ | ❌ |
| 连接钱包 | 🔗 Connect | ❌ | ❌ | ❌ | ❌ |
| 切换网络 | 🔄 Config | ❌ | ❌ | ❌ | ❌ |
| SIWE 登录签名 | ✍️ Sign | ❌ | ❌ | ✅ | ✅ (离线) |
| Permit 签名 (EIP-2612) | ✍️ Sign | ❌* | ❌ | ✅ | ✅ (离线) |
| Transfer ETH | 📝 Write | ✅ | ✅ | ✅ | ✅ (交易签名) |
| Approve Token | 📝 Write | ✅ | ✅ | ✅ | ✅ (交易签名) |
| Swap / 合约交互 | 📝 Write | ✅ | ✅ | ✅ | ✅ (交易签名) |
| 部署合约 | 📝 Write | ✅ | ✅ | ✅ | ✅ (交易签名) |

> \* Permit 签名可以在链下完成，但最终需要一个 `permit()` 交易来执行授权——签名本身不改变状态，但签名被提交到链上时改变。所以 Permit 是**签名 + 交易两步走**。

---

## 四、AI Agent 辅助时的安全矩阵

如果 AI Agent 代替你操作钱包，**哪些步骤必须保留人工确认？**

| 操作 | AI 可自主执行？ | 必须人工确认？ | 原因 |
|------|:-------------:|:------------:|------|
| 连接钱包 | ✅ 可 | ❌ | 只需一次授权，后续复用 |
| 切换网络 | ✅ 可 | ❌ | 无资金风险 |
| 查余额 / 查代币 | ✅ **完全可以** | ❌ | 只读操作，无签名无 Gas |
| 查授权额度 | ✅ **完全可以** | ❌ | 只读操作 |
| SIWE 签名登录 | ⚠️ 有条件 | ❌ | 如果私钥不暴露给 Agent（托管签名） |
| **Permit 签名** | ❌ **不可** | 🔴 **必须** | Permit 签名授权额度，一旦泄露就是资金损失 |
| **Transfer ETH** | ❌ **不可** | 🔴 **必须** | 资金转出 |
| **Approve Token** | ❌ **不可** | 🔴 **必须** | 授权别人能花你的钱 |
| **Swap / 合约交互** | ❌ **不可** | 🔴 **必须** | 复杂的链上逻辑，可能产生意外结果 |
| 查看 Explorer 结果 | ✅ **完全可以** | ❌ | 只读，AI 自动分析交易状态 |
| 交易模拟 (Tenderly) | ✅ **完全可以** | ❌ | 只读模拟，提前判断交易结果 |

### AI Agent 的安全红线（三不原则）

```
1. 不碰私钥        → 使用托管签名 / 会话密钥，而非裸私钥
2. 不替人批准       → 任何 approve/permit 必须有人的最后确认
3. 不替人转账       → 任何 value > 0 的 transfer 必须有人的确认
```

### 合理的 AI Agent 钱包架构

```
用户 ←→ AI Agent ←→ 会话密钥（ERC-4337）
                      ↕
                   智能合约钱包
                      ↕
                   链上交互

   会话密钥限制：
   - 单笔最大金额：0.1 ETH
   - 日累计上限：0.5 ETH
   - 白名单合约：仅限 Uniswap、AAVE 等已验证合约
   - 操作类型：仅限交换、质押，禁止 approve
```

---

## 五、实操：用 Sepolia 走一遍完整流程

把这个作为课后的动手任务：

```
1. 打开 https://sepolia.etherscan.io           → 读
2. 打开 https://uniswap.org 或简单 Sepolia dApp   → 连接钱包
3. 如果网络不对，切换至 Sepolia                    → 配置
4. 查一下余额                                     → 读
5. 点一个「Sign in」按钮，签名登录                  → 签名
6. 如果是 Sepolia 上的 faucet dApp，领一次水        → 写
7. 去 Etherscan 查看这笔交易                       → 读
```

每一步结束后，问问自己：
- **这个动作改链上了吗？**
- **谁付了 Gas？**
- **如果这是钓鱼网站，我损失了什么？**
