# git-daily-notes

模板驱动的每日学习打卡笔记，存为 markdown 文件，commit 并 push 到 Git 仓库。

## 文件命名

`YYYY-MM-DD.md`（如 `2026-05-21.md`）

## 笔记模板

```
# 打卡 YYYY-MM-DD

## 今天做了什么
- 

## 学到的重点
- 

## 存在的问题 / 疑问
- 

## 明天计划
- 

## 投入时间
- XX 分钟
```

## 内容展开规则

1. 保留原标题，扩展正文
2. 使用结构化子段（表格、编号列表、对比图）
3. 针对学习者背景定制类比
4. 添加具体的项目/协议名称作为例子
5. 先讲"为什么"再讲"怎么做"
6. 加入问题/下一步环节

## Git 工作流

```
git add daily/<YYYY-MM-DD>.md
git commit -m "YYYY-MM-DD daily: <简述>"
git push
```

## 常见陷阱

- Git identity 未设置导致 commit 失败 → 先用 `git config user.name/email` 设置
- WSL HTTPS + 代理推送超时 → 切换到 SSH 远程
- 模板分歧 → 优先使用仓库本地的 README.md 定义的模板
