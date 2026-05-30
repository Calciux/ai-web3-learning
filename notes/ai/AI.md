# LLM
 是一个基于海量文本预训练的概率生成模型，根据输入预测并输出合理文本。
+ 模型不能当作真相源
+ 输出应当落实为可检查的对象: schema / 参数 / 日志
+ 不确定性前移暴露: 方法:Prompt, RAG+相似度阈值检索(需要有自己的数据), 检查Agent工具调用的结果以此检查答案

## 与Web3的结合
**理解与生成**: 它负责把用户目标转成可讨论的计划，把复杂链上数据解释成人能读的语言，把文档和代码串成可执行思路。
Other 配合:
- 数据层：RPC、索引器、预言机、向量库、项目文档。
- 编排层：Prompt、Context、RAG、Agent workflow。
- 执行层：工具调用、钱包、Smart Account、合约交互。
- 安全层：Guard、simulation、权限策略、人工确认、日志。
# RAG (Retrieval-Augmented Generation)
RAG 是一种在生成前先从外部知识库检索相关文本，再将检索结果作为上下文提供给 LLM 的技术范式，用于弥补模型自身知识不足和时效性问题。
+ 检索结果只是候选证据
+ 引用需要有明确来源
+ 检索失败需要拒绝回答

+ chunking: 长文档切片. 需要注意跨段落出现的内容该如何切分
+ 向量数据库: 检索相近语义内容. *Metadata: 来源/版本/时间/可用性等内容, 检索时需要过滤*
+ embedding: embedding是encoder的输出.
	+ Architecture: BERT / transformer encoder / etc.
	+ Training method: contrastive learning / masked language model /...
	+ Optimization: Matryoshka Representation / distillation
+ Retriever: 取回候选材料. *需要根据metadata之类的限制条件进行搜索*
+ Rerank / Citation

## 能为Web3带来什么
- 协议文档问答
- 合约接口解释
- 治理提案和论坛摘要
- 审计报告检索
- SDK / API Copilot
- 交易解释时补充项目背景

当 RAG 结果要影响链上动作时，还需要接 simulation、policy 和 human check
# Prompt
**Prompt提高概率, 而非确保边界.** 边界必须由代码、权限、校验和审计确定.
误区：认为 prompt 越详细越好。实际上过长的 prompt 会增加推理噪音，关键是把角色、目标、输入、约束、输出格式五要素写清楚即可，不需要事无巨细。
## 优化方式
+ character / task 分离: 整体风格/角色放到system message, 具体任务和示例放到user message
+ Few-Shot 的格式化
+ 清晰的目录结构
+ 关联eval(衡量prompt好坏的自动化测试)
## Instruction
+ 区分角色: 解释与执行
+ 任务目标+可用输入+禁止行为+输出格式
+ Few-Shot: 提供给模型的输出风格示例. 是需要维护更新的
+ Structure output

## Prompt Engineering

+ 根据model选择策略: Reasoning模型适当信任推理能力 / 推理能力弱的模型需要精确, 显式的指令 / 生产环境需要固定到model的具体快照, 防止产生不同行为
+ 用.md组织prompt, 用XML标签包裹外部数据(比如文档, 示例等)
+ 重复使用的内容前置以充分利用caching(caching基于前缀匹配)
+ 提供完整的输入输出示例: 正例反例 / 边界情况
对于coding场景:
+ 定义明确的character和workflow
+ 要求模型写unit test
+ 给出具体的工具调用示例
+ 明确输出格式标准
# MCP 模型上下文协议
**Agent**向外界连接的工具接口标准, 通过协议access被授权的上下文和工具

| Server(暴露特定功能的外部服务) | Client(Agent应用本身)               |
| ------------------- | ------------------------------- |
| 暴露工具                | 工具发现/调用                         |
| 处理请求                | 连接管理(管理Server的生命周期)             |
| 声明自己的能力             | 结果整合(将Server的返回重新输入LLM上下文中继续推理) |
+ Tool Schema: 描述工具的用途/参数/返回/约束, **确保模型正确调用工具**
+ Permission: 安全

# Guardrails
两道安检: 输入拦截malicious/越界请求, filter/改写不合格输出
是硬约束: 无法绕过, 强制执行, 在代码层独立运行
examples: 
| 场景          | Guardrails 应用                   |
|---------------|-----------------------------------|
| 链上交易      | 拦截 "把私钥粘贴进来" 的请求       |
| 智能合约生成  | 确保生成的合约代码符合 ERC 标准    |
| DeFi 分析助手 | 不允许模型建议具体仓位/杠杆倍数    |
| 用户数据      | 拦截钱包地址、交易哈希等 PII 泄露 |
# Vibe Coding

**只是加速工程中的步骤, 需要更清楚地管理repo/上下文/测试/审查/版本控制**: 任务/context/验证测试
 AI 生成的代码只是初稿，仍然需要人工审查安全性、边界情况和可维护性。Vibe Coding 加速的是编码环节而非取代工程流程。