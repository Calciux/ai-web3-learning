# Week 1 Proof-of-Work Pack

> 作者：Calciux + hermes agent| GitHub：[Calciux/ai-web3-learning](https://github.com/Calciux/ai-web3-learning)
> 日期：2026-05-26 ~ 2026-05-30

---

## 总览

| 维度 | 成果 |
|------|------|
| 学习天数 | 5 天（05-27 ~ 05-30，不含前期） |
| 提交次数 | 15+ commits |
| 链上交易 | 4 笔测试网交易 |
| 部署合约 | 1 个（Simple.sol，已验证源码） |
| 设计文档 | 1 个完整 Workflow 设计 |

---

## 1. AI 学习记录（概念卡片）

| 概念 | 笔记 | 链接 |
|------|------|------|
| AI Agent 基础 | 定义、工具调用、记忆系统 | [`notes/ai/AI.md`](https://github.com/Calciux/ai-web3-learning/blob/main/notes/ai/AI.md) |
| 每日打卡（5 天） | Solidity 语法 / WETH 合约 / ERC-4337 / 账户权限 / Workflow 设计 | [`daily/`](https://github.com/Calciux/ai-web3-learning/tree/main/daily) |

---

## 2. Learning Agent / AI 工具实践记录

| 实践 | 说明 | 链接 |
|------|------|------|
| Hermes Agent 配置 | CLI Markdown 渲染、SOUL.md 定制、中英双语偏好 | 对话记录 + [`SOUL.md`](https://github.com/Calciux/ai-web3-learning/blob/main/agentconfig/SOUL.md) |
| AI × Web3 流程图 | 三列泳道时序图（人 / AI Agent / Web3），标注签名/确认/验证 | [`submissions/Week 1｜AI × Web3 综合任务｜画出 AI × Web3 最小交叉流程图.md`](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%201%EF%BD%9CAI%20%C3%97%20Web3%20%E7%BB%BC%E5%90%88%E4%BB%BB%E5%8A%A1%EF%BD%9C%E7%94%BB%E5%87%BA%20AI%20%C3%97%20Web3%20%E6%9C%80%E5%B0%8F%E4%BA%A4%E5%8F%89%E6%B5%81%E7%A8%8B%E5%9B%BE.md) |
| 受限 Swap Workflow 设计 | 8 节点 Task Graph，完整参数表，端到端示例 | [`submissions/...workflow/workflow.md`](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%201%EF%BD%9C%E7%BB%BC%E5%90%88%E8%BF%9B%E9%98%B6%EF%BD%9C%E8%AE%BE%E8%AE%A1%E4%B8%80%E4%B8%AA%E5%8F%97%E9%99%90%20Web3%20%E5%8A%A9%E6%89%8B%E6%88%96%E5%B0%8F%20workflow/workflow.md) |

---

## 3. Web3 概念卡片与测试网交易记录

### 概念笔记

| 概念 | 说明 | 链接 |
|------|------|------|
| EOA / 智能账户 / 多签对比 | 11 维度权限差异表 | [`submissions/Week 1｜Web3 向进阶｜比较 EOA、智能账户、多签的权限差异.md`](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%201%EF%BD%9CWeb3%20%E5%90%91%E8%BF%9B%E9%98%B6%EF%BD%9C%E6%AF%94%E8%BE%83%20EOA%E3%80%81%E6%99%BA%E8%83%BD%E8%B4%A6%E6%88%B7%E3%80%81%E5%A4%9A%E7%AD%BE%E7%9A%84%E6%9D%83%E9%99%90%E5%B7%AE%E5%BC%82.md) |
| ERC-4337 智能账户 | 架构（Bundler/EntryPoint/Paymaster）、Guardian 恢复 | `notes/web3/智能账户-ERC-4337.md` |
| 多签账户 | Safe 多签权限模型 | `notes/web3/多签账户-Multisig.md` |
| EOA 详解 | 私钥→公钥→地址、签名机制 | `notes/web3/EOA-外部账户.md` |
| 三种账户权限对比 | 整理笔记 | `notes/web3/三种账户权限对比.md` |
| 智能合约基础 | Solidity 语法、WETH 源码精读、权限函数 | `notes/web3/Smart Contract.md` |
| WETH 合约交互 | deposit / transfer / 事件日志分析 | `experiments/first-contract-interaction/lab-log.md` |

### 测试网交易

| 操作 | 交易哈希 | 区块浏览器 |
|------|----------|-----------|
| WETH.deposit (0.0001 ETH) | `0x7aecd9ff4b3eaf8340c9e460d3e3af80eee2c934352ef6ac1450f20db2e229bd` | [查看](https://sepolia.etherscan.io/tx/0x7aecd9ff4b3eaf8340c9e460d3e3af80eee2c934352ef6ac1450f20db2e229bd) |
| WETH.transfer (0.0005 WETH) | `0xeacd70125ceadca0d9550740fc2dff6d623b8c4022d8b24e4e6d19b195d5ab71` | [查看](https://sepolia.etherscan.io/tx/0xeacd70125ceadca0d9550740fc2dff6d623b8c4022d8b24e4e6d19b195d5ab71) |
| Simple 合约部署 | `0x0f7c85869ce5e1161c85b6e0e81135da1fece38204598e7643c1d114aeb5251d` | [查看](https://sepolia.etherscan.io/tx/0x0f7c85869ce5e1161c85b6e0e81135da1fece38204598e7643c1d114aeb5251d) |
| Simple.set(42) | `0x627edd8557f430accfb27902c367ccdc9e1fb01566474880764b4a15e710a467` | [查看](https://sepolia.etherscan.io/tx/0x627edd8557f430accfb27902c367ccdc9e1fb01566474880764b4a15e710a467) |

### 已部署 / 已验证合约

| 合约 | 地址 | 区块浏览器 |
|------|------|-----------|
| WETH (Sepolia) | `0x7b79995e5f793a07bc00c21412e50ecae098e7f9` | [查看](https://sepolia.etherscan.io/address/0x7b79995e5f793a07bc00c21412e50ecae098e7f9) |
| Simple (已验证) | `0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB` | [查看](https://sepolia.etherscan.io/address/0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB) |

---

## 4. AI × Web3 最小交叉实验（流程图）

带三列泳道时序图，标注人工确认 🔑、gas 消耗 ⚡、区块浏览器验证 ✅。

| 文档 | 链接 |
|------|------|
| 流程图任务 doc | [submissions/...AI × Web3 最小交叉流程图.md](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%201%EF%BD%9CAI%20%C3%97%20Web3%20%E7%BB%BC%E5%90%88%E4%BB%BB%E5%8A%A1%EF%BD%9C%E7%94%BB%E5%87%BA%20AI%20%C3%97%20Web3%20%E6%9C%80%E5%B0%8F%E4%BA%A4%E5%8F%89%E6%B5%81%E7%A8%8B%E5%9B%BE.md) |
| 生图文件 | [submissions/flowchart.png](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/flowchart.png) |

---

## 5. 本周遇到的一个问题和一次人工修正记录

### 问题：EOA 是否具有"程序化执行能力"

**初稿表述**：EOA 没有程序化执行能力——每笔交易必须人在 MetaMask 里点确认。

**用户发现的问题**：EOA 完全可以通过脚本 + 私钥驱动（如 ethers.js），说它"没有程序化执行能力"是不准确的。

**修正后的表述**：EOA 无**链上**程序化执行能力——私钥签名即授权，没有任何链上规则（限额、延时、多签）来拦截或约束交易。安全策略完全依赖私钥的链下保管方式。可以用脚本驱动 EOA，但脚本是链下的，与智能账户将规则焊在链上是两回事。

**修正链接**：[submissions/...EAO/智能账户/多签权限差异.md](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%201%EF%BD%9CWeb3%20%E5%90%91%E8%BF%9B%E9%98%B6%EF%BD%9C%E6%AF%94%E8%BE%83%20EOA%E3%80%81%E6%99%BA%E8%83%BD%E8%B4%A6%E6%88%B7%E3%80%81%E5%A4%9A%E7%AD%BE%E7%9A%84%E6%9D%83%E9%99%90%E5%B7%AE%E5%BC%82.md)（Line 42）

### 修正：风险点框架——从「用户过度信任 AI」到「用户未给 AI 设定安全边界」

**初稿风险**：用户过度信任 AI，跳过复核直接签名。

**用户发现的框架错误**：风险本质不是用户的放松警惕，而是**系统设计者没有在一开始就为 AI 设定安全边界**（白名单地址、日限额、只读模式）。信任是心理层面，安全边界是工程层面。

**修正链接**：[AI × Web3 流程图任务 doc](https://github.com/Calciux/ai-web3-learning/blob/main/submissions/Week%201%EF%BD%9CAI%20%C3%97%20Web3%20%E7%BB%BC%E5%90%88%E4%BB%BB%E5%8A%A1%EF%BD%9C%E7%94%BB%E5%87%BA%20AI%20%C3%97%20Web3%20%E6%9C%80%E5%B0%8F%E4%BA%A4%E5%8F%89%E6%B5%81%E7%A8%8B%E5%9B%BE.md)（风险点④）

---

## 附录：仓库导航

| 目录 | 内容 |
|------|------|
| [`submissions/`](https://github.com/Calciux/ai-web3-learning/tree/main/submissions) | Week 1 所有交付件 |
| [`experiments/`](https://github.com/Calciux/ai-web3-learning/tree/main/experiments) | WETH 合约交互实验记录 + 截图 |
| [`daily/`](https://github.com/Calciux/ai-web3-learning/tree/main/daily) | 5 天打卡记录 |
| [`notes/`](https://github.com/Calciux/ai-web3-learning/tree/main/notes) | AI / Web3 概念笔记 |
