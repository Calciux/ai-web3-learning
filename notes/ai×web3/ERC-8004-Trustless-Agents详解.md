# ERC-8004: Trustless Agents — 详解

> Draft，作者 Marco De Rossi (MetaMask) / Davide Crapis (EF) / Jordan Ellis (Google) / Erik Reppel (Coinbase)
> 创建于 2025-08-13
> https://eips.ethereum.org/EIPS/eip-8004

---

## ⚠️ "Agent" 指的不一定是 AI Agent

同 ERC-8183 —— 这里的 "Agent" 是广义的"自动执行实体"，可以是传统脚本、预言机、智能合约，也可以是 AI Agent。

区别在于：**8183 解决"付钱干活"的商业层，8004 解决"这个 Agent 是谁、能不能信任"的身份层。**

---

## 一句话

三个链上注册表，让 Agent 可以被发现、评估声誉、验证输出来建立去信任的 Agent 经济。

## Motivation

MCP 和 A2A 解决了 Agent **怎么通信**，但没解决：

- **怎么发现** — 你如何知道存在哪些 Agent、它们能做什么？
- **怎么信任** — 如何判断某个 Agent 是靠谱的还是恶意的？

ERC-8004 通过三个链上注册表填补这个缺口。

## 三个注册表（三支柱）

### 1. Identity Registry（身份注册表）

**Agent 的链上身份证。** 基于 ERC-721（NFT），每个 Agent 有一个唯一 ID：

```
agentId = tokenId（递增）
agentRegistry = "eip155:1:0x742..."（命名空间:链ID:合约地址）
```

Agent 的注册文件是一个 JSON（存 IPFS / HTTPS / 链上 base64）：

```json
{
  "name": "myAgentName",
  "description": "这个 Agent 做什么",
  "image": "...",
  "services": [
    { "name": "MCP", "endpoint": "https://...", "version": "2025-06-18" },
    { "name": "A2A", "endpoint": "https://...", "version": "0.3.0" },
    { "name": "ENS", "endpoint": "vitalik.eth" },
    { "name": "DID", "endpoint": "did:method:foobar" }
  ],
  "supportedTrust": ["reputation", "crypto-economic", "tee-attestation"],
  "x402Support": false,
  "active": true
}
```

关键特性：

| 特性 | 说明 |
|:----|:-----|
| **ERC-721 兼容** | 任何 NFT 钱包/浏览器都能查看、转移 Agent |
| **多协议端点** | 一个 Agent 可同时暴露 MCP、A2A、ENS、DID、Email |
| **agentWallet** | 用 EIP-712 签名验证的收款地址，转移所有权时自动清除 |
| **端点域验证** | Agent 可在 `.well-known/agent-registration.json` 证明域所有权 |
| **Owner 可转移** | Agent 整体（身份 + 声誉）可出售或转让 |
| **链上 metadata** | 可扩展额外的链上数据（通过 `setMetadata`） |

### 2. Reputation Registry（声誉注册表）

**Agent 的信用数据。** 任何 Client（人/Agent）都可以对 Agent 留下 signed feedback。

Feedback 结构：

```
giveFeedback(agentId, value, valueDecimals, tag1, tag2, endpoint, feedbackURI, feedbackHash)
```

| 参数 | 说明 |
|:----|:-----|
| **value** | 分数（int128 固定精度） |
| **valueDecimals** | 小数点位数（0-18） |
| **tag1, tag2** | 分类标签（如 "successRate"、"uptime"） |
| **feedbackURI** | 指向 off-chain JSON 详情（IPFS） |
| **feedbackHash** | 内容完整性哈希 |
| **endpoint** | 评价针对哪个端点 |

反馈方**不能是自己的 Agent Owner**（防自刷分）。

示例标签：

| tag1 | 含义 | 示例值 |
|:----|:-----|:------|
| `starred` | 质量评分 (0-100) | 87 |
| `reachable` | 端点可达 (bool) | 1 |
| `uptime` | 在线率 (%) | 9977 (decimals=2 → 99.77%) |
| `successRate` | 成功率 (%) | 89 |
| `responseTime` | 响应时间 (ms) | 560 |

Off-chain 反馈文件可包含更复杂的结构（MCP 工具名、A2A taskId、x402 付款证明等）。

**Chain 端读取：**
- `getSummary(agentId, clientAddresses, tag1, tag2)` — 聚合评分
- `readAllFeedback(agentId, clientAddresses, ...)` — 所有原始数据
- **注意**：必须传 clientAddresses 防女巫攻击

### 3. Validation Registry（验证注册表）

**Agent 可以申请第三方验证其输出，验证者链上记录结果。**

流程：

```
Agent → validationRequest(validatorAddress, agentId, requestURI, requestHash)
   ↓
Validator → validationResponse(requestHash, response, responseURI, responseHash, tag)
  response = 0 (失败) ~ 100 (通过)
  可多次调用（软最终性 + 硬最终性）
```

| 验证方式 | 说明 |
|:---------|:-----|
| **Stake-secured re-execution** | 验证者质押后重跑 Agent 的工作，确认输出正确 |
| **zkML verifier** | 零知识证明验证 ML 推理结果 |
| **TEE oracle** | 可信执行环境验证 |
| **Trusted judge** | 人工仲裁（适合高价值任务） |

验证响应在链上可查，可被组合到其他合约中。

## 三支柱如何配合

```
                       ┌─────────────────────┐
                       │  ERC-8004 Identity   │ ← "我是谁？我能做什么？"
                       │  (ERC-721 Registry)  │
                       └──────────┬──────────┘
                                  │
            ┌─────────────────────┼─────────────────────┐
            │                     │                     │
   ┌────────▼────────┐  ┌────────▼────────┐  ┌────────▼────────┐
   │   Reputation    │  │   Validation    │  │   (其他信任层)  │
   │   Registry      │  │   Registry      │  │                 │
   │ "别人怎么评价我"│  │ "谁来验证我的   │  │   TEE / 仲裁    │
   │                 │  │  执行结果？"    │  │                 │
   └─────────────────┘  └─────────────────┘  └─────────────────┘
```

## 与 ERC-8183 的关系

8183 的规范中**直接推荐集成 ERC-8004**：

| 8183 事件 | 8004 操作 |
|:----------|:----------|
| Job Completed | 8004 Reputation → 给 Provider positive feedback |
| Job Rejected | 8004 Reputation → negative/neutral feedback |
| Hook after complete/reject | 调用 8004 合约写入声誉数据 |
| Hook before setProvider | 查询 8004 检查 Provider 声誉阈值 |

## 三支柱 vs. 已有概念对照

| 传统概念 | 8004 对应 |
|:---------|:----------|
| 公司注册号 | Identity Registry（链上唯一 ID） |
| 企业官网 | agentURI → 注册文件 |
| 信用评分 | Reputation Registry |
| ISO 认证 | Validation Registry |
| 营业执照 | ERC-721 所有权证明 |
| 收款账户 | agentWallet（防篡改的 EIP-712 签名验证） |

## AI Agent 到底在哪

同 8183 —— **8004 不关心谁是 AI**。

- 在 Identity Registry 注册的可以是任何实体（人、脚本、预言机、AI）
- Reputation Registry 的 feedback 可以给人、给合约、给 AI
- Validation Registry 的验证逻辑可以是 zkML（涉及 AI 模型证明），也可以是纯数学验证

**8004 提供的是一套链上的"发现 + 信任"基础设施，AI Agent 是这套基础设施的用户，而不是协议本身的一部分。**
