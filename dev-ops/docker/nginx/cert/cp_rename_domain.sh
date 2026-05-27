#!/bin/bash

set -e
set -o pipefail

trap 'echo "❌ 错误：第 $LINENO 行执行失败，脚本终止"; exit 1' ERR

# ================================================
# 配置区域：在这里填写域名和源文件路径
# ================================================

# 配置域名列表

DOMAINS=(
    "<域名>"
)

# 源文件所在目录
SOURCE_DIR="/usr/local/docker/nginx/cert"

# 输出目录（默认当前目录）
OUTPUT_DIR="."

# ================================================

SOURCE_KEY="$SOURCE_DIR/x.key"
SOURCE_CRT="$SOURCE_DIR/x.crt"

# 检查源文件是否存在
echo "🔍 检查源文件..."
[ -f "$SOURCE_KEY" ] || { echo "❌ 找不到文件：$SOURCE_KEY"; exit 1; }
[ -f "$SOURCE_CRT" ] || { echo "❌ 找不到文件：$SOURCE_CRT"; exit 1; }
echo "✅ 源文件检查通过"

echo "================================================"

# 遍历域名列表，复制并重命名
for DOMAIN in "${DOMAINS[@]}"; do
    echo "⏳ 处理域名：$DOMAIN"

    cp "$SOURCE_KEY" "$OUTPUT_DIR/$DOMAIN.key"
    cp "$SOURCE_CRT" "$OUTPUT_DIR/$DOMAIN.crt"

    echo "✅ 生成：$DOMAIN.key / $DOMAIN.crt"
done

echo "================================================"
echo "✅ 所有域名证书文件生成完成"
echo ""

# 输出生成结果
echo "📁 生成的文件列表："
for DOMAIN in "${DOMAINS[@]}"; do
    echo "   $OUTPUT_DIR/$DOMAIN.key"
    echo "   $OUTPUT_DIR/$DOMAIN.crt"
done