# web3-fundamentals

帮助 AI 背景用户学习 Web3 基础：钱包搭建、测试网工作流、Read/Sign/Write 交互分类、AI Agent 链上操作安全边界。

## 适用场景

- 搭建测试钱包（MetaMask、测试网）
- 钱包-dApp 交互原理（连接、签名、发送）
- 哪些操作改变链上状态
- AI Agent 与区块链钱包集成
- 交易、Gas、签名、Etherscan 的理解

## 钱包搭建流程

见 web3-wallet-setup skill。

## Read / Sign / Write 分类

这是 Web3 新手最有用的思维模型：

### Read — 无签名、无 Gas、无状态变更
- `eth_getBalance`、`eth_call`（view/pure 函数）
- AI Agent 可安全自动化

### Config — 本地元操作
- `eth_requestAccounts`、`wallet_switchEthereumChain`
- 无链上状态变更，无 Gas
- AI Agent 可自动化，但用户需验证 Chain ID 和 RPC URL

### Sign — 私钥签名数据，不上链
- `personal_sign`、`eth_signTypedData_v4`（EIP-712）
- 无链上状态变更，无 Gas
- 危险：Permit（EIP-2612）签名可授权代币支出
- AI Agent 绝不能盲签

### Write — 签名 + 广播，改变链上状态
- `eth_sendRawTransaction`（转账、兑换、批准、部署）
- 消耗 Gas，改变 EVM 状态
- AI Agent 绝不能自主发送交易

## 交易结构

```
Transaction = {
    from, to, value, data, nonce,
    gas, maxFeePerGas, maxPriorityFeePerGas, chainId
}
Gas fee = GasUsed × (baseFee + priorityFee)
```

## 常见陷阱

1. MetaMask 的"显示测试网络"经常换位置
2. Permit 钓鱼 — EIP-2612 签名看似无害但授权代币支出
3. 学员混淆 Sign 与 Write
4. 测试网 ≠ 主网安全性
5. Gas 估算混淆
6. AI Agent 盲目信任 — ML 用户倾向信任模型输出
