#!/bin/bash

# 任何命令失败立即退出，管道命令也检测错误
set -e
set -o pipefail

# 错误处理函数
error_exit() {
    echo "❌ 错误：$1 失败，脚本终止（第 $2 行）"
    exit 1
}

# 捕获错误并输出行号
trap 'error_exit "$BASH_COMMAND" $LINENO' ERR

echo "================================================"
echo " 开始初始化环境"
echo "================================================"

# 安装 JDK 环境
echo "⏳ [1/4] 安装 JDK-8..."
apt-get install -y openjdk-8-jre-headless
echo "✅ JDK-8 安装完成"

# 安装 Docker
echo "⏳ [2/4] 安装 Docker..."
bash install_docker.sh
echo "✅ Docker 安装完成"

# 安装 ACME
echo "⏳ [3/4] 安装 ACME..."
bash ./acme/install_acme.sh
grep -q 'alias acme.sh' ~/.bashrc || echo 'alias acme.sh=~/.acme.sh/acme.sh' >> ~/.bashrc
source ~/.bashrc
echo "✅ ACME 安装完成"

# 初始化工作目录
echo "⏳ [4/4] 初始化工作目录..."
bash ./init_dir.sh
echo "✅ 工作目录初始化完成"

echo "================================================"
echo "✅ 所有步骤执行成功"
echo "================================================"