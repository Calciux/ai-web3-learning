# 实验记录：WETH 合约交互

> 合约地址：`0x7b79995e5f793a07bc00c21412e50ecae098e7f9`  
> 网络：Sepolia 测试网  
> 日期：2026-05-28

---

## Step 1：Read Contract — 只读查询

### 操作

1. 打开 [WETH 合约页面](https://sepolia.etherscan.io/address/0x7b79995e5f793a07bc00c21412e50ecae098e7f9)
2. 切换「Contract」→「Read Contract」
3. 点「Connect to Web3」，连上 MetaMask（Sepolia 网络）
4. 找 `balanceOf`，输入钱包地址，点 Query

### 结果

![Step 1 截图](step1-result.png)

### 理解

- Read Contract 调用的是合约里 `view` 修饰的函数
- EVM 执行了代码，但没有花 gas、没有改链上状态、不需要签名
- balanceOf 返回 0 — 还没往 WETH 里存过 ETH

---

## Step 2：Write Contract — deposit 存入 ETH

### 操作

1. 切换「Contract」→「Write Contract」
2. 找到 `1. deposit` 函数（payable，无输入参数）
3. 在 payableAmount 填 `0.0001` ETH
4. 点 Write → MetaMask 弹出 → 人工审核后确认

### 交易信息

- **Tx Hash**：`0x7aecd9ff4b3eaf8340c9e460d3e3af80eee2c934352ef6ac1450f20db2e229bd`
- 函数选择器：`0xd0e30db0` = `keccak256("deposit()")` 前 4 字节

### 截图记录

**Pending 状态：**
![pending](step2-pending.png)

**Success 状态：**
![success](step2-success.png)

**余额验证（balanceOf）：**
![balanceOf 结果](step2-balanceOf.png)

**事件日志（Deposit 事件）：**
![logs](step2-logs.png)

### 理解

- `deposit` 是 payable 函数，ETH 作为交易的 value 附送，不是填在函数参数里
- 函数选择器 `0xd0e30db0` ≠ 合约地址，只是 keccak256 哈希的前 4 字节
- 交易经历了 pending → success，确认后状态上链
- Logs 中 emit 了 `Deposit` 事件，链下可捕捉
- balanceOf 从 0 变成 0.0001 WETH — ETH 已被包装成 ERC-20

### Logs 中 Address 与 Tx Hash 的区别

| 字段 | 值（示例） | 含义 |
|------|-----------|------|
| Tx Hash | `0x7aecd9ff...29bd` | 这笔交易的身份证号，全球唯一 |
| Address | `0x7b79995e...E7f9` | WETH 合约地址，所有跟 WETH 的交互都指向它 |

Logs 面板的结构：

```
Address     0x7b79995e5f793a07bc00c21412e50ecae098e7f9    ← 日志来源合约（永远指向 WETH）
Name        Deposit (index_topic_1 address dst, uint256 wad)
Topics[0]   0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c
            ↑ keccak256("Deposit(address,uint256)") — 事件签名哈希
Topics[1]   0x0EBbAbAeea0Db1e6552BF3f3e5F5DAA02858c28D
            ↑ dst（indexed 参数，你的地址）
Data        1000000000000000
            ↑ wad = 0.001 ETH（单位 wei，非 indexed 参数）
```

类比：你在 ATM 存钱，Tx Hash = 小票流水号（每笔唯一），Address = ATM 编号（固定不变）。不同人存钱 Logs 里的 Address 相同，但 Tx Hash 不同。
