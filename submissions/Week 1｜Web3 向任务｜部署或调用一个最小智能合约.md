# Week 1 — Web3 向任务：部署或调用一个最小智能合约

> 完整实验记录见：[experiments/first-contract-interaction/lab-log.md](../experiments/first-contract-interaction/lab-log.md)

---

## 实验 1 — 部署最小合约

| 项目 | 内容 |
|------|------|
| **合约地址** | `0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB` |
| **区块浏览器** | https://sepolia.etherscan.io/address/0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB |
| **创建交易** | `0x0f7c85869ce5e1161c85b6e0e81135da1fece38204598e7643c1d114aeb5251d` |
| **验证方式** | Contract → Read Contract → `value` → Query → 返回 `42` |

---

## 实验 2 — 调用已部署合约的读取函数

### 2a. WETH 合约 — `balanceOf`

| 项目 | 内容 |
|------|------|
| **合约地址** | `0x7b79995e5f793a07bc00c21412e50ecae098e7f9` |
| **区块浏览器** | https://sepolia.etherscan.io/address/0x7b79995e5f793a07bc00c21412e50ecae098e7f9 |
| **读取函数** | `balanceOf(0x0EBbAbAeea0Db1e6552BF3f3e5F5DAA02858c28D)` |
| **结果** | `0.0001` WETH（deposit 后） |
| **验证方式** | Read Contract → `1. balanceOf` → 输入地址 → Query |

### 2b. Simple 合约 — `value`

| 项目 | 内容 |
|------|------|
| **合约地址** | `0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB` |
| **区块浏览器** | https://sepolia.etherscan.io/address/0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB |
| **读取函数** | `value()` |
| **结果** | `42` |
| **验证方式** | Read Contract → `1. value` → Query |

---

## 实验 3 — 调用低风险写入函数

### 3a. WETH — `deposit`（存入 0.0001 ETH）

| 项目 | 内容 |
|------|------|
| **目标合约** | `0x7b79995e5f793a07bc00c21412e50ecae098e7f9` |
| **区块浏览器** | https://sepolia.etherscan.io/tx/0x7aecd9ff4b3eaf8340c9e460d3e3af80eee2c934352ef6ac1450f20db2e229bd |
| **交易状态** | ✅ Success |
| **说明** | 存入 0.0001 ETH，收到等量 WETH；触发 `Deposit` 事件 |

### 3b. WETH — `transfer`（转 0.0005 WETH）

| 项目 | 内容 |
|------|------|
| **目标合约** | `0x7b79995e5f793a07bc00c21412e50ecae098e7f9` |
| **区块浏览器** | https://sepolia.etherscan.io/tx/0xeacd70125ceadca0d9550740fc2dff6d623b8c4022d8b24e4e6d19b195d5ab71 |
| **交易状态** | ✅ Success |
| **说明** | 发送方 WETH 余额减少，接收方 WETH 余额增加 |

### 3c. Simple — `set(42)`

| 项目 | 内容 |
|------|------|
| **目标合约** | `0xfd9e68338AdcFE961ddcbE6D15d4A5fE01043ceB` |
| **区块浏览器** | https://sepolia.etherscan.io/tx/0x627edd8557f430accfb27902c367ccdc9e1fb01566474880764b4a15e710a467 |
| **交易状态** | ✅ Success |
| **说明** | Input Data 中 `MethodID: 0x60fe47b1 (set(uint256))`，参数 `0x2a` = 42，`value()` 从 0 变为 42 |

---

## 验证方法

1. 打开任意一个区块浏览器链接
2. 对于读取函数：切到「Contract → Read Contract」标签，调对应函数
3. 对于写入函数：在交易页面确认 Status = Success，查看 Input Data 确认参数值
