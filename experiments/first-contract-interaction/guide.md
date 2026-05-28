# 测试网智能合约交互 — 步骤拆解

> 在 Sepolia 测试网上部署或调用一个最小智能合约。  
> 重点：理解合约地址、读取/写入、交易确认和链上验证之间的关系。

---

## 路径 B（推荐）：调用 Sepolia 上已部署的 WETH 合约

WETH 地址：`0x7b79995e5f793a07bc00c21412e50ecae098e7f9`

### 准备工作

1. 打开 Etherscan WETH 合约页面
2. 切到「Contract」→「Read Contract」/「Write Contract」标签
3. 点「Connect to Web3」连上你的 MetaMask（确保在 Sepolia 网络）

### Step 1：读取函数（不花钱、不签名）

4. 点 `balanceOf`，输入你的钱包地址
5. 点 Query → 看到当前 WETH 余额（应该是 0）
6. 再点 `totalSupply` → 看链上总 WETH 量
7. 再点 `decimals` / `symbol` → 验证返回值

### Step 2：低风险写入（deposit 极小金额）

8. 切到「Write Contract」标签
9. 找 `deposit` 函数
10. 在 MetaMask 里填 **0.0001 Sepolia ETH**（约 0.01 美元，极低风险）
11. 发起交易 → MetaMask 弹出确认框
12. 你人工审核：确认 to 地址是 WETH 合约、金额正确、Gas 合理
13. **人工点「确认」签名**
14. 等交易上链（~12 秒），拿到 tx hash

### Step 3：验证交易

15. 在 Etherscan 输入 tx hash，看 Transaction Details
16. 确认 Status = Success、看 Block 高度、Gas Used
17. 切到「Logs」标签，看 `Deposit` 事件被 emit 了
18. 返回 Read Contract → `balanceOf(你的地址)` → 应该显示 0.0001 WETH

### Step 4：withdraw 取回

19. 调 `withdraw`，输入 0.0001 WETH（单位 wei = 100000000000000）
20. 人工确认交易 → 等上链
21. balanceOf 变回 0，ETH 余额增加（扣掉 gas）

---

## 路径 A：部署自己的最小合约（用 Remix，浏览器操作）

### 准备工作

1. 打开 remix.ethereum.org
2. 删除默认文件，新建 `Simple.sol`
3. 写一个 5 行合约：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Simple {
    uint public value;
    function set(uint _v) public { value = _v; }
}
```

### 部署

4. 切到「Solidity Compiler」→ 点 Compile
5. 切到「Deploy & Run」
6. Environment 选 **Injected Provider - MetaMask**
7. MetaMask 确认连接，确保是 Sepolia 网络
8. 点「Deploy」→ MetaMask 弹出
9. **人工审核并确认**

### 验证

10. 部署成功后，Remix 底部出现合约实例
11. 点 `value` → 读取（应为 0）
12. 点 `set`，输入 42 → **人工确认交易** → 等上链
13. 再点 `value` → 应为 42
14. 复制合约地址，在 Sepolia Etherscan 搜索
15. 切到「Contract」→「Verify & Publish」→ 粘贴源码验证

---

## 两条路径对比

| | 路径 A（部署） | 路径 B（调用 WETH） |
|---|---|---|
| 需要装工具？ | 不需要（Remix 浏览器） | 不需要（Etherscan） |
| 学习范围 | 部署 + 读写 + 验证 | 读 + 写 + event 日志 |
| 认知收获 | 理解「合约地址从哪来」 | 理解「已部署合约如何交互」 |
| 难度 | 中 | 低 |

---

## ⚠️ 安全提醒

- 合约写入、钱包签名、授权和转账都必须 **人工确认**
- 只在 Sepolia 测试网上操作，不要切换到主网
- deposit 金额控制在 0.0001 ETH 以内，极低风险
