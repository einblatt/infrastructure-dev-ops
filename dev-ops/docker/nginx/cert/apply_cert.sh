#!/bin/bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

set -e
set -o pipefail

trap 'echo "❌ 错误：第 $LINENO 行执行失败，脚本终止"; exit 1' ERR

# ================================================
# 配置区域
# ================================================

DOMAINS=(
    "<域名>"
)

WEBROOT="/usr/local/docker/nginx/cert"
CERT_DIR="/usr/local/docker/nginx/cert"
SLEEP_INTERVAL=3

# ================================================

# 检查 acme.sh 是否可用
command -v ~/.acme.sh/acme.sh &>/dev/null || {
    echo "❌ acme.sh 未找到，请先安装"
    exit 1
}

TOTAL=${#DOMAINS[@]}
echo "================================================"
echo " 开始为 $TOTAL 个域名申请 SSL 证书"
echo "================================================"

for i in "${!DOMAINS[@]}"; do
    DOMAIN="${DOMAINS[$i]}"
    NUM=$((i + 1))

    echo ""
    echo "📌 [$NUM/$TOTAL] 处理域名：$DOMAIN"
    echo "------------------------------------------------"

    # 申请证书
    echo "⏳ 申请证书..."
    ~/.acme.sh/acme.sh --issue -d "$DOMAIN" --webroot "$WEBROOT" --force
    echo "✅ 证书申请成功：$DOMAIN"

    # 安装证书，每个域名都绑定 reloadcmd 确保自动续期生效
    echo "⏳ 安装证书..."
    ~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
        --key-file "$CERT_DIR/$DOMAIN.key" \
        --fullchain-file "$CERT_DIR/$DOMAIN.crt" \
        --reloadcmd "docker restart nginx"
    echo "✅ 证书安装完成：$DOMAIN"

    # 最后一个域名不需要等待
    if [ "$NUM" -lt "$TOTAL" ]; then
       echo "⏸️  等待 ${SLEEP_INTERVAL}s 后继续..."
        sleep "$SLEEP_INTERVAL"
    fi

done

echo ""
echo "================================================"
echo "✅ 所有域名证书申请完成"
echo "================================================"
echo ""

# 输出证书清单
echo "📁 证书文件清单："
for DOMAIN in "${DOMAINS[@]}"; do
    echo "   $CERT_DIR/$DOMAIN.key"
    echo "   $CERT_DIR/$DOMAIN.crt"
done