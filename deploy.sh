#!/bin/bash
set -e

# 配置变量（便于修改）
REMOTE_HOST="myvps"
REMOTE_PATH="/var/www/html/blog/"
GIT_REPO_URL="https://github.com/zhuyikai2002/myblog-backup.git"  # 如果需要

echo "🚀 [1/3] 开始本地生产 (Hexo Generate)..."
hexo clean
hexo g

echo "🚚 [2/3] 发送成品网页到 VPS (SCP Upload)..."
# 使用 rsync 替代 scp，更高效，支持增量传输和进度显示
# -a: 归档模式，-v: 详细，-z: 压缩，--delete: 删除远程多余文件，--progress: 显示进度
rsync -avz --delete --progress public/ ${REMOTE_HOST}:${REMOTE_PATH}

echo "💾 [3/3] 备份源码到 GitHub (Git Push)..."
# 只添加 source/ 和配置文件，避免添加 public/ 或 node_modules/
git add source/ _config.yml _config.butterfly.yml themes/ scripts/ deploy.sh
git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')" || echo "没有新更改，跳过提交"
git push

echo "🎉 搞定！网站已更新，源码已备份！"