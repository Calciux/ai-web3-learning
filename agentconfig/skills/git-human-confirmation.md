# git-human-confirmation

Git 仓库操作必须人工确认：创建仓库、写文件、commit、push 等涉及变更的操作，在 git add/commit/push 前必须暂停等待用户确认。

## 核心规则

涉及以下操作时，必须暂停并等待用户明确确认，不得自动执行：
- 创建仓库 (git init / clone / fork)
- 写文件并加入版本控制 (git add)
- 提交 (git commit)
- 推送 (git push)
- 强制推送 (git push --force)
- 删除分支 (git branch -d / git push --delete)
- 重置历史 (git reset / rebase)
- 合并 PR (git merge)

## 确认方式

使用 `clarify` 工具，描述即将执行的操作，询问用户是否继续。

### 展示内容后再执行

用户说「可以提交」或「commit + push」后，不要立即执行。先使用 `read_file` 展示文件完整内容，让用户在行动前能最终确认。

### 「提交」歧义防护

当会话中同时涉及 git 操作和平台提交（如 WCB 作业提交）时，必须明确指明是哪种提交：
- ✅ "这份 daily note 可以 git commit + push 到 GitHub 吗？"
- ❌ "可以提交吗？" ← 歧义

涉及 git 变更的确认请求中，必须出现 "git" / "commit" / "push" 字样。

## 例外（不需人工确认）

- 读取文件内容（read_file / search_files）
- 查看 git 状态（git status / git log）
- 查看远程 URL（git remote -v）
- 配置 git 设置（git config）
- 推送前的验证性操作（git diff --stat）

## 快速执行模式

当用户说「我已确认好请直接执行」之后，如果后续还有连续的 git 操作（同一批变更），可以跳过重复的 confirm 步骤直接执行。
