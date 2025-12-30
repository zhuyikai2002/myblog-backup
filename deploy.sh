#!/bin/bash
set -e

echo "🚀 [1/3] 开始本地生产 (Hexo Generate)..."
hexo clean
hexo g

echo "🚚 [2/3] 发送成品网页到 VPS (SCP Upload)..."
# ⚠️ 注意：如果你的 SSH 名字不是 myvps，请修改下面这行的 myvps
scp -r public/* myvps:/var/www/html/

echo "💾 [3/3] 备份源码到 GitHub (Git Push)..."
git add .
git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "🎉 搞定！网站已更新，源码已备份！"