# 📋 AI x Web3 学习计划

> 学员：Calciux ｜ 投入：约 2h/天 ｜ 方向：开发为主全方向探索

---

## Phase 1: Web3 基础扫盲（预计 2 周）

**目标**：理解区块链核心概念，亲手部署一个智能合约到测试网。

### Week 1 — 区块链核心概念
| 天 | 内容 | 资源 | 产出 |
|---|---|---|---|
| Day 1 | 区块链是什么：区块、链、共识、去中心化 | [Ethereum.org 初学者指南](https://ethereum.org/zh/learn/) | 笔记 |
| Day 2 | 账户模型 vs UTXO、公钥/私钥、地址生成 | [Ethereum 账户](https://ethereum.org/zh/developers/docs/accounts/) | 笔记 |
| Day 3 | 交易结构、Gas、区块浏览器使用 | [Etherscan 体验](https://sepolia.etherscan.io/) | 亲手查一笔交易 |
| Day 4 | 钱包实操：安装 MetaMask（浏览器插件），领测试币 | [Sepolia Faucet](https://sepoliafaucet.com/) | 钱包地址 + 测试币到账 |
| Day 5 | 智能合约概念：什么是合约、状态变量、交易 vs 调用 | [Solidity 入门](https://docs.soliditylang.org/) | 笔记 |
| Day 6 | 练习：Remix IDE 上手 + 写第一个合约 | [Remix IDE](https://remix.ethereum.org/) | 跑通 Counter 或 Storage 合约 |
| Day 7 | 回顾 + 用 ethers.js / web3.js 与合约交互 | [ethers.js 文档](https://docs.ethers.org/) | 代码片段 |

### Week 2 — 智能合约深入 + 测试网部署
| 天 | 内容 | 资源 | 产出 |
|---|---|---|---|
| Day 8 | Solidity 基础语法：变量、函数、修饰符、事件 | [CryptoZombies 第1课](https://cryptozombies.io/) | 笔记 |
| Day 9 | 映射、结构体、数组 + 合约间调用 | CryptoZombies 第2-3课 | 代码 |
| Day 10 | ERC-20 标准：读懂标准接口 | [OpenZeppelin ERC-20](https://docs.openzeppelin.com/contracts/5.x/erc20) | 部署一个测试代币 |
| Day 11 | ERC-721 (NFT) 标准：Mint 一张图片 | [OpenZeppelin ERC-721](https://docs.openzeppelin.com/contracts/5.x/erc721) | 部署一个测试 NFT |
| Day 12 | Hardhat 框架：本地开发环境搭建 | [Hardhat 教程](https://hardhat.org/tutorial) | 跑通测试网部署 |
| Day 13 | 项目：写一个简单合约 + 单元测试 + 部署到 Sepolia | 综合练习 | 完成 Phase 1 项目 |
| Day 14 | 回顾 + Web3 安全基础（重入、权限检查等） | [SWC Registry](https://swcregistry.io/) | 笔记 |

**Phase 1 里程碑**：部署一个智能合约到 Sepolia 测试网 ✅

---

## Phase 2: AI 能力进阶（预计 2 周）

**目标**：掌握 RAG 和 AI Agent 的基本开发，能自己搭建一个带知识库的 LLM 应用。

### Week 3 — RAG 上手
| 天 | 内容 | 资源 | 产出 |
|---|---|---|---|
| Day 15 | Embedding 概念 + 向量数据库原理 | [OpenAI Embeddings](https://platform.openai.com/docs/guides/embeddings) | 笔记 |
| Day 16 | 用 LangChain 搭建 RAG Pipeline | [LangChain RAG 教程](https://python.langchain.com/docs/tutorials/rag/) | 跑通本地 RAG |
| Day 17 | 向量数据库实操：Chroma / FAISS | LangChain + Chroma 集成 | 代码 |
| Day 18 | 文本分割策略 + 检索优化（chunk size, top-k） | 实验不同参数 | 对比结果 |
| Day 19 | RAG 进阶：HyDE、多路召回、重排序 | 论文 + 实践 | 笔记 |
| Day 20 | 项目：RAG 问答机器人（对自己文档提问） | 综合练习 | 完成 RAG 项目 |
| Day 21 | 回顾 + 当前 RAG 的局限性和改进方向 | 阅读整理 | 笔记 |

### Week 4 — AI Agent 入门
| 天 | 内容 | 资源 | 产出 |
|---|---|---|---|
| Day 22 | Agent 核心概念：工具（Tool）、思考链（ReAct）、记忆（Memory） | [LangChain Agent 文档](https://python.langchain.com/docs/tutorials/agents/) | 笔记 |
| Day 23 | 写第一个 Agent：Tool-using 简单 Agent | LangChain Agent 教程 | 代码 |
| Day 24 | 多工具 Agent：搜索引擎 + 计算器 + 天气 | 组合多个 Tool | 跑通 |
| Day 25 | LangGraph 入门：有向图编排 Agent | [LangGraph 快速开始](https://langchain-ai.github.io/langgraph/tutorials/introduction/) | 跑通示例 |
| Day 26 | Agent 记忆机制：短期、长期、持久化 | LangGraph Memory | 笔记 |
| Day 27 | 项目：一个能查信息 + 做总结的多功能 Agent | 综合练习 | 完成 Agent 项目 |
| Day 28 | 回顾 + Agent 应用场景总结 | 阅读整理 | 笔记 |

**Phase 2 里程碑**：一个可运行的 RAG 问答系统 + 一个 Tool-using Agent ✅

---

## Phase 3: AI x Web3 融合（持续）

**目标**：将 AI 能力与 Web3 结合，做出有价值的融合项目。

### 可选方向（选 1-2 个深入）

#### 方向 A：链上 AI 推理验证
- zkML 概念入门
- [EZKL](https://github.com/zkonduit/ezkl) 实践：将 ML 模型生成零知识证明，链上验证
- 项目：链上验证的图片分类器

#### 方向 B：AI Agent + 智能合约交互
- Agent 拥有钱包 + 签名交易
- Agent 自动执行 DeFi 操作（兑换、流动性提供）
- 项目：自然语言驱动的 DeFi Agent

#### 方向 C：去中心化 AI 推理网络
- [Bittensor](https://bittensor.com/) / [Gensyn](https://www.gensyn.ai/) 等网络概念
- 在开放网络上贡献/消费模型推理
- 项目：运行一个子网节点或调用去中心化推理

#### 方向 D：AI 评分的链上信誉系统
- Agent 分析链上行为数据 -> 生成信誉分
- 链上存储 + 合约读取
- 项目：DAO 贡献者信誉评分

### Phase 3 推荐路径
1. 先做 **方向 B**（AI Agent + 链交互）— 与 Phase 2 衔接最自然
2. 再探索 **方向 A**（zkML）— 技术深度高，加分项
3. 有余力再看方向 C / D

---

## 核心技术栈推荐

### Web3
- **语言**：Solidity（合约）+ TypeScript（前端/脚本）
- **框架**：Hardhat
- **工具**：MetaMask, Ethers.js, OpenZeppelin
- **测试网**：Sepolia

### AI
- **LLM API**：OpenAI / DeepSeek（你已经会了）
- **RAG 框架**：LangChain + Chroma
- **Agent 框架**：LangChain Agent → LangGraph
- **Embedding**：text-embedding-3-small / BGE

### AI x Web3
- **钱包 SDK**：Viem / Ethers.js
- **zkML**：EZKL
- **链上数据**：The Graph / Dune Analytics

---

## 学习资源汇总

### Web3 入门
| 资源 | 说明 |
|---|---|
| [Ethereum.org 学习中心](https://ethereum.org/zh/learn/) | 官方教程，中文 |
| [CryptoZombies](https://cryptozombies.io/) | 游戏化学 Solidity |
| [Hardhat 教程](https://hardhat.org/tutorial) | 本地开发环境 |
| [EatTheBlocks](https://www.youtube.com/@EatTheBlocks) | 实战 YouTube 频道 |
| [Patrick Collins 的 Solidity 课程](https://www.youtube.com/watch?v=gyMwXuJrbJQ) | 最完整的免费课程（英文） |

### AI 进阶
| 资源 | 说明 |
|---|---|
| [LangChain 官方教程](https://python.langchain.com/docs/tutorials/) | RAG + Agent |
| [LangGraph 教程](https://langchain-ai.github.io/langgraph/tutorials/) | Agent 编排 |
| [LLM 应用开发最佳实践](https://github.com/datawhalechina/prompt-engineering-for-developers) | 中文，DataWhale |
| [Andrej Karpathy 的 Intro to LLMs](https://www.youtube.com/watch?v=zjkBMFhNj_g) | LLM 原理精讲 |

### AI x Web3
| 资源 | 说明 |
|---|---|
| [ZKML 论文列表](https://github.com/worldcoin/best-of-zkml) | 零知识机器学习 |
| [EZKL 文档](https://docs.ezkl.xyz/) | zkML 实操 |
| [Bittensor 白皮书](https://bittensor.com/whitepaper) | 去中心化 AI 网络 |

---

## 学习原则

1. **动手 > 读书** — 每个概念学完立刻写代码验证
2. **笔记即代码** — 笔记里包含可运行的代码片段
3. **每日打卡** — 哪怕只有 30 分钟，记录学了什么
4. **项目驱动** — 不追求"学完再动手"，边做边学
5. **遇到问题先记下来** — 回头集中解决，不要卡太久
