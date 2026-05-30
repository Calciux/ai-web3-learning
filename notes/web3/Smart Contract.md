# Exercise: 阅读合约
https://sepolia.etherscan.io/address/0x7b79995e5f793a07bc00c21412e50ecae098e7f9#code
+ name: WETH
+ 作用: 给ETH包装一层ERC-20使其具备标准接口供流通
## solidity 语法相关
+ event关键字: 发出log. 当某个动作发生时, 合约写一条记录到*receipt*中, 链下程序可以捕捉到, 通过**emit**关键字触发
+ 权限控制

| 关键字        | 谁能够调用     |
| ---------- | --------- |
| `external` | 仅能在合约外部调用 |
| `public`   | 任何人       |
| `internal` | 本合约和子合约   |
| `private`  | 本合约       |
+ `payable`: 可以接受ETH
+ `require`: 条件检查关键字. 
+ `view`: 声明只读, 不改变链上状态
## 合约内容
+ `deposit()` 
	注入ETH, 转成等量WETH
+ `receive()`
	调用合约函数需要明确指明函数(通过函数签名function selector). receive是一个兜底函数,不附带数据就默认触发这个函数, solidity要求关键字应该是```external payable```
	
+ `withdraw()`
	`require`:  前置的条件检查
+ `approve()`: 给别人授权(类似于"信用卡副卡")
+ `transfer()`
+ `transferFrom()`
+ `totalSupply()`:view关键字, 只读

## ABI
合约的说明书: 告诉合约有哪些函数/事件/参数类型/返回值

|                  |                                                                          |
| ---------------- | ------------------------------------------------------------------------ |
| 函数签名             | name/inputs/outputs                                                      |
| state mutability | view / payable / nonpayable                                              |
| event            | anonymous: false事件的名字会存入topic中, true可以省gas  / indexed: true的参数会被存入topic中 |
## 权限函数

| 函数(Function)    | 功能(Description)    | 存在的理由(Why It Exists)    | 风险(Risks)                    |
| --------------- | ------------------ | ----------------------- | ---------------------------- |
| owner / admin   | 合约的超级管理员地址         | 谁有特权一目了然                | 单点故障；owner 作恶或被攻击则全盘皆输       |
| mint            | 凭空增发代币给指定地址        | 项目方分配初始供应、激励机制          | 无限增发稀释用户；rug pull 常用手段       |
| burn            | 销毁指定数量的代币          | 通缩机制、减少流通量              | 风险较低（只减不增）                   |
| pause / unpause | 一键冻结/解冻所有转账        | 合约出漏洞时紧急避险              | 管理员可锁死用户资金                   |
| upgrade         | 替换合约逻辑为新代码         | 修复 bug、添加新功能            | 升级后可能引入恶意逻辑；approve 额度不会自动取消 |
| blacklist       | 封禁某个地址             | 合规要求（如 USDC 配合 OFAC 制裁） | 管理员可随意封禁任何人                  |
| setFee          | 调整手续费比例            | 项目方调整收入策略               | 可随时提高到 100%                  |
| withdrawToken   | 从合约中提取某代币余额（非用户存款） | 回收误转进合约的代币              | 可能被利用提取用户资金                  |
