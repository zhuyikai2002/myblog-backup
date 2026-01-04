#!/bin/bash
set -e

# 配置变量（便于修改）
REMOTE_HOST="myvps"
REMOTE_PATH="/var/www/html/blog/"
GIT_REPO_URL="https://github.com/zhuyikai2002/myblog-backup.git"  # 如果需要
WEBSITE_URL="https://qzkj.ltd/blog/"  # 用于验证

# 函数：重试命令
retry() {
    local n=1
    local max=3
    local delay=5
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                echo "命令失败，重试 $n/$max 中..."
                ((n++))
                sleep $delay
            else
                echo "命令失败 $max 次，退出。"
                exit 1
            fi
        }
    done
}

echo "🚀 [1/4] 预处理：压缩图片..."
# 压缩图片（如果有新图片）
if command -v imagemin &> /dev/null; then
    npx imagemin themes/butterfly/source/img/* public/img/* --out-dir=./compressed --plugin=mozjpeg --plugin=pngquant 2>/dev/null || echo "图片压缩跳过"
else
    echo "imagemin 未安装，跳过图片压缩"
fi

echo "🏗️ [2/4] 开始本地生产 (Hexo Generate)..."
hexo clean
hexo g

echo "🚚 [3/4] 发送成品网页到 VPS (Rsync Upload)..."
# 使用 rsync 替代 scp，更高效，支持增量传输和进度显示
# -a: 归档模式，-v: 详细，-z: 压缩，--delete: 删除远程多余文件，--progress: 显示进度
retry rsync -avz --delete --progress public/ ${REMOTE_HOST}:${REMOTE_PATH}

echo "💾 [4/4] 备份源码到 GitHub (Git Push)..."
# 检查是否有更改
if git diff --quiet && git diff --staged --quiet; then
    echo "没有新更改，跳过 Git 提交"
else
    git add source/ _config.yml _config.butterfly.yml themes/ scripts/ deploy.sh
    git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')" || echo "提交失败，跳过"
    retry git push
fi

echo "🔍 验证部署..."
# 简单验证：检查网站是否可访问
if curl -s --head --fail "$WEBSITE_URL" > /dev/null; then
    echo "✅ 网站部署成功：$WEBSITE_URL"
else
    echo "❌ 网站验证失败，请检查 VPS 配置"
fi

echo "🎉 搞定！网站已更新，源码已备份！"