#!/bin/bash
set -e

echo "🚀 [1/3] 开始本地生产 (Hexo Generate)..."
hexo clean
hexo g

echo "🚚 [2/3] 发送成品网页到 VPS (SCP Upload)..."
# ⚠️ 注意：目标路径后面加了 blog/
# 确保你已经在 VPS 上执行过 mkdir -p /var/www/html/blog
scp -r public/* myvps:/var/www/html/blog/

echo "💾 [3/3] 备份源码到 GitHub (Git Push)..."
git add .
# 这里的提交信息我保留了你的自动化时间戳
git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "🎉 搞定！网站已更新，源码已备份！"