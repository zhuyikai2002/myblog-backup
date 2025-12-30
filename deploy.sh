#!/bin/bash

# 遇到错误立刻停止，防止连锁反应
set -e

echo "🚀 [1/3] 开始本地生产..."
hexo clean
hexo g

echo "🚚 [2/3] 发送成品网页到 VPS..."
# 注意：这里的 myvps 必须和你 SSH Config 里的名字一致
scp -r public/* myvps:/var/www/html/

echo "💾 [3/3] 备份源码到 GitHub..."
git add .
# 自动生成一个带时间的提交备注，显得很专业
git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "🎉 搞定！网站已更新，源码已备份！"