# 🚀 GitHub Actions VPS自动部署配置指南

## 📋 配置步骤

### 步骤1：获取VPS信息

需要准备的信息：
- **VPS_HOST**: VPS的IP地址或域名
- **VPS_USER**: SSH用户名（通常是 `root`）
- **VPS_SSH_KEY**: SSH私钥内容

### 步骤2：准备SSH密钥

#### 方案A：使用现有SSH密钥

```bash
# 查看现有私钥
cat ~/.ssh/id_rsa
# 或
cat ~/.ssh/id_ed25519

# 复制私钥的全部内容（包括 -----BEGIN 和 -----END 行）
```

#### 方案B：生成新的SSH密钥（推荐）

```bash
# 生成专用于GitHub Actions的密钥
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_actions_deploy

# 查看私钥（稍后要添加到GitHub Secrets）
cat ~/.ssh/github_actions_deploy

# 查看公钥（需要添加到VPS）
cat ~/.ssh/github_actions_deploy.pub
```

#### 将公钥添加到VPS

```bash
# 方法1：使用ssh-copy-id（推荐）
ssh-copy-id -i ~/.ssh/github_actions_deploy.pub myvps

# 方法2：手动添加
# 先复制公钥内容，然后登录VPS执行：
# echo "公钥内容" >> ~/.ssh/authorized_keys
# chmod 600 ~/.ssh/authorized_keys
```

### 步骤3：在GitHub配置Secrets

1. 访问GitHub仓库的Secrets设置：
   ```
   https://github.com/zhuyikai2002/myblog-backup/settings/secrets/actions
   ```

2. 点击 **"New repository secret"**，依次添加以下3个Secrets：

   | Secret名称 | 值 | 说明 |
   |------------|-----|------|
   | `VPS_HOST` | 你的VPS IP或域名 | 例如：`209.54.107.14` 或 `qzkj.ltd` |
   | `VPS_USER` | SSH用户名 | 通常是 `root` |
   | `VPS_SSH_KEY` | SSH私钥完整内容 | 从 `-----BEGIN` 到 `-----END` 的全部内容 |

   **重要提示**：
   - `VPS_SSH_KEY` 要复制**私钥**的全部内容
   - 包括开头的 `-----BEGIN OPENSSH PRIVATE KEY-----`
   - 和结尾的 `-----END OPENSSH PRIVATE KEY-----`
   - 所有行都要复制，保持格式不变

### 步骤4：提交配置更改

```bash
cd /home/rik/myblog
git add .github/workflows/deploy.yml
git commit -m "feat: 添加VPS自动部署到GitHub Actions"
git push origin main
```

### 步骤5：测试部署

1. 推送代码后，访问GitHub Actions页面：
   ```
   https://github.com/zhuyikai2002/myblog-backup/actions
   ```

2. 查看最新的workflow运行状态
   - ✅ 绿色 = 成功（已部署到GitHub Pages和VPS）
   - ❌ 红色 = 失败（查看日志找问题）

3. 访问VPS查看是否更新：
   ```
   https://qzkj.ltd/blog/
   ```

## 🔍 故障排查

### 如果部署失败

1. **检查SSH密钥格式**
   - 确保私钥包含完整的 `-----BEGIN` 和 `-----END` 行
   - 确保没有多余的空白行

2. **检查VPS连接**
   ```bash
   ssh -i ~/.ssh/your_key your_user@your_vps_ip
   ```

3. **检查GitHub Actions日志**
   - 点击失败的workflow运行
   - 查看 "Deploy to VPS" 步骤的日志
   - 查找错误信息

4. **常见错误**
   - `Permission denied`: SSH密钥未正确配置
   - `Host key verification failed`: 首次连接需要确认（已自动处理）
   - `No such file or directory`: 目标路径不存在

## ✅ 配置完成后

配置完成后，以后发布博客只需要：

```bash
git add .
git commit -m "feat: 更新博客"
git push origin main
```

GitHub Actions会自动：
1. ✅ 构建静态网站
2. ✅ 部署到GitHub Pages
3. ✅ 部署到VPS (`qzkj.ltd/blog/`)

完全自动化！🎉
