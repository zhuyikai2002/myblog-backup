#!/bin/bash
set -e

# ============================================
# Hexo 博客快速部署脚本（优化版）
# 用途：本地快速部署，备用方案
# 建议：日常使用 git push 触发 CI/CD
# ============================================

# 配置变量
REMOTE_HOST="myvps"
REMOTE_PATH="/var/www/html/blog/"
WEBSITE_URL="https://qzkj.ltd/blog/"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：重试命令
retry() {
    local n=1
    local max=3
    local delay=5
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                echo -e "${YELLOW}命令失败，重试 $n/$max 中...${NC}"
                ((n++))
                sleep $delay
            else
                echo -e "${RED}命令失败 $max 次，退出。${NC}"
                exit 1
            fi
        }
    done
}

echo -e "${BLUE}🚀 开始快速部署流程...${NC}"
echo ""

echo -e "${BLUE}[1/3] 构建静态网站 (Hexo Generate)...${NC}"
if [ -d "public" ] && [ "$(find public -type f | wc -l)" -gt 10 ]; then
    read -p "检测到 public/ 目录已存在，是否跳过 hexo clean？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        hexo clean
    fi
fi
hexo g

echo ""
echo -e "${BLUE}[2/3] 同步到 VPS (Rsync 增量上传)...${NC}"
# 使用 rsync 增量传输，--info=progress2 显示整体进度
retry rsync -avz --delete --info=progress2 --exclude='.git' public/ ${REMOTE_HOST}:${REMOTE_PATH}

echo ""
echo -e "${BLUE}[3/3] 备份源码到 GitHub...${NC}"
if git diff --quiet && git diff --staged --quiet; then
    echo -e "${YELLOW}没有新更改，跳过 Git 提交${NC}"
else
    git add source/ _config.yml _config.butterfly.yml themes/ scripts/ deploy.sh .github/
    git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')" || echo -e "${YELLOW}提交失败，可能没有更改${NC}"
    retry git push
    echo -e "${GREEN}✅ 源码已推送到 GitHub（将触发 CI/CD 自动部署）${NC}"
fi

echo ""
echo -e "${BLUE}🔍 验证部署...${NC}"
if curl -s --head --fail "$WEBSITE_URL" > /dev/null; then
    echo -e "${GREEN}✅ 网站部署成功：$WEBSITE_URL${NC}"
else
    echo -e "${RED}❌ 网站验证失败，请检查 VPS 配置${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 搞定！本地部署完成！${NC}"
echo -e "${YELLOW}💡 提示：现在你也可以直接 git push，让 GitHub Actions 自动完成部署${NC}"