CAW 接入方案

    接什么

    接入 Cobo Agentic Wallet（CAW） 的 MPC 钱包能力，通过 caw CLI 让 Agent 获得链上资金操作能力：

    接入点: CLI
    具体内容: caw binary，路径 ~/.cobo-agentic-wallet/bin/caw
    ────────────────────────────────────────
    接入点: 环境
    具体内容: Dev 环境，API: https://api-core.agenticwallet.dev.cobo.com
    ────────────────────────────────────────
    接入点: 网络
    具体内容: Sepolia 测试网（chain_id: SETH）
    ────────────────────────────────────────
    接入点: 核心操作
    具体内容: caw pact submit（提交授权）、caw tx call（合约调用）、caw tx
      transfer（转账）

    怎么接

    Agent 通过 Python subprocess 调用 caw CLI，分三层：

    第 1 层 — 钱包就绪（已完成）


    caw onboard → MPC 钱包创建
    caw wallet pair → App 配对 → 人类审批权限
    caw faucet deposit → 领 Sepolia 测试币


    第 2 层 — Pact 授权

    bash
    Agent 构造 policies + completion_conditions，提交 Pact
    caw pact submit \
      --name "ERC-8183 Fund Job" \
      --policies '<contract_call + transfer policies>' \
      --completion-conditions '[{"type":"tx_count","threshold":"2"}]' \
      --execution-plan "1. fund() escrow  2. transfer bounty"


    第 3 层 — 执行链上操作

    bash
    编码 calldata
    CALLDATA=$(caw util abi encode \
      --method "fund(uint256,uint256)" \
      --args '["<jobId>","<budget>"]' | jq -r .calldata)

    调用 ERC-8183 合约
    caw tx call \
      --pact-id <pact-id> \
      --chain-id SETH \
      --contract <ERC-8183合约地址> \
      --calldata "$CALLDATA" \
      --value 0.001 \
      --request-id erc8183-fund-001


    Python Agent 侧的封装：

    python
    import subprocess, json

    def caw(*args):
        result = subprocess.run(
            ["caw", *args],
            env={"PATH": f"{HOME}/.cobo-agentic-wallet/bin:{HOME}/.local/bin:$PATH",
                 "HTTPS_PROXY": "http://192.168.144.1:7890"},
            capture_output=True, text=True
        )
        return json.loads(result.stdout)

    def fund_job(pact_id: str, contract_addr: str, job_id: str, budget: str):
        calldata = caw("util", "abi", "encode",
                       "--method", "fund(uint256,uint256)",
                       "--args", json.dumps([job_id, budget]))
        return caw("tx", "call",
                   "--pact-id", pact_id,
                   "--chain-id", "SETH",
                   "--contract", contract_addr,
                   "--calldata", calldata["calldata"],
                   "--value", budget,
                   "--request-id", f"fund-{job_id}")


    Week 4 是否能做完

    能。 已完成的准备工作大幅缩短了剩余工期：

    | 已完成                        | 剩余                              |
    |-------------------------------|-----------------------------------|
    | ✅ caw CLI 安装               | 🔲 写 ERC-8183 合约 + 部署        |
    | ✅ MPC 钱包创建（已 active）  | 🔲 构造 Pact（policies 模板已有） |
    | ✅ App 配对                   | 🔲 Pact 提交 → App 审批 → 执行    |
    | ✅ Sepolia 测试币到账         | 🔲 Python 脚本封装                |
    | ✅ Pact Policy 完整文档已阅读 | 🔲 Demo 流程录制                  |

    剩余工作估算：合约开发 1-2 天，CAW 集成半天（Pact 模板已定），Python 封装半天。Week 4 完全可完成。

    Fallback

    如果 CAW 接入在截止前出问题（网络、API 变更、TSS 节点故障），fallback 分两级：

    Fallback A — 轻量降级（推荐）

    用 EOA 钱包（私钥） 替代 CAW 执行合约调用，但 Pact 授权流程用截图/日志演示，证明 CAW 能完成权限控制。Demo 时说明：

    > "CAW 已完成钱包创建和 Pact 授权，链上调用暂用 EOA 执行以保障 Demo 稳定性。CAW 的 Pact 日志和权限记录已附上。"

    代码侧只需将 caw tx call 替换为 web3.py 的 contract.functions.fund().transact()，改动量小。

    Fallback B — 硬降级

    全程用 EOA 钱包 + web3.py 完成链上操作，CAW 作为架构图中的组件出现，在 README 中说明集成方案和已完成进度（钱包创建、配对、余额、Pact policy 模板），标注 future work: CAW integration。


    结论：CAW 接入风险低，已完成 70% 准备工作的基础设施。 Fallback 仅做演示降级，不影响链上流程的正确性。
