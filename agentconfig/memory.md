# Hermes Agent Memory 配置记录

## Memory（持久化笔记）

### 仓库信息
- 路径：`/home/nytch/ai-web3-learning`
- 远端：`https://github.com/Calciux/ai-web3-learning.git`
- Daily 笔记：`daily/` 目录，命名 `YYYY-MM-DD.md`
- 模板结构：# 打卡日期 → 今天做了什么 / 学到的重点 / 存在的问题 / 明天计划 / 投入时间
- 网络：已配置代理 `http://192.168.144.1:7890`，SSH 不可用（注：已过时，实际已切换到 SSH）

---

## User Profile（用户画像）

### 语言与风格偏好
- 中文解释 + 结构化格式（表格、架构拆解）
- 概念笔记遵循**三要素**：一句话解释、具体例子、常见误区或使用边界
- 三个要素缺一不可

### 身份信息
- GitHub：Calciux
- 语言：中文母语
- 背景：AI/ML
- Web3 水平：初学者，刚搭建 Sepolia 测试网 MetaMask 钱包
- 偏好：详细、分步解释，中文术语 + 实际类比

### 安全规则
- Git 仓库操作（创建仓库、add、commit、push）必须先用 `clarify` 展示变更摘要并请求确认，不得自动执行
- 配置了 `git-human-confirmation` Skill

### 术语澄清
- "提交"：中文歧义词（git commit / WCB 提交 / 通用提交），上下文不明时先澄清再行动

### 笔记格式约束
- Daily note：简洁名词列表，不展开解释
- 不要 OpenAI 模型细节小节
- 不要问题/疑问小节
- 保持紧凑：短小节 + bullet list
