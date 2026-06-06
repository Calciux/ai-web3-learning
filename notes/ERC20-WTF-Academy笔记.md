# ERC-20 代币标准 — WTF Academy 笔记

> 来源：https://www.wtf.academy/zh/course/solidity103/ERC20
> EIP 原文：EIP-20，2015年11月，Vitalik 参与

---

## 1. ERC-20 解决了什么问题

在 ERC-20 之前，每个项目发行代币都要自己写转账逻辑，钱包和交易所需要为每个代币定制适配代码。

ERC-20 标准化了代币合约必须实现的**函数名、参数、返回值、事件**。只要合约遵守这个接口，所有钱包、交易所、DeFi 协议都能直接识别和交互。

---

## 2. IERC20 接口

### 2 个事件

| 事件 | 触发时机 |
|------|----------|
| `Transfer(from, to, amount)` | 代币转移（mint 时 from=0x0，burn 时 to=0x0） |
| `Approval(owner, spender, amount)` | 授权某人支配你的代币 |

### 9 个函数

| 函数 | 作用 | 备注 |
|------|------|------|
| `totalSupply()` | 返回代币总供给 | |
| `balanceOf(account)` | 返回账户余额 | |
| `transfer(to, amount)` | 从调用者转账给 to | |
| `allowance(owner, spender)` | 返回授权额度 | |
| `approve(spender, amount)` | 授权 spender 支配你的代币 | 每次覆盖上一次额度 |
| `transferFrom(from, to, amount)` | spender 从 from 转给 to | 调用前需 approve |
| `name()` | 代币名称（如 WTF） | 可选 |
| `symbol()` | 代币代号（如 WTF） | 可选 |
| `decimals()` | 小数位数（默认 18） | 可选 |

---

## 3. 核心数据结构

```solidity
mapping(address => uint256) public override balanceOf;          // 账户→余额
mapping(address => mapping(address => uint256)) public override allowance; // owner→spender→额度
uint256 public override totalSupply;  // 总供给
string public name;                   // 名称
string public symbol;                 // 代号
uint8 public decimals = 18;           // 小数位数（18 是以太坊惯例）
```

- `balanceOf`、`allowance`、`totalSupply` 用 `public override` 声明，Solidity 自动生成同名 getter，正好满足 ERC-20 接口要求
- `decimals = 18` 是最常见的值，含义和 ETH 的 10^18 wei 一致

---

## 4. 关键函数实现逻辑

### transfer

```
调用方 balance -= amount
接收方 balance += amount
emit Transfer
```

土狗币常在这里魔改：加税收（扣一部分烧掉或转给项目方）、加分红、加抽奖。标准实现就是纯加减。

### approve

```
allowance[调用者][spender] = amount
emit Approval
```

**注意**：approve 是覆盖式赋值，不是累加。如果之前授权了 100，再 approve 50，结果就是 50。这会产生前端攻击（race condition），ERC-20 标准有个已知缺陷在这里。

### transferFrom

```
spender 调用此函数
require(allowance[from][spender] >= amount)
from 的 balance -= amount
to 的 balance += amount
allowance[from][spender] -= amount
emit Transfer
```

这就是 approve + transferFrom 的组合模式——你 approve Uniswap 1000 USDC，Uniswap 才能替你 transferFrom 走钱。**fund() 之前必须 approve 的道理就在这里。**

---

## 5. mint() 和 burn() — 不在标准中

教程里为了方便加了这两个函数，但它们**不是 ERC-20 标准的一部分**：

- `mint(amount)` — 增发代币。实际项目通常加 `onlyOwner` 限制
- `burn(amount)` — 销毁代币

标准 ERC-20 没有规定任何增发/销毁机制。所以有的代币总量固定（如 UNI 10 亿），有的可增发（如 USDT 被 Tether 随意铸造）。

---

## 6. 对我们的项目意味着什么

ERC-8183 Escrow 用 ERC-20 做支付代币。调用链：

```
1. Client approve(escrow合约地址, budget)   ← 授权 Escrow 支配你的代币
2. Client fund(jobId, budget)              ← Escrow 内部调 transferFrom 扣钱
3. Evaluator complete()                    ← Escrow 内部调 transfer 放款给 Provider
```

所以 ERC-20 的三个核心函数（approve / transferFrom / transfer）你都会在项目里用到。

---

## 7. 历史意义

> 2015年底提出的 ERC-20 代币标准极大降低了以太坊上发行代币的门槛，并开启了 ICO 大时代。

Vitalik 自己参与了 EIP-20 的起草。这个标准是 Ethereum 生态爆发的关键基础设施——标准统一后，任何人都能发币，任何钱包都能接。
