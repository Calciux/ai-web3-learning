# Week 2 | Agent Identity | Agent Profile 与能力声明草图

> 作者：Calciux | 完成日期：2026-06-12 | 来源：AI × Web3 School Bootcamp Week 2 模块 C — Identity / Reputation / Capability / Interoperability
> 关联：ERC-8183 Agentic Commerce Escrow — Evaluator Agent Profile

---

## 所选 Agent：ERC-8183 Evaluator Agent（裁决 Agent）

**为什么选它？** 在整个 ERC-8183 Agentic Commerce 链路中（Client → Provider → Escrow → Evaluator），Evaluator 是最能体现 identity / capability / reputation 交叉关系的角色——它需要被 Client 和 Provider **发现和信任**（identity + reputation），需要 **准确声明自己能验收什么类型的工作**（capability），需要通过标准接口被 **调用和集成**（interoperability），还需要在 **误判时承担责任**（failure handling / slashing）。

Evaluator 是 AI Agent 与 Web3 信任机制交汇最密集的地方：AI 做判断，Web3 约束判断边界并记录判断结果。

---

## 一、Identity（身份）

| 维度 | 描述 |
|------|------|
| **Name** | Evaluator Agent（裁决 Agent）— ERC-8183 生态中的第三方验收方。可实例化为多条链上多个 evaluator 实例，例如 `eval-sol-bp01` |
| **DID / 链上身份** | 一个以太坊地址（EOA 或智能账户）。链上身份 = 地址，不依赖 DID 协议也可工作（ERC-8183 只认地址），但可叠加 ENS 名称（如 `eval-bp01.eth`）提升可发现性 |
| **Maintainer** | 由某个实体（人、DAO、组织）部署并维护。维护者信息可通过链下声明（EAS Attestation）锚定——声明的 attester 地址指向维护者的 ENS |
| **Registry 存在** | 可注册到 on-chain aggregator / marketplace 或 off-chain directory（如 ERC-8004 的 reputation registry），供 Client 按能力标签搜索 |
| **版本标识** | 每次能力声明更新或合约升级，生成新版本 hash。EAS 可以锚定版本快照，避免歧义 |
| **身份验证（谁声明了它）** | 维护者地址签名一份能力声明（EIP-712 typed data），链上可验证签名是否来自维护者秘钥。验证不依赖第三方 |

### 身份设计关键决策

> Evaluator 的身份不是「一个 NFT 头像」，而是 **地址 + 签名能力声明 + 可选 EAS 锚定** 的三层模型。最低可行方案：裸地址 + 链下 JSON 签名。标准方案：地址 + EAS Attestation。超配方案：地址 + EAS + ERC-8004 reputation hook + ENS 名称。

这个设计遵守 **"identity 找到它就行"** 原则——不要求每个 evaluator 有 DID，但要求每个 evaluator 可被 Client 通过至少一条路径发现（registry / marketplace / ENS / EAS schema）。

---

## 二、Capability（能力声明）

能力声明是 evaluator **核心的可发现接口**。Client 需要知道这个 evaluator 能不能验我这种工作，报价多少，多久出结论。

### 2.1 声明结构（JSON / EIP-712）

```json
{
  "evaluator": "0x3e60B3...",
  "maintainer": "0x0EBbAbAa...",
  "version": "v1.0.0",
  "capabilities": [
    {
      "type": "text_quality",
      "languages": ["zh", "en"],
      "max_word_count": 10000,
      "description": "评估文档/报告的完整性、准确性、可读性",
      "eval_method": "llm_grading",
      "llm_provider": "OpenAI",
      "llm_model": "gpt-4o"
    },
    {
      "type": "code_verification",
      "languages": ["solidity", "python"],
      "max_lines": 2000,
      "description": "验证合约代码一致性测试通过率、Gas 最优性、安全模式匹配",
      "eval_method": "llm_review + static_analysis",
      "tool_used": ["slither", "mythril", "forge test"]
    },
    {
      "type": "data_integrity",
      "formats": ["json", "csv"],
      "max_rows": 100000,
      "description": "验证数据是否符合 schema、无重复、无异常值",
      "eval_method": "script_execution"
    }
  ],
  "pricing": {
    "fee_model": "per_evaluation",
    "fee_amount": "0.001 ETH",
    "fee_token": "ETH",
    "discount_for_bulk": false
  },
  "constraints": {
    "max_concurrent_evaluations": 5,
    "max_response_time": "10 minutes",
    "require_human_escalation": true,
    "escalation_threshold": "when_confidence < 0.7",
    "maintainer_contact": "eval-bp01@example.com"
  },
  "verification": {
    "proof_method": "eip_712_signed",
    "anchor": "eas_attestation_uid_0x..."
  },
  "reputation_refs": [
    "erc_8004_hook_0x8427..."
  ]
}
```

### 2.2 能力分层

| 层 | 能力类型 | 方法 | 验证难度 |
|----|---------|------|:-------:|
| L1 | 确定性验收（数据格式校验、schema 验证、hash 比对） | 脚本/合约 | 低（程序化） |
| L2 | 半确定性验收（代码测试通过、文档格式合规） | LLM grading + 工具 | 中（可复现） |
| L3 | 非确定性验收（写作质量、论证完整性、创意评估） | LLM judgment | 高（不可完美复现） |

**关键约束**：Evaluator 必须诚实声明自己的验收类型属于哪一层。Client 根据层别决定信任权重——L3 评估结果天然更依赖 evaluator 的声誉记录，因为不可完美复现。

---

## 三、Input / Output（输入输出）

### 3.1 调用方式

Evaluator 不直接暴露合约调用接口（ERC-8183 的 `complete()` / `reject()` 是 Escrow 合约上的方法）。实际调用流程：

```
Client: createJob() → fund() → 链上 job 到 Funded 状态
Provider: submit(deliveryURI) → 链上 job 到 Submitted 状态
↓
Evaluator 监听到 Submitted 事件 → 从 deliveryURI 拉取交付物 → 评估
↓
Evaluator: complete(jobId, proofURI) 或 reject(jobId, reasonURI) → 调用 Escrow 合约
```

### 3.2 Input 规范

| 参数 | 类型 | 说明 |
|------|------|------|
| `jobId` | `uint256` | ERC-8183 Job ID，链上索引 |
| `deliveryURI` | `string` | Provider 提交的交付物 URI（IPFS / Arweave / HTTPS） |
| `evalSpecURI` | `string` | Client 在 createJob 时指定的验收标准 URI |
| `deadline` | `uint256` | 链上超时时间，超时后 anyone 可 claimRefund |
| `budget` | `uint256` | 托管资金（Evaluator 可参考但无权动） |

### 3.3 Output 规范

| 输出 | 链上 | 链下 | 说明 |
|------|:---:|:----:|------|
| `complete(jobId)` | ✅ | | 调用 Escrow 合约释放资金给 Provider |
| `reject(jobId)` | ✅ | | 调用 Escrow 合约退款给 Client |
| `proofURI` | | ✅ | 评估推理过程（chain-of-thought + 证据引用），存 IPFS/Arweave |
| `confidenceScore` | | ✅ | 评估置信度 [0.0, 1.0]，confidence < threshold 时触发人工升级 |

### 3.4 链下证明结构（proofURI）

proofURI 指向一个 JSON，包含：

```json
{
  "evaluator": "0x...",
  "jobId": 42,
  "decision": "completed",
  "confidence": 0.92,
  "reasoning": "交付物包含 3 个必填注册项：...",
  "evidence": [
    {"item": "registry_A_deployed", "found": true, "txHash": "0x..."},
    {"item": "test_coverage > 80%", "found": true, "value": "87%"},
    {"item": "explanation_of_three_pillars", "found": true, "eval": "覆盖了 definition、trade-off、use case 三要素"}
  ],
  "llmConfig": {
    "model": "gpt-4o",
    "temperature": 0.0,
    "systemPrompt": "你是 ERC-8183 Evaluator，严格按照 job 的 evalSpecURI 标准逐项打分..."
  },
  "signedAt": "2026-06-12T10:00:00Z",
  "signature": "0x..."  // evaluator 对以上内容的签名
}
```

> 链下 proof 让任何人都能**事后审计** evaluator 的判断是否合理。L3 评估的落地抓手不是「证明判决正确」（无法证明），而是证明「判决过程被诚实地记录，且可被第三方复核」。

---

## 四、Interoperability（协作对象）

| 协作对象 | 接口/协议 | 协作内容 |
|----------|----------|----------|
| **ERC-8183 Escrow 合约**（如 `EscrowV2: 0x8427...`） | 合约 ABI (`complete()`, `reject()`) | 裁决结果写入链上状态机，触发资金释放或退款 |
| **Client Agent** | 链下 API / event 监听 | 接收 job 创建事件、能力发现（Client 搜索 evaluator） |
| **Provider Agent** | 无需直接协作 | Provider 仅与 Escrow 交互，Evaluator 读取其提交的 deliveryURI |
| **MCP Server（工具层）** | MCP (Model Context Protocol) | Evaluator 调用外部工具：文件读取、代码静态分析、浏览器验证 |
| **ERC-8004 Hook**（声誉层） | Hook 接口 | `complete()` 触发后自动写声誉加分；`reject()` 触发无操作（正常裁决）或 slashing 条件（误判争议） |
| **ENS** | 名称解析 | 人类可读名称 → 地址，辅助 Client 找到 evaluator |
| **EAS** | Attestation schema | 锚定能力声明的版本快照，防止事后篡改 |
| **MPP**（支付层） | 机器支付接口 | Evaluator 收取评估费——可以是自动化微支付，不依赖人工转账 |

### 协作层级金字塔

```
         Reputation Layer (ERC-8004 Hook)
         ┌──────────────────────────────────┐
         │        Interaction Flow          │
         │   Client → Escrow → Evaluator    │
         └──────────────────────────────────┘
         Payment Layer (MPP / ERC-8183 escrow)
         ┌──────────────────────────────────┐
         │        Tool Layer (MCP)          │
         │  LLM → file reader / analyzer    │
         └──────────────────────────────────┘
```

每层使用不同的协议、解决不同的问题、由不同的维护者管理。Evaluator 作为中间层串联它们。

---

## 五、Pricing / Fee（收费方式）

| 维度 | 当前设计 | 替代方案 |
|------|---------|---------|
| **计价模型** | 按次计费（per evaluation） | 也可：订阅制（月固定费 + 次数包）、Gas + 利润模型 |
| **币种** | ETH（主网原生代币） | USDT、DAI 或任意 ERC-20，由 Escrow 合约支持 |
| **收取时机** | `complete()` 触发时从托管资金中扣除（Escrow support 机制） | 也可预付到 evaluator 自己的账户 |
| **费用比例** | 固定费率（如 0.001 ETH/次） | 按比例（托管金额的 0.5%）、按复杂度（L1 < L2 < L3） |
| **失败的计费** | 若 evaluator 超时未响应导致 `claimRefund`，不收评估费 | 若 evaluator 故意误判被争议成功，需退还 + 罚金 |
| **争议费用** | 发起争议需支付小额保证金，防止滥用。争议成功则保证金退还，失败则归 evaluator |

### 收费的 Web3 维度

Evaluator 的收费不需要发 invoice —— 费用直接从 ERC-8183 Escrow 的托管资金中自动划转。传统支付需要：开票 → 发账单 → 手动收款 → 对账。这里：裁决完成 → 费用实时结算 → 链上记录不可篡改。

**不是加了一个支付功能，而是支付内建在协议层，不需要 Evaluator 自己操心收款问题。**

---

## 六、Verification（验证方式）

一个 Client 如何相信这个 Evaluator 有能力且诚实？

### 6.1 能力验证（调用前）

| 验证项目 | 方法 | 证据 |
|----------|------|------|
| 能力声明是否来自维护者 | EIP-712 签名验证 | 签名匹配维护者地址 |
| 声明的维护者是否可信 | 链下背书 / 链上 reputation aggregator / 第三方审计 | EAS attestation、ERC-8004 record |
| Evaluator **确实能运行它声明的 LLM** | `eval_spec` 中包含可复现的 prompt 和 model 配置 | Client 可以用相同输入请求 evaluator 先跑一个测试 job（sandbox mode） |
| 智能合约权限 | `complete()` / `reject()` 地址是否等于能力声明中的 evaluator 地址 | 链上 call 确认 |

### 6.2 结果验证（调用后）

| 验证项目 | 方法 | 证据 |
|----------|------|------|
| 裁决确实由声明中的 evaluator 调用 | `complete()` 的 `msg.sender` = 声明地址 | 链上交易日志 |
| 裁决理由可审计 | proofURI 指向的评估记录（含 signature） | IPFS 上可验证签名 |
| 裁决是否合理 | 任何第三方可通过 evalSpecURI + deliveryURI + proofURI 还原评估逻辑验证 | 人工 / LLM 核验 |
| Evaluator 历史上是否有过误判 | 链上 `reject()` → 争议仲裁记录、ERC-8004 累积的 reputation score | 声誉聚合器查询 |

### 6.3 验证的天然局限（必须诚实声明）

- **L3 评估**（写作质量、论证完整性）无法被第三方完美复现——同一个交付物给不同 LLM evaluator 可能得出不同结论。这里只能验证「过程诚实记录」，不能验证「结论绝对正确」。
- **解决方案**：Client 通过声誉历史和 stake 来弥补不可验证性，而不是依赖单一裁决的客观正确性。

---

## 七、Failure Modes（失败点与处理）

### 7.1 失败模式清单

| # | 失败模式 | 原因 | 影响 | 谁受损 | 处理方式 |
|--|---------|------|------|:------:|---------|
| 1 | **Evaluator 超时不响应** | 宕机 / API 超时 / 维护者失联 | Provider 的提交无法被裁决，超时后触发 `claimRefund`，Provider 白做 | Provider | ERC-8183 超时退款的全局兜底。Evaluator 的超时行为被记录在链上事件，ref 可标记不可信 |
| 2 | **Evaluator 误判（false complete）** | LLM hallucination / 评估标准理解错误、security misalignment | Provider 获得不应得的付款，Client 受损 | Client | Client 发起争议仲裁（需第三方介入）。争议证据 = proofURI + 实际交付物。若仲裁认定 evaluator 有责，扣除 stake / 扣声誉分 |
| 3 | **Evaluator 误判（false reject）** | LLM overstrict / evaluator 恶意 | Provider 应得的款被退回，Client 也拿不到交付物 | Provider | 同上。更难发现——Client 可能不主动声称 reject 错误。只有 Provider 有动机仲裁 |
| 4 | **Evaluator 被攻击** | prompt injection / jailbreak 让 evaluator 误判 | 同 2、3 | 双方 | 使用确定性 prompt 模板 + temperature=0 + 输入 sanitization。限制 prompt injection 的损失上限（单次 max budget） |
| 5 | **Evaluator 能力声明过期** | LLM model 下线 / API key 失效 / 评估标准变更后声明未更新 | 实际能力 ≠ 声明能力，Client 被误导 | Client | 设置声明有效期（validUntil），过期自动标记。version bump + EAS re-attestation |
| 6 | **Evaluator 与 Provider 合谋** | Evaluator 收受贿赂，对不合格交付物 `complete()` | Client 损失资金 | Client | 限最小信任设计：Evaluator 的 stake 大于 max job budget。合谋成本 > 收益。声誉分不可转移 |
| 7 | **Evaluator 超限调用费用** | Client 滥用免费评估额度 | Evaluator 承担额外运行成本 | Evaluator | 设置 `max_concurrent_evaluations` 硬限制，超出自动拒绝。收费模式下无关（费用覆盖成本） |
| 8 | **链下 proofURI 丢失** | IPFS 节点下线 / AWS S3 过期 / 链接腐烂 | 事后无法审计评估理由 | 所有人（审计需求场景） | Proof 内容可选加 IPFS 冗余 pin、Arweave 永久存储。关键：链上 `complete()` / `reject()` 本身是终局性证据，proofURI 是审计辅助 |
| 9 | **Human escalation 无人接管** | LTE（低于置信度阈值）但维护者不在线 | 裁决延迟或超时 | Provider / Client | 维护者 SLA 20 分钟。超时后降级为自动裁决（risk mode）。ref 参考超时次数决定是否继续雇佣 |
| 10 | **Evaluator LLM 模型被 deprecated** | OpenAI 下线 model tier / 行为漂移 | 评估结果质量下降 | 双方 | 版本监控。模型变更必须 version bump。旧版本评估记录不可修改，但新 job 应该用新版本 |

### 7.2 失败处理层级

```
第一层（协议级兜底）→ ERC-8183 claimRefund：超时自动退款，钱不会锁死
第二层（经济级）       → Evaluator stake：误判可扣除，经济损失有上限
第三层（声誉级）       → ERC-8004 reputation hook：历史表现积累为可查分数
第四层（争议级）       → 第三方仲裁：人工介入解决非确定性争议
```

设计原则：**Evaluator 误判不会导致资金永锁或丢失**。最坏情况下资金返回 Client（超时退款）或按争议结果分配。Evaluator 的最大风险不是资金损失，而是声誉降低和被移除 registry。

---

## 八、完整 Profile 骨架（JSON）

```json
{
  "profile": {
    "name": "eval-sol-bp01",
    "description": "Solidity 合约代码验收 & 文档质量评估 Agent | ERC-8183 Evaluator",
    "version": "v1.0.0",
    "maintainer": {
      "name": "Calciux",
      "address": "0x0EBbAbAeea0Db1e6552BF3f3e5F5DAA02858c28D",
      "contact": "eval-bp01@example.com",
      "reputation_ref": "https://github.com/Calciux"
    },
    "identity": {
      "chain_type": "ethereum",
      "network": "sepolia",
      "address": "0xf645...",
      "ens": null,
      "did": null
    },
    "capabilities": [
      {
        "type": "code_verification",
        "language": "solidity",
        "layer": "L2",
        "max_input": "2000 lines",
        "tools": ["slither", "forge test"]
      },
      {
        "type": "text_quality",
        "languages": ["zh", "en"],
        "layer": "L3",
        "max_input": "10000 words",
        "llm": "gpt-4o"
      }
    ],
    "interfaces": {
      "onchain": {
        "escrow_contract": "0x8427...",
        "functions": ["complete(jobId, proofURI)", "reject(jobId, reasonURI)"]
      },
      "offchain": {
        "discovery": "ERC-8004 registry / EAS attestation / marketplace",
        "evaluation": "deliveryURI → LLM call → proofURI → onchain tx"
      }
    },
    "pricing": {
      "model": "per_evaluation",
      "amount": "0.001 ETH",
      "token": "ETH",
      "auto_deduct_from_escrow": true
    },
    "constraints": {
      "max_response_time": "10 min",
      "max_concurrent": 5,
      "escalation": "if confidence < 0.7"
    },
    "stake": {
      "amount": "0.1 ETH",
      "contract": "0x...",
      "purpose": "misjudgment penalty reserve"
    },
    "verification": {
      "identity": "EIP-712 signature from maintainer",
      "capability": "sandbox test job available",
      "result": "proofURI with chain-of-thought + signature",
      "history": "ERC-8004 reputation aggregator"
    },
    "failure_handling": {
      "no_response": "onchain timeout → claimRefund",
      "misjudgment": "onchain dispute + stake slashing",
      "provable": "ERC-8004 score deduction + registry removal after N offenses"
    }
  }
}
```

---

## 九、与模块 C 理论的对齐

| 模块 C 概念 | Evaluator Agent 中的体现 |
|------------|------------------------|
| **Identity**（你是谁） | 地址 + 维护者签名声明 + EAS 锚定。不依赖 DID 协议也可工作 |
| **Capability**（你能做什么） | JSON 能力声明（代码验收 / 文档评估 / 数据验证），按 L1-L3 分层，Client 可搜索匹配 |
| **Interoperability**（怎么协作） | 链上：ERC-8183 Escrow ABI。链下：MCP 工具调用 + A2A 类 evaluator discovery |
| **Reputation**（别人为什么信你） | ERC-8004 Hook 自动记录裁决历史、争议记录、stake、ERC-8183 链上裁决数 |
| **Payment**（怎么付费） | MPP 级微支付：评估费从托管资金自动划转，不需要开票/收款 |
| **Failure**（失败怎么办） | 四层兜底：协议超时退款 → stake slashing → 声誉分扣减 → 人工争议仲裁 |

### 一句话对齐

> Evaluator Agent 的身份让 Client **找到它**，能力声明让 Client **匹配它**，链上调用让双方 **协作它**，声誉记录让所有人 **信任它**——四个环节连起来才构成完整的 identity / reputation / capability / interoperability 链路。缺任何一环，Agent 就不止是「不完整」，而是 **不可发现、不可信任、不可协作**。

---

## 十、对比反例：为什么「NFT 名片」不是完整 Identity

| 维度 | NFT 名片方案 | Evaluator Profile 方案 |
|------|------------|----------------------|
| 身份 | NFT 元数据写了一个名字 | 地址 + 签名声明 + EAS 锚定，可验证 |
| 能力 | 元数据写了"我能做评估" | 结构化 JSON 声明 + L1-L3 分层 + 可测试 |
| 调用接口 | 无 | ERC-8183 Escrow ABI + 链下 API |
| 支付 | NFT 上没有定价机制 | 费用从托管资金自动划转，标准计价 |
| 验证 | 只能看 NFT 是谁发的 | 能力可测试、结果可审计、声誉可查历史 |
| 失败处理 | 无 | 超时退款 + stake + 声誉扣减 + 争议仲裁 |
| 可发现性 | OpenSea 上搜"Evaluator" | Registry / Marketplace / ERC-8004 aggregator |

**总结**：NFT 名片是 identity 的冰山一角（且不是最重要的一角）。完整 identity 需要 identity + capability + interoperability + verification + reputation + failure 六个维度形成闭环。给 Agent 发 NFT 不解决任何真实问题——就像给员工发工牌不告诉他岗位职责、部门在哪、绩效怎么评。

---

## 附录：能力声明 Schema 草案（EAS Attestation）

```solidity
// EAS Schema for Evaluator Capability Declaration
struct EvaluatorCapability {
  address evaluator;           // Evaluator 地址
  address maintainer;          // 维护者地址
  uint256 version;             // 版本号
  bytes32 capabilityHash;      // 链下 JSON 的 keccak256 hash
  uint256 validUntil;          // Unix timestamp，过期后需重新 attest
  uint256 minStake;            // 最小 stake 要求
  string metadataURI;          // 完整能力声明 JSON 的 URI
}
```

每次版本更新 → 新的 EAS Attestation。旧版本仍然存在但 marked as superseded。Client 查询时取最新 attestation + 验证 signature。
