# web3-wallet-setup

指导 Web3 初学者搭建测试钱包：安装 MetaMask、切换到 Sepolia 测试网、领取测试 ETH、在 Etherscan 验证。

## 适用场景

- Web3 课程的课前准备
- 从未用过加密钱包的新手
- AI/ML 开发者进入 Web3 学习

## 关键原则

1. 绝不要用户在 Mainnet 上真金白银 — 测试 ETH 是免费的
2. 测试钱包与主网钱包隔离 — 不同助记词、不同浏览器 Profile
3. 安全优先语言 — 在任何操作前解释私钥/助记词/钓鱼风险
4. 水龙头经常出问题 — 准备多个备选

## 步骤

### 1. 安装 MetaMask
metamask.io → 下载浏览器扩展

### 2. 创建钱包
走 MetaMask 引导流程（Create Wallet → Seed Phrase Backup → Done）

### 3. 切换到 Sepolia 测试网

手动添加（最可靠）：

| 字段 | 值 |
|------|-----|
| Network Name | Sepolia |
| RPC URL | https://rpc.sepolia.org |
| Chain ID | 11155111 |
| Symbol | ETH |
| Explorer | https://sepolia.etherscan.io |

### 4. 领取测试 ETH

| 水龙头 | 要求 |
|--------|------|
| https://sepolia-faucet.pk910.de | PoW，无需注册 |
| https://faucet.quicknode.com/ethereum/sepolia | GitHub 登录 |
| https://faucets.chain.link/sepolia | MetaMask 连接 |
| https://www.infura.io/faucet/sepolia | 邮箱注册 |

### 5. 验证
打开 `https://sepolia.etherscan.io/address/<钱包地址>` 确认余额和交易。

## 钱包-dApp 交互分类（Read / Sign / Write）

| 操作 | 类型 | Gas | 上链 | AI 自动 |
|------|------|-----|------|---------|
| 查看余额 | Read | 否 | 否 | ✅ |
| 连接钱包 | Config | 否 | 否 | ✅ |
| 切换网络 | Config | 否 | 否 | ✅ |
| 签名（非 Permit） | Sign | 否 | 否 | ⚠️ |
| Permit 签名 | Sign | 否 | 否 | 🔴 绝不 |
| 转账 ETH | Write | 是 | 是 | 🔴 绝不 |
| 授权 Token | Write | 是 | 是 | 🔴 绝不 |

## AI Agent 三不原则

1. 不碰私钥 — 用托管签名代替
2. 不替人批准 — 任何 approve/permit 需人工确认
3. 不替人转账 — 任何 >0 的转账需人工确认
