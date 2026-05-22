# LLM

+ 模型不能当作真相源
+ 输出应当落实为可检查的对象: schema / 参数 / 日志
+ 不确定性前移暴露: Prompt, RAG+相似度阈值检索(需要有自己的数据), 检查Agent工具调用的结果以此检查答案

## 与Web3的结合
**理解与生成**: 它负责把用户目标转成可讨论的计划，把复杂链上数据解释成人能读的语言，把文档和代码串成可执行思路。
Other 配合:
- 数据层：RPC、索引器、预言机、向量库、项目文档。
- 编排层：Prompt、Context、RAG、Agent workflow。
- 执行层：工具调用、钱包、Smart Account、合约交互。
- 安全层：Guard、simulation、权限策略、人工确认、日志。
# RAG (Retrieval-Augmented Generation)
+ 检索结果只是候选证据
+ 引用需要有明确来源
+ 检索失败需要拒绝回答
## 知识点
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
