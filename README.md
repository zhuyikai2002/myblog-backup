# 🚀 Rik 的极客笔记

[![Deploy Status](https://github.com/zhuyikai2002/myblog-backup/actions/workflows/deploy.yml/badge.svg)](https://github.com/zhuyikai2002/myblog-backup/actions)

基于 Hexo + Butterfly 主题的个人博客，支持 GitHub Actions 自动部署到 VPS。

## 🌐 在线访问

| 站点 | 地址 |
|------|------|
| 🏠 主页 | [qzkj.ltd](https://qzkj.ltd) |
| 📝 博客 | [qzkj.ltd/blog](https://qzkj.ltd/blog/) |
| 👤 关于 | [qzkj.ltd/about](https://qzkj.ltd/about/) |
| 🧪 实验室 | [qzkj.ltd/lab](https://qzkj.ltd/lab/) |
| 🔄 备用 | [GitHub Pages](https://zhuyikai2002.github.io/myblog-backup/) |

## ✨ 特色功能

- **终端模拟器主页** - 输入 `cd /blog`、`cd /about`、`cd /lab` 跳转
- **自动化部署** - Git push 后自动构建并部署到 VPS
- **双重备份** - 同时部署到 VPS 和 GitHub Pages
- **CRT 视觉效果** - 复古终端风格，扫描线 + 屏幕闪烁

## 📁 项目结构

```
myblog-backup/
├── source/                  # 源文件目录
│   ├── _posts/              # 博客文章 (Markdown)
│   ├── about/               # 关于页面
│   ├── lab/                 # 实验室页面
│   └── homepage/            # 终端模拟器主页 ⭐
├── themes/                  # Hexo 主题 (Butterfly)
├── scripts/                 # 自定义脚本
│   └── vps-init.sh          # VPS 一键初始化脚本
├── nginx/                   # Nginx 配置模板
│   └── myblog.conf          # 站点配置
├── .github/workflows/       # GitHub Actions
│   └── deploy.yml           # 自动部署工作流
├── _config.yml              # Hexo 主配置
├── _config.butterfly.yml    # Butterfly 主题配置
└── deploy.sh                # 本地快速部署脚本（备用）
```

## 🚀 日常使用

### 发布文章（最常用）

```bash
# 1. 创建新文章
hexo new post "文章标题"

# 2. 编辑文章
vim source/_posts/文章标题.md

# 3. 推送发布（自动触发部署）
git add .
git commit -m "feat: 添加新文章"
git push
```

**完成！** GitHub Actions 会在 3-5 分钟内自动部署。

### 本地预览

```bash
npm install          # 首次运行需要安装依赖
hexo server          # 启动本地服务器
# 访问 http://localhost:4000/blog/
```

### 查看部署状态

访问 [GitHub Actions](https://github.com/zhuyikai2002/myblog-backup/actions) 查看部署进度。

- ✅ 绿色 = 成功
- ❌ 红色 = 失败（点击查看日志）

## 🖥️ VPS 部署

### 方式一：一键初始化（推荐）

VPS 重装系统后，只需一条命令：

```bash
curl -fsSL https://raw.githubusercontent.com/zhuyikai2002/myblog-backup/main/scripts/vps-init.sh | sudo bash
```

### 方式二：手动部署

```bash
# 1. 安装 Nginx
sudo apt update && sudo apt install -y nginx

# 2. 创建目录
sudo mkdir -p /var/www/myblog/public /var/www/homepage
sudo chown -R www-data:www-data /var/www

# 3. 下载 Nginx 配置
sudo curl -o /etc/nginx/conf.d/myblog.conf \
  https://raw.githubusercontent.com/zhuyikai2002/myblog-backup/main/nginx/myblog.conf

# 4. 配置 SSL（可选）
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d qzkj.ltd -d www.qzkj.ltd

# 5. 重载 Nginx
sudo nginx -t && sudo systemctl reload nginx
```

## ⚙️ GitHub Actions 配置

首次使用需要配置以下 Secrets：

1. 访问仓库 **Settings** → **Secrets and variables** → **Actions**
2. 添加以下 Secrets：

| Secret 名称 | 说明 |
|-------------|------|
| `VPS_HOST` | VPS IP 或域名 |
| `VPS_USER` | SSH 用户名（通常是 `root`） |
| `VPS_SSH_KEY` | SSH 私钥完整内容 |

### 生成 SSH 密钥

```bash
# 生成部署专用密钥
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_deploy

# 将公钥添加到 VPS
ssh-copy-id -i ~/.ssh/github_deploy.pub root@your-vps-ip

# 查看私钥（添加到 GitHub Secrets）
cat ~/.ssh/github_deploy
```

## 📝 常用命令

```bash
# 博客管理
hexo new post "文章标题"    # 创建新文章
hexo new page "页面名"      # 创建新页面
hexo server                 # 本地预览
hexo generate               # 生成静态文件
hexo clean                  # 清理缓存

# 快速发布
git add . && git commit -m "update" && git push

# 本地手动部署（备用）
./deploy.sh
./deploy.sh blog            # 仅部署博客
./deploy.sh homepage        # 仅部署主页
```

## 🐛 故障排查

### 主页 404

```bash
# 检查文件是否存在
ls -la /var/www/homepage/index.html

# 检查权限
sudo chown -R www-data:www-data /var/www/homepage
sudo chmod -R 755 /var/www/homepage
```

### 博客 404

```bash
# 检查博客文件
ls -la /var/www/myblog/public/

# 检查 Nginx 配置
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

### GitHub Actions 失败

1. 检查 Secrets 是否正确配置
2. 确保 SSH 私钥包含完整的 `-----BEGIN` 和 `-----END` 行
3. 查看 Actions 日志定位具体错误

## 📄 许可证

MIT License

## 🙏 致谢

- [Hexo](https://hexo.io/) - 静态博客框架
- [Butterfly](https://butterfly.js.org/) - 主题
- [GitHub Actions](https://github.com/features/actions) - CI/CD
