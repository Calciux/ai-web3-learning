# 📋 AI × Web3 学习计划

> 学员：Calciux ｜ 方向：开发/Builder ｜ 投入：约 2h/天

---

## 第一部分：AI 基础（Week 1）

**对应 Handbook**：[AI 基础](https://aiweb3.school/zh/handbook/) 章节（LLM → 评估）

**目标**：补齐 AI 侧的共同语言，为后续 Agent 开发打基础。

| Day | 主题 | Handbook 章节 | 产出 |
|:---:|------|:-------------:|:----:|
| 1 | 大语言模型（LLM）— 能力边界、Token 机制、API 调用 | [大语言模型](https://aiweb3.school/zh/handbook/llm/) | 笔记 + 调用一次 LLM API |
| 2 | 提示词（Prompt）— 结构、角色设定、输出格式控制 | [提示词](https://aiweb3.school/zh/handbook/prompt/) | 整理自己的 Prompt 模板 |
| 3 | 上下文（Context）— Token 限制、窗口管理、截断策略 | [上下文](https://aiweb3.school/zh/handbook/context/) | 实验不同上下文长度的效果 |
| 4 | 检索增强生成（RAG）— Embedding、向量库、检索策略 | [检索增强生成](https://aiweb3.school/zh/handbook/rag/) | 跑通一个本地 RAG 管线 |
| 5 | 智能体（Agent）— ReAct、工具调用、记忆 | [智能体](https://aiweb3.school/zh/handbook/agent/) | 写一个最少 Tool-using Agent |
| 6 | 框架（Frameworks）+ MCP — LangChain、LangGraph、协议 | [框架](https://aiweb3.school/zh/handbook/frameworks/) + [MCP](https://aiweb3.school/zh/handbook/mcp/) | 对比不同框架的编排方式 |
| 7 | 评估（Evaluation）— 如何测试 Agent 行为和工具调用 | [评估](https://aiweb3.school/zh/handbook/evaluation/) | 为一个 Agent 写评估用例 |

**里程碑**：能说自己懂 LLM 能做什么不能做什么，能写一个 Tool-using Agent ✅

---

## 第二部分：Web3 基础（Week 2-3）

**对应 Handbook**：[Web3 基础](https://aiweb3.school/zh/handbook/) 章节（网络 → 安全）

**目标**：理解链上系统的基本运行方式，亲手部署合约到测试网。

| Day | 主题 | Handbook 章节 | 产出 |
|:---:|------|:-------------:|:----:|
| 8 | 网络（Network）— 区块、共识、L2、RPC | [网络](https://aiweb3.school/zh/handbook/network/) | 用 curl 调一次 RPC |
| 9 | 密码学（Cryptography）— 哈希、公私钥、签名 | [密码学](https://aiweb3.school/zh/handbook/cryptography/) | Python 跑一次 ECDSA 签名验证 |
| 10 | 钱包（Wallet）— EOA、地址派生、助记词 | [钱包](https://aiweb3.school/zh/handbook/wallet/) | MetaMask 实操（已会 ✅） |
| 11 | 智能合约（Smart Contract）— 状态变量、交易 vs 调用 | [智能合约](https://aiweb3.school/zh/handbook/smart-contract/) | Remix 部署一个 Counter |
| 12 | 账户抽象（AA）— ERC-4337、Session Key | [账户抽象](https://aiweb3.school/zh/handbook/account-abstraction/) | 理解 AA 为何重要 |
| 13 | DeFi — 资产、流动性、AMM、借贷 | [去中心化金融](https://aiweb3.school/zh/handbook/defi/) | 在 Sepolia 上走一次 Swap |
| 14 | 预言机（Oracle）— 链外数据上链、价格喂价 | [预言机](https://aiweb3.school/zh/handbook/oracle/) | 读一次 Chainlink 喂价 |
| 15 | 索引（Indexing）— 链上数据查询、The Graph | [索引](https://aiweb3.school/zh/handbook/indexing/) | 查一次子图数据 |
| 16 | 安全（Security）— 合约风险、权限、交易模拟 | [安全](https://aiweb3.school/zh/handbook/security/) | 用 Tenderly 模拟一笔交易 |

**里程碑**：在 Sepolia 上部署一个合约 + 用 Block Explorer 验证 ✅

---

## 第三部分：AI × Web3 Bridge（Week 4-5）

**对应 Handbook**：[AI × Web3 Bridge](https://aiweb3.school/zh/handbook/) 章节（链感知上下文 → 去中心化 AI）

**目标**：把 AI 能力和链上系统真正连起来。

| Day | 主题 | Handbook 章节 | 产出 |
|:---:|------|:-------------:|:----:|
| 17 | 链感知上下文 — 链上状态如何进入 Agent 上下文 | [链感知上下文](https://aiweb3.school/zh/handbook/chain-aware-context/) | Agent 读取钱包余额 |
| 18 | Web3 工具调用 — RPC、合约调用作为 Agent Tool | [Web3 工具调用](https://aiweb3.school/zh/handbook/web3-tool-use/) | Agent 调用链上数据 |
| 19 | 智能体工作流 — 哪些步骤自动、哪些需人工确认 | [智能体工作流](https://aiweb3.school/zh/handbook/agent-workflow/) | 画一个 Agent 流程图 |
| 20 | 智能体钱包 — Session Key、权限管理 | [智能体钱包](https://aiweb3.school/zh/handbook/agent-wallet/) | 配置一个有限权限的 Agent 钱包 |
| 21 | 机器支付 — 小额支付、服务结算 | [机器支付](https://aiweb3.school/zh/handbook/machine-payment/) | Agent 自动支付一笔 Gas |
| 22 | 结算与托管 — 自动化交易、争议处理 | [结算与托管](https://aiweb3.school/zh/handbook/settlement-and-escrow/) | 理解托管合约逻辑 |
| 23 | 智能体身份 + 信任 / 声誉 | [智能体身份](https://aiweb3.school/zh/handbook/agent-identity/) + [信任](https://aiweb3.school/zh/handbook/agent-trust-and-reputation/) | 思考 Agent 如何被识别 |
| 24 | 可验证 AI — 模型输出和执行的验证 | [可验证 AI](https://aiweb3.school/zh/handbook/verifiable-ai/) | 理解 zkML 的基本流程 |
| 25 | AI 安全 + AI 隐私 | [AI 安全](https://aiweb3.school/zh/handbook/ai-security/) + [隐私](https://aiweb3.school/zh/handbook/ai-privacy/) | 整理 Agent 安全清单 |
| 26 | 治理 AI + AI 主权 + 去中心化 AI | [治理](https://aiweb3.school/zh/handbook/governance-ai/) + [主权](https://aiweb3.school/zh/handbook/ai-sovereignty/) + [去中心化 AI](https://aiweb3.school/zh/handbook/decentralized-ai/) | 理解 AI 治理挑战 |

**里程碑**：一个能调用链上工具 + 签名交易 + 记录结果的 Agent ✅

---

## 第四部分：前沿探索（持续）

**对应 Handbook**：[前沿探索](https://aiweb3.school/zh/handbook/) 章节

**目标**：选 1-2 个方向做出可展示的原型。

| 方向 | 内容 | 产出目标 |
|:----|:-----|:--------:|
| [智能体商业](https://aiweb3.school/zh/handbook/agentic-commerce/) | Agent 发现服务 → 协商 → 支付 → 留凭证 | 最小可行演示 |
| [钱包与权限](https://aiweb3.school/zh/handbook/wallet-permission/) | Session Key、Policy、Guard 原型 | 可交互的权限演示 |
| [AI 安全](https://aiweb3.school/zh/handbook/exploration-ai-security/) | 攻击面演示、权限隔离、审计日志 | 安全 demo |
| [治理](https://aiweb3.school/zh/handbook/governance/) | DAO 治理中的 AI 协作工具 | 原型 |
| [开发工具](https://aiweb3.school/zh/handbook/dev-tooling/) | 合约理解、测试、代码审查工具 | 工具 |
| [开放赛道](https://aiweb3.school/zh/handbook/open-track/) | 自由选题 | - |

---

## 核心技术栈

### Web3
- **合约**：Solidity
- **框架**：Hardhat / Foundry
- **工具**：MetaMask, Viem, OpenZeppelin
- **测试网**：Sepolia

### AI
- **LLM API**：OpenAI / DeepSeek
- **RAG**：LangChain + Chroma
- **Agent**：LangChain Agent → LangGraph
- **评估**：LangSmith / 自建

### AI × Web3
- **钱包 SDK**：Viem
- **链上工具**：Coinbase AgentKit / LangChain 集成
- **链上数据**：The Graph / Dune Analytics
- **安全**：Tenderly Simulation / Rabby Wallet

---

## 学习资源汇总

### 固定入口
| 资源 | 链接 |
|:----|:----|
| Handbook | https://aiweb3.school/zh/handbook/ |
| WCB 课程页面 | https://web3career.build/zh/programs/AI-Web3-School |
| WCB Learning | https://web3career.build/zh/programs/AI-Web3-School#tab=learning |
| WCB Agent API | https://web3career.build/llms.txt |
| GitHub | https://github.com/Calciux/ai-web3-learning |

### Handbook 各章直接链接
表格见上方每日计划，「Handbook 章节」一列的链接就是。

---

## 学习原则

1. **动手 > 读书** — 每章学完立刻写代码验证
2. **笔记即产出** — 笔记里包含可运行的代码片段
3. **每日打卡** — 每天至少记录学到了什么
4. **Handbook 反馈闭环** — 发现 Handbook 的问题 → 记到 `handbook-feedback/`
5. **遇到问题先记再问** — 不要卡太久
