# 在 WSL + Clash TUN 模式下，git push 到 GitHub 可能因 gnutls_handshake 失败
# 解法：通过 Clash HTTP 代理推送
#
alias ghp='ALL_PROXY=http://192.168.144.1:7890 git push'

# 或者在仓库里配置持久化代理：
# git config http.proxy http://192.168.144.1:7890
