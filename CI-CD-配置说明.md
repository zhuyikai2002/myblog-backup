# 🚀 CI/CD 自动部署配置说明

## 📋 快速开始

现在你有 **两种部署方式**：

### 方式一：自动部署（推荐）⭐
```bash
git add .
git commit -m "更新文章"
git push
```
推送后，GitHub Actions 会自动：
1. ✅ 构建 Hexo 静态网站
2. ✅ 部署到 GitHub Pages
3. ✅ 部署到你的 VPS (`qzkj.ltd`)

### 方式二：手动部署（备用）
```bash
./deploy.sh
```
本地构建 + 快速上传到 VPS

---

## ⚙️ 首次配置（重要！）

### 1️⃣ 在 VPS 上生成 SSH 密钥对

在你的本地电脑上执行：

```bash
# 生成专用于 GitHub Actions 的密钥
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_actions_deploy

# 查看私钥（稍后要用）
cat ~/.ssh/github_actions_deploy

# 查看公钥
cat ~/.ssh/github_actions_deploy.pub
```

### 2️⃣ 将公钥添加到 VPS

```bash
# 复制公钥到 VPS（替换 myvps 为你的 SSH 别名或 IP）
ssh-copy-id -i ~/.ssh/github_actions_deploy.pub myvps

# 或者手动添加：登录 VPS 后执行
echo "刚才复制的公钥内容" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### 3️⃣ 在 GitHub 仓库配置 Secrets

进入你的 GitHub 仓库：
```
Settings → Secrets and variables → Actions → New repository secret
```

添加以下 4 个 Secrets：

| Secret 名称 | 值 | 说明 |
|------------|-----|------|
| `VPS_HOST` | `你的VPS IP或域名` | 例如：`123.45.67.89` 或 `qzkj.ltd` |
| `VPS_USER` | `root` 或其他用户名 | SSH 登录用户 |
| `VPS_DEPLOY_PATH` | `/var/www/html/blog/` | VPS 上的部署目录 |
| `VPS_SSH_KEY` | `第1步生成的私钥全部内容` | 从 `-----BEGIN` 到 `-----END` 的完整内容 |

**重要提示：**
- `VPS_SSH_KEY` 要复制 **私钥**（`~/.ssh/github_actions_deploy`）的全部内容
- 包括开头的 `-----BEGIN OPENSSH PRIVATE KEY-----` 和结尾的 `-----END OPENSSH PRIVATE KEY-----`

### 4️⃣ 测试部署

```bash
# 提交一个测试文件
echo "测试 CI/CD" > test.txt
git add test.txt
git commit -m "test: CI/CD 自动部署"
git push
```

然后访问：
- **GitHub Actions 页面**：查看构建日志
  ```
  https://github.com/你的用户名/myblog-backup/actions
  ```
- **你的网站**：验证部署结果
  ```
  https://qzkj.ltd/blog/
  ```

---

## 🔍 常见问题

### Q1: GitHub Actions 失败，提示 SSH 连接错误？
**原因：** SSH 密钥配置不正确

**解决：**
1. 检查 `VPS_SSH_KEY` 是否复制了完整的私钥（包括开头和结尾）
2. 确认公钥已添加到 VPS 的 `~/.ssh/authorized_keys`
3. 在本地测试 SSH 连接：
   ```bash
   ssh -i ~/.ssh/github_actions_deploy myvps
   ```

### Q2: rsync 失败，提示权限错误？
**原因：** VPS 用户没有目标目录的写权限

**解决：**
```bash
# 登录 VPS，修改目录权限
ssh myvps
sudo chown -R $USER:$USER /var/www/html/blog/
chmod 755 /var/www/html/blog/
```

### Q3: 手动部署脚本 `./deploy.sh` 失败？
**可能原因：**
- 没有执行权限：`chmod +x deploy.sh`
- SSH 配置名 `myvps` 不存在：检查 `~/.ssh/config`

### Q4: 如何只更新文章，不触发 VPS 部署？
**临时禁用：** 在 commit 消息中添加 `[skip ci]`
```bash
git commit -m "[skip ci] 更新草稿"
git push
```

---

## 🎯 优化效果对比

| 操作 | 旧方案（deploy.sh） | 新方案（CI/CD） |
|------|-------------------|----------------|
| 本地构建 | ✅ 需要 | ❌ 不需要 |
| 构建时间 | 本地 2-3 分钟 | GitHub 服务器并行 |
| 网络依赖 | 高（上传全部文件） | 低（只推送源码） |
| 多设备支持 | 差（需配置环境） | 好（任意设备 git push） |
| 失败重试 | 手动 | 自动 |
| 部署日志 | 本地终端 | GitHub Actions 永久保存 |

**预计提速：** 从本地 3 分钟 → 推送后自动完成（你无需等待）

---

## 📚 进阶配置

### 自定义触发条件

编辑 `.github/workflows/deploy.yml`：

```yaml
on:
  push:
    branches:
      - main
    paths:  # 只在这些文件变化时触发
      - 'source/**'
      - '_config*.yml'
      - 'themes/**'
```

### 定时自动重建

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # 每天凌晨 2 点重建
```

### 添加构建通知

推荐使用 [GitHub Actions Status Badge](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/adding-a-workflow-status-badge)：

```markdown
[![Deploy](https://github.com/你的用户名/myblog-backup/actions/workflows/deploy.yml/badge.svg)](https://github.com/你的用户名/myblog-backup/actions/workflows/deploy.yml)
```

---

## 🔒 安全建议

1. **定期更换 SSH 密钥**（每 6 个月）
2. **VPS 上禁用密码登录**，只允许密钥登录
   ```bash
   # /etc/ssh/sshd_config
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```
3. **GitHub Secrets 定期审计**
4. **最小权限原则**：为部署创建专用的非 root 用户

---

## 📞 需要帮助？

- **GitHub Actions 日志**：`https://github.com/你的用户名/myblog-backup/actions`
- **测试命令**：
  ```bash
  # 本地测试 SSH 连接
  ssh -i ~/.ssh/github_actions_deploy myvps "ls -la /var/www/html/blog/"
  
  # 本地测试 rsync
  rsync -avzn --delete public/ myvps:/var/www/html/blog/
  ```

---

**🎉 配置完成后，享受自动化部署的快乐吧！**
