#!/bin/bash
set -e

# ============================================
# VPS 一键初始化脚本
# 适用于 Debian 12 / Ubuntu 22.04+
# 用途：快速配置 Nginx + SSL + 博客目录
# ============================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 配置变量
DOMAIN="${DOMAIN:-qzkj.ltd}"
DOMAIN_WWW="www.${DOMAIN}"
BLOG_DIR="/var/www/myblog/public"
HOMEPAGE_DIR="/var/www/homepage"
NGINX_CONF="/etc/nginx/conf.d/myblog.conf"
GITHUB_RAW="https://raw.githubusercontent.com/zhuyikai2002/myblog-backup/main"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 检查 root 权限
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "请使用 root 用户运行，或使用 sudo"
    fi
}

# 安装依赖
install_dependencies() {
    info "更新软件包..."
    apt update -y
    
    info "安装 Nginx..."
    apt install -y nginx curl wget rsync
    
    systemctl enable nginx
    systemctl start nginx
    success "Nginx 安装完成"
}

# 创建目录
create_directories() {
    info "创建目录结构..."
    
    mkdir -p "$BLOG_DIR"
    mkdir -p "$HOMEPAGE_DIR"
    
    chown -R www-data:www-data /var/www
    chmod -R 755 /var/www
    
    success "目录创建完成"
    echo "  - 博客: $BLOG_DIR"
    echo "  - 主页: $HOMEPAGE_DIR"
}

# 配置 Nginx
configure_nginx() {
    info "配置 Nginx..."
    
    # 备份现有配置
    if [ -f "$NGINX_CONF" ]; then
        cp "$NGINX_CONF" "${NGINX_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "已备份现有配置"
    fi
    
    # 下载配置
    curl -fsSL "${GITHUB_RAW}/nginx/myblog.conf" -o "$NGINX_CONF" 2>/dev/null || {
        warn "无法下载配置，使用内置模板..."
        create_nginx_config
    }
    
    # 替换域名
    if [ "$DOMAIN" != "qzkj.ltd" ]; then
        sed -i "s/qzkj.ltd/$DOMAIN/g" "$NGINX_CONF"
    fi
    
    nginx -t || error "Nginx 配置测试失败"
    systemctl reload nginx
    success "Nginx 配置完成"
}

# 内置 Nginx 配置
create_nginx_config() {
    cat > "$NGINX_CONF" << 'EOF'
server {
    server_name qzkj.ltd www.qzkj.ltd;
    index index.html index.htm;
    server_tokens off;

    location = / {
        root /var/www/homepage;
        try_files /index.html =404;
    }

    location = /blog { return 301 /blog/; }
    location ^~ /blog/ {
        alias /var/www/myblog/public/;
        try_files $uri $uri/ /index.html;
    }

    location = /about { return 301 /about/; }
    location ^~ /about/ {
        alias /var/www/myblog/public/about/;
        try_files $uri $uri/ $uri/index.html =404;
    }

    location = /lab { return 301 /lab/; }
    location ^~ /lab/ {
        alias /var/www/myblog/public/lab/;
        try_files $uri $uri/ $uri/index.html =404;
    }

    location / {
        root /var/www/myblog/public;
        try_files $uri $uri/ /index.html;
    }

    listen 80;
    listen [::]:80;
}
EOF
}

# 下载主页
download_homepage() {
    info "下载终端主页..."
    
    curl -fsSL "${GITHUB_RAW}/source/homepage/index.html" -o "${HOMEPAGE_DIR}/index.html" 2>/dev/null || {
        warn "无法下载主页，请稍后手动部署"
        return
    }
    
    chown www-data:www-data "${HOMEPAGE_DIR}/index.html"
    chmod 644 "${HOMEPAGE_DIR}/index.html"
    success "主页部署完成"
}

# 配置 SSL
configure_ssl() {
    echo ""
    read -p "是否配置 SSL 证书？(y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "安装 Certbot..."
        apt install -y certbot python3-certbot-nginx
        
        info "申请 SSL 证书..."
        certbot --nginx -d "$DOMAIN" -d "$DOMAIN_WWW" --non-interactive --agree-tos --email "admin@${DOMAIN}" || {
            warn "自动申请失败，请手动运行:"
            echo "  certbot --nginx -d $DOMAIN -d $DOMAIN_WWW"
        }
    fi
}

# 配置防火墙
configure_firewall() {
    if command -v ufw &> /dev/null; then
        info "配置防火墙..."
        ufw allow 'Nginx Full' >/dev/null 2>&1
        ufw allow OpenSSH >/dev/null 2>&1
        success "防火墙已配置"
    fi
}

# 显示摘要
show_summary() {
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${GREEN}🎉 VPS 初始化完成！${NC}"
    echo -e "${CYAN}============================================${NC}"
    echo ""
    echo -e "📁 目录:"
    echo -e "   主页: ${BLUE}${HOMEPAGE_DIR}${NC}"
    echo -e "   博客: ${BLUE}${BLOG_DIR}${NC}"
    echo ""
    echo -e "🌐 访问:"
    echo -e "   主页: ${BLUE}http://${DOMAIN}${NC}"
    echo -e "   博客: ${BLUE}http://${DOMAIN}/blog/${NC}"
    echo ""
    echo -e "📋 下一步:"
    echo -e "   1. 配置 GitHub Actions Secrets"
    echo -e "   2. 推送代码触发自动部署: ${YELLOW}git push${NC}"
    echo ""
    echo -e "🔧 常用命令:"
    echo -e "   ${YELLOW}systemctl status nginx${NC}     - 查看状态"
    echo -e "   ${YELLOW}tail -f /var/log/nginx/error.log${NC} - 查看日志"
    echo ""
}

# 主函数
main() {
    echo -e "${CYAN}"
    echo "============================================"
    echo "    VPS 一键初始化脚本 v1.0"
    echo "    适用于 Debian 12 / Ubuntu 22.04+"
    echo "============================================"
    echo -e "${NC}"
    
    while getopts "d:h" opt; do
        case $opt in
            d) DOMAIN="$OPTARG" ;;
            h) echo "用法: $0 [-d 域名]"; exit 0 ;;
        esac
    done
    
    check_root
    
    echo -e "域名: ${BLUE}${DOMAIN}${NC}"
    echo ""
    read -p "确认继续？(Y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && exit 0
    
    install_dependencies
    create_directories
    configure_nginx
    download_homepage
    configure_ssl
    configure_firewall
    show_summary
}

main "$@"
