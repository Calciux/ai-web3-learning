# Hermes Agent Memory 配置记录

> 最后更新：2026-06-04
> 本文件是 Hermes Agent 当前 Memory + User Profile 的公开镜像，供查阅。

---

## Memory（Agent 持久化笔记）

### 仓库信息
- 路径：`/home/nytch/ai-web3-learning`
- 远端（SSH）：`git@github.com:Calciux/ai-web3-learning.git`
- Daily 笔记：`daily/YYYY-MM-DD.md`，模板含「文件变更记录」章节
- 分支：main，先 commit 再单独 push

### 环境信息
- WSL (Windows Subsystem for Linux)，Windows 文件在 `/mnt/c/` 和 `/mnt/d/`
- Browser tool 在 WSL 下不可用（Node.js ESM 兼容性问题），遇网页给 URL 让用户自己打开
- VS Code Remote-WSL 连接仓库编辑，`code /home/nytch/ai-web3-learning` 打开

### 用户钱包
- Sepolia 测试网：`0x0EBbAbAeea0Db1e6552BF3f3e5F5DAA02858c28D`

### 技术纠错记录
- Logs 中 Topics[0] 是事件签名哈希 `keccak256("EventName(type1,type2)")`，不是函数选择器。函数选择器在 input data 前 4 字节
- ERC-8183 "Agentic" ≠ AI Agent，指广义自动化实体

### Hackathon 当前状态
- 赛道：Cobo 02 — Trustless Agent Work Agreements
- 方向对齐：Dir1（Payment/Commerce/Settlement）为主，验收在 Dir1 内
- ERC-8183 = 执行骨架，ERC-8004 = 信任增强（通过 8183 Hook 集成）
- Proposal 在 `hackathon/`

### 文件修改审查工作流
- 小改（几行）：Agent 直接改原文件，用户 VS Code Source Control 面板看 diff
- 大改（完整 section 以上）：Agent 生成 `<文件名>-proposed.md`，用户并排对比搬运
- Agent 修改如指定了范围（"更新 X/Y/Z"），必须严格只改指定内容
- 核心原则：Agent 输出永远是 draft，不过用户眼睛不进 commit

### Harness Engineering 共识
- Harness = Prompt 约束（软件层）+ 人工审计流程（流程层），两层是正式组成部分
- 人工审查不是补救措施，是 harness 的正式一环

### 实验与文档规范
- 实验：`experiments/<项目>/` 含 `guide.md` + `lab-log.md`
- 截图：从 `/mnt/d/linux/` 复制
- 文档三分法：设计过程.md / workflow.md / 交互 demo
- tasks/ 命名：`Week N｜分类｜标题.md`
- trash/ 目录存放已整理但不确定删除的文件

---

## User Profile（用户画像）

### 基本信息
- 深圳，GitHub: Calciux，AI/ML 背景学 Web3

### 学习风格
- 中文解释，首次引入概念附英文原文
- 好质疑，批判性思维强，主动追问方向核心价值
- 偏好先理解任务目标再进入细节
- 三要素解释法：一句话 + 例子 + 误区
- 「提交」一词有歧义（git commit / WCB 提交），上下文不明时先澄清

### 内容偏好
- 来源透明：每次引用外部内容主动追问出处
- CLI Markdown 双模式：(a) 渲染用表格 (b) 复制用代码块包裹
- 自我展示：AI / Web3 / 交叉方向三段技术栈列表，简短

### AI × Web3 评估框架
- 统一 7 问：无 AI？无 Web3？角色权责？自动化边界？验证方式？落地层？失败原因？
- AI × Web3 风险重心：AI 不确定性（hallucination、遗漏、上下文丢失），非操作失误

### Git 安全约束
- Git 仓库操作（add/commit/push）必须先用 clarify 展示变更摘要并请求确认
