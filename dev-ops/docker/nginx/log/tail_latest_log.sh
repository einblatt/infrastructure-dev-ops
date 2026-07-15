#!/bin/bash

# 查找当前目录下所有 .log 结尾的文件
# 按文件名排序，适合 x-2026-07-08.log 这种日期命名格式
latest_log=$(find . -maxdepth 1 -type f -name "*.log" | sort -V | tail -n 1)

# 如果没有找到日志文件，退出
if [ -z "$latest_log" ]; then
  echo "当前目录没有找到 .log 日志文件"
  exit 1
fi

echo "正在查看最新日志文件：$latest_log"

# 打印最后 100 行，并持续监听新日志
tail -n 100 -f "$latest_log"
