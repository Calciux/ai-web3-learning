# 项目流程图 — ERC-8183 × CAW 全链路

```mermaid
flowchart TD
    subgraph 人类["👤 人类 Owner"]
        H1[审查 Pact policies + 金额 + 合约]
        H2[App 批准或拒绝]
        H3[事后审计链上记录]
    end

    subgraph Agent["🤖 Client Agent"]
        A1[构造 Pact]
        A2[提交 Pact 到 CAW]
        A3[caw tx call → 调 ERC-8183 fund]
    end

    subgraph CAW["🔐 Cobo Agentic Wallet"]
        C1[MPC 钱包]
        C2[Policy 引擎校验]
        C3[TSS 节点协同签名]
    end

    subgraph Contract["📜 ERC-8183 Escrow"]
        E1[fund → 资金锁入 Escrow]
        E2[Evaluator 提交裁决]
        E3[complete → 放款给 Provider]
        E4[cancel → 退款给 Client]
    end

    subgraph Provider["🤖 Provider Agent"]
        P1[接单执行任务]
        P2[提交交付物]
        P3[收到报酬]
    end

    subgraph Evaluator["⚖️ Evaluator"]
        V1[检查交付物]
        V2[评分 checklist]
        V3[提交 accept 或 reject]
    end

    A1 --> A2
    A2 --> H1
    H1 --> H2
    H2 -->|批准| C1
    C1 --> C2
    C2 -->|通过| C3
    C3 --> A3
    A3 --> E1
    E1 --> P1
    P1 --> P2
    P2 --> V1
    V1 --> V2
    V2 --> V3
    V3 -->|accept| E2
    V3 -->|reject| E4
    E2 --> P3
    H3 -.-> E1
    H3 -.-> E4
    H3 -.-> E2
```

## 关键边界标注

| 步骤 | 谁控制 | 谁能干预 | 不可逆点 |
|------|--------|----------|----------|
| Pact 提交 | Agent | — | — |
| Pact 审批 | 人类 Owner | Owner 可拒 | 批准后 Agent 获得范围授权 |
| Policy 校验 | CAW 引擎 | 无人可绕过 | 越界交易在此被拒绝 |
| TSS 签名 | CAW 节点 | 无人单方可控 | — |
| fund() | Agent | Agent 只能 fund，不能撤 | 资金锁入合约 |
| Evaluator 裁决 | Evaluator | Owner 可事后介入争议 | 放款后不可逆 |
| complete() | 合约逻辑 | 仅 Evaluator | ✅ 最终结算 |
| cancel() | 合约逻辑 | 仅 Evaluator | ✅ 资金退回 |

## 信任假设

- CAW MPC 节点诚实（Cobo 运维）
- ERC-8183 合约无漏洞（代码审计假设）
- Evaluator 判断正确（单点信任，已知局限）
- 人类 Owner 及时审批 Pact
