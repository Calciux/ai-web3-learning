Cobo Agentic Wallet (CAW) — Sponsor 能力总结

    解决什么问题

    AI Agent 需要链上花钱、收款、管资金，但直接给 Agent 一把私钥 = 裸奔。

    CAW 解决的核心矛盾：Agent 需要资产操作能力 vs 人类需要对 Agent 的资金行为保持控制。

    具体解决三个问题：


    问题 1：Agent 拿到私钥后，被 prompt injection 攻击怎么办？
           → MPC 分片 + Pact 白名单，Agent 没有完整私钥也无法越界

    问题 2：Agent 乱花钱怎么办？
           → Pact 单笔限额 + 日限额 + 到期自动撤销，超额直接拒绝

    问题 3：Agent 操作怎么审计？
           → 每笔操作人在 App 弹窗审批，全链路有日志可追溯




    提供什么工具

    层级: CLI
    工具: caw binary
    说明: 钱包创建、Pact 提交、转账、合约调用
    ────────────────────────────────────────
    层级: App
    工具: Cobo Agentic Wallet App
    说明: 人类审批 Pact + 交易确认
    ────────────────────────────────────────
    层级: Skill
    工具: cobo-agentic-wallet-dev
    说明: Agent 侧集成指令（policies 格式、操作流程）
    ────────────────────────────────────────
    层级: API
    工具: REST API
    说明: 所有 CLI 操作均可通过 API 调用
    ────────────────────────────────────────
    层级: SDK
    工具: Python / TypeScript
    说明: API 封装，可直接嵌入 Agent 代码
    ────────────────────────────────────────
    层级: Recipe
    工具: 策略模板
    说明: Uniswap/Aave/Jupiter 等 DeFi 操作的预制参数和合约地址



    适合哪个赛道

    Cobo 赛道 02 — Trustless Agent Work Agreements

    更具体地说，任何需要 Agent 管钱 + 人审计 + 链上执行 的场景都适合：

    场景: Agent 间任务外包（我们的项目）
    CAW 角色: Client Agent 用 CAW fund 托管资金，Provider Agent 用 CAW 收报酬
    ────────────────────────────────────────
    场景: Agent 自动支付
    CAW 角色: 达到条件后通过 Pact 自动转账
    ────────────────────────────────────────
    场景: Agent DeFi 操作
    CAW 角色: 在 Pact 限额内调 Uniswap/Aave 做 swap/借贷
    ────────────────────────────────────────
    场景: Agent 竞价/拍卖
    CAW 角色: 竞价结束后最高价 Agent 自动支付



    可以做什么 Demo

    最小可行 Demo（30 分钟可录完）：


    场景：Client Agent 发包 → Provider Agent 接单 → 自动付款

    Step 1: caw wallet current → 展示 Agent 钱包地址和余额
    Step 2: caw pact submit → 提交 ERC-8183 fund() 授权
    Step 3: App 弹窗 → 人批准 Pact
    Step 4: caw tx call → 调 ERC-8183.fund()，锁 0.001 ETH 进 Escrow
    Step 5: caw tx get → 展示交易 confirmed，链上 tx hash 可查
    Step 6: Evaluator complete → 合约放款，Provider 收到报酬
    Step 7: caw wallet balance → 展示余额变化


    Demo 亮点：

    - 评委能看到 Agent 自主发起 Pact → 人 App 审批 → 链上 真实执行 → 余额变化
    - 不是模拟，是真金白银（虽然是测试网 ETH）
    - Pact 权限边界清晰可见（policies 展示 + App 截图）
    - 全程有 tx hash 可查 Sepolia Etherscan，链上不可造假
