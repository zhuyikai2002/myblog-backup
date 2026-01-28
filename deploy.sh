#!/bin/bash
set -e

# ============================================
# Hexo 博客一键部署脚本 v2.0
# 支持：本地部署 / VPS 初始化 / 主页部署
# 日常推荐：直接 git push 触发 CI/CD
# ============================================

# 配置变量
REMOTE_HOST="${REMOTE_HOST:-myvps}"
BLOG_PATH="/var/www/myblog/public/"
HOMEPAGE_PATH="/var/www/homepage/"
WEBSITE_URL="https://qzkj.ltd"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 重试函数
retry() {
    local n=1 max=3 delay=5
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                warn "命令失败，重试 $n/$max..."
                ((n++))
                sleep $delay
            else
                error "命令失败 $max 次"
            fi
        }
    done
}

# 显示帮助
show_help() {
    echo -e "${CYAN}Hexo 博客一键部署脚本 v2.0${NC}"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  deploy      完整部署（构建 + 同步博客 + 同步主页）"
    echo "  blog        仅部署博客"
    echo "  homepage    仅部署主页"
    echo "  build       仅构建静态文件"
    echo "  preview     本地预览"
    echo "  push        快速提交并推送（触发 CI/CD）"
    echo "  init-vps    初始化 VPS"
    echo "  help        显示此帮助"
    echo ""
    echo "示例:"
    echo "  $0              # 默认完整部署"
    echo "  $0 blog         # 仅部署博客"
    echo "  $0 push         # 快速 git push"
    echo ""
    echo -e "${YELLOW}💡 日常推荐使用 git push 触发 CI/CD 自动部署${NC}"
}

# 构建静态文件
build_site() {
    info "构建静态网站..."
    
    if [ -d "public" ] && [ "$(find public -type f 2>/dev/null | wc -l)" -gt 10 ]; then
        read -p "检测到 public/ 目录，是否跳过 hexo clean？(y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            hexo clean
        fi
    fi
    
    hexo generate
    success "构建完成"
}

# 部署博客
deploy_blog() {
    info "同步博客到 VPS..."
    retry rsync -avz --delete --info=progress2 --exclude='.git' \
        public/ "${REMOTE_HOST}:${BLOG_PATH}"
    success "博客部署完成"
}

# 部署主页
deploy_homepage() {
    if [ -f "source/homepage/index.html" ]; then
        info "同步主页到 VPS..."
        retry rsync -avz --info=progress2 \
            source/homepage/ "${REMOTE_HOST}:${HOMEPAGE_PATH}"
        
        # 设置权限
        ssh "${REMOTE_HOST}" "chown -R www-data:www-data ${HOMEPAGE_PATH} && chmod -R 755 ${HOMEPAGE_PATH}"
        success "主页部署完成"
    else
        warn "未找到 source/homepage/index.html，跳过主页部署"
    fi
}

# 备份到 GitHub
backup_to_github() {
    info "备份源码到 GitHub..."
    
    if git diff --quiet && git diff --staged --quiet; then
        warn "没有新更改，跳过 Git 提交"
    else
        git add .
        git commit -m "Site update: $(date '+%Y-%m-%d %H:%M:%S')" || warn "提交失败"
        retry git push
        success "源码已推送到 GitHub（将触发 CI/CD）"
    fi
}

# 快速推送
quick_push() {
    info "快速推送到 GitHub..."
    
    if git diff --quiet && git diff --staged --quiet; then
        warn "没有新更改"
        return
    fi
    
    git add .
    read -p "提交信息 (默认: update): " msg
    msg="${msg:-update}"
    git commit -m "$msg"
    git push
    
    success "已推送到 GitHub，CI/CD 将自动部署"
    echo -e "查看部署状态: ${BLUE}https://github.com/zhuyikai2002/myblog-backup/actions${NC}"
}

# 验证部署
verify_deployment() {
    info "验证部署..."
    
    # 验证主页
    if curl -s --head --fail "${WEBSITE_URL}" > /dev/null 2>&1; then
        success "主页: ${WEBSITE_URL}"
    else
        warn "主页验证失败"
    fi
    
    # 验证博客
    if curl -s --head --fail "${WEBSITE_URL}/blog/" > /dev/null 2>&1; then
        success "博客: ${WEBSITE_URL}/blog/"
    else
        warn "博客验证失败"
    fi
}

# 完整部署
full_deploy() {
    echo -e "${CYAN}"
    echo "============================================"
    echo "    Hexo 博客一键部署"
    echo "============================================"
    echo -e "${NC}"
    
    build_site
    deploy_blog
    deploy_homepage
    backup_to_github
    verify_deployment
    
    echo ""
    success "🎉 部署完成！"
    echo -e "  主页: ${BLUE}${WEBSITE_URL}${NC}"
    echo -e "  博客: ${BLUE}${WEBSITE_URL}/blog/${NC}"
}

# 本地预览
preview() {
    info "启动本地预览服务器..."
    echo -e "访问: ${BLUE}http://localhost:4000/blog/${NC}"
    hexo server
}

# VPS 初始化
init_vps() {
    info "初始化 VPS..."
    
    if [ -f "scripts/vps-init.sh" ]; then
        scp scripts/vps-init.sh "${REMOTE_HOST}:/tmp/vps-init.sh"
        ssh "${REMOTE_HOST}" "chmod +x /tmp/vps-init.sh && sudo /tmp/vps-init.sh"
    else
        warn "未找到 scripts/vps-init.sh"
        echo "请在 VPS 上执行:"
        echo "  curl -fsSL https://raw.githubusercontent.com/zhuyikai2002/myblog-backup/main/scripts/vps-init.sh | sudo bash"
    fi
}

# 主函数
main() {
    cd "$(dirname "$0")"
    
    case "${1:-}" in
        deploy|"")
            full_deploy
            ;;
        blog)
            build_site
            deploy_blog
            verify_deployment
            ;;
        homepage)
            deploy_homepage
            verify_deployment
            ;;
        build)
            build_site
            ;;
        preview|server)
            preview
            ;;
        push|p)
            quick_push
            ;;
        init-vps|init)
            init_vps
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            error "未知命令: $1\n运行 '$0 help' 查看帮助"
            ;;
    esac
}

main "$@"
