# Week 3：Week 1–2 缺口诊断

> 作者：Calciux + Hermes Agent | 日期：2026-06-04
> 课程：AI × Web3 School Bootcamp Week 3
> 工具：Hermes Agent 辅助诊断

---

## 一、已完成任务

### Week 1

| 任务 | 状态 | 证据 |
|------|:---:|------|
| Hermes Agent 安装与配置 | ✅ | 全 repo Agent 辅助产出；SOUL.md + Skills 配置 |
| GitHub 学习仓库 | ✅ | [Calciux/ai-web3-learning](https://github.com/Calciux/ai-web3-learning) |
| 创建测试钱包 | ✅ | Sepolia: `0x0EBbAbAeea0Db1e6552BF3f3e5F5DAA02858c28D` |
| 测试网转账 | ✅ | WETH deposit/transfer，多笔链上交易 |
| 部署或调用最小智能合约 | ✅ | Simple.sol 部署 + 源码验证 + WETH 读写交互 |
| AI × Web3 最小交叉流程图 | ✅ | 三列泳道时序图 |
| 受限 Web3 助手设计 | ✅ | 8 节点 Task Graph，含安全边界 |
| EOA / 智能账户 / 多签权限对比 | ✅ | 11 维度差异表 |
| Proof-of-Work Pack | ✅ | 完整汇总文档 |
| ERC-4337 / 多签笔记 | ✅ | notes/web3/ 下 |
| 人工修正记录 | ✅ | 两处非 trivial 修正 |
| **公开发布学习总结** | ❌ | 缺公开链接（X/Mirror/博客/GitHub README） |

### Week 2

| 任务 | 状态 | 证据 |
|------|:---:|------|
| AI × Web3 问题地图（5+方向） | ✅ | 6 方向 + Applied Path，含 7 问评估 |
| 主方向选择 | ✅ | Dir1 → Cobo 02 Trustless Agent Work Agreements |
| Dir1 深度拆解 | ✅ | 课程四层框架纠正窄化理解，验收在 Dir1 内 |
| ERC-8183 标准精读 | ✅ | 6 状态机 + 角色权限 + Hook 机制 + RFC 2119 |
| ERC-8004 标准精读 | ✅ | 三注册表 + 与 8183 集成关系 |
| 标准对比（x402/MPP/8183/8004） | ✅ | 各管一段，互补不重叠 |
| Commerce flow 设计 | ✅ | 发现→报价→托管→交付→验收→结算→争议 |
| 项目初步 Proposal | ✅ | 目标用户/真实场景/MVP/验证/风险/赛道/下一步 |
| 参考资料清单 | ✅ | 7 条，标准+课程+产品+对照案例 |
| **x402 Paywall + CAW 自主支付闭环** | ❌ | 进阶任务，未做（不在 Hackathon 主线） |
| **Agent 身份/声誉体系设计** | ❌ | Dir2 进阶任务，未做 |
| **Governance workflow 草图** | ❌ | Dir6 任务，未做 |
| **公开发布方向 Proposal** | ❌ | 缺公开链接 |

---

## 二、未完成任务

### 必须补（阻塞 Hackathon 进入 Week 4 冲刺）

| 任务 | 阻塞什么 | 预计时间 |
|------|---------|:---:|
| Week 1 公开发布学习总结 | WCB 平台提交要求（不影响开发能力） | 30min |
| Week 2 公开发布方向 Proposal | WCB 平台提交要求 | 30min |

### 推荐补（提升 Hackathon 交付质量）

| 任务 | 为什么重要 | 预计时间 |
|------|---------|:---:|
| ERC-8183 参考实现精读 | 合约编码前需理解所有 revert 条件和事件 | 1h |
| CAW 文档阅读 | Hackathon 要求集成 CAW 钱包 | 1h |
| Hardhat/Foundry 开发环境搭建 | 合约开发工具链 | 30min |

### 可跳过

| 任务 | 理由 |
|------|------|
| x402 Paywall 实践 | Cobo 01 赛道内容，02 赛道不依赖 |
| Dir2/Dir4/Dir6 进阶任务 | 不在 Hackathon 主线 |
| Week 1 进阶区块链任务 | 已通过合约交互证明基础能力 |

---

## 三、需要补齐的材料

| 材料 | 用途 | 当前状态 |
|------|------|:---:|
| ERC-8183 合约代码（Solidity） | Hackathon 核心交付 | 未开始（有标准原文可参考） |
| Sepolia 测试网部署记录 | Demo 展示 + WCB 提交 | 有历史部署经验 |
| Agent 脚本（Client/Provider/Evaluator） | Hackathon 链下逻辑 | 未开始 |
| CAW 集成方案 | Hackathon 赛道要求 | 未开始 |
| Demo 视频脚本 | WCB 提交 | 未开始 |
| Hackathon Direction Card | WCB 平台提交 | 未提交 |

---

## 四、是否可以直接进入 Hackathon

**可以。**

理由：
- Week 1 核心能力（Agent 使用 + 合约交互 + 测试网操作）全部具备
- Week 2 方向研究（Dir1 四层框架 + ERC-8183 精读 + commerce flow + 风险分析）足够支撑开发决策
- Hackathon Proposal 已对齐赛道要求，MVP 范围明确（一条 Happy Path）
- 唯一缺口是开发环境搭建和合约编码——这两样是 Week 4 冲刺的内容，不是进入 Hackathon 的前提

**风险提醒**：
- Solidity 合约是第一个完整合约项目，Remix 先验证再进 Hardhat 可降低卡壳概率
- CAW 集成可能比预期复杂，MVP 先用 EOA 钱包跑通再接入 CAW
- 公开学习总结是 WCB 提交要求，开发间隙可顺手完成

---

## 五、Week 3 建议节奏

| 日 | 任务 | 交付物 |
|----|------|--------|
| Day 1 | 公有 Week 1 总结 + Week 2 Proposal | 公开链接 |
| Day 2 | ERC-8183 合约 Remix 最小版 + 部署 | Sepolia 合约地址 |
| Day 3 | Agent 脚本（Client/Provider）| Python 可跑通 |
| Day 4 | LLM Evaluator 验收逻辑 + 端到端联调 | 完整 Demo 流程 |
| Day 5 | CAW 文档 + 集成评估 + Demo 视频录制 | Demo 视频 |
| Day 6 | README + Hackathon 提交包 | 提交包 |
