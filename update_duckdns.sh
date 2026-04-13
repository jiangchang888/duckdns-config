#!/bin/bash

# ==========================================
# DuckDNS 自动更新脚本
# ==========================================

# 1. 配置部分
DOMAIN="jc3940"            # 这里已经填好了你的子域名
TOKEN_FILE="token.txt"     # 存放 Token 的文件
LOG_FILE="update.log"      # 记录日志的文件

# ==========================================
# 2. 脚本逻辑 (无需修改)
# ==========================================

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始检查 IP..." >> $LOG_FILE

# 读取 Token
if [ -f "$TOKEN_FILE" ]; then
    TOKEN=$(cat $TOKEN_FILE | tr -d '\n')
else
    echo "错误：找不到 $TOKEN_FILE 文件！"
    exit 1
fi

# 获取当前公网 IP
CURRENT_IP=$(curl -s https://api.ipify.org)

if [ -z "$CURRENT_IP" ]; then
    echo "[$(date)] 获取 IP 失败，跳过本次更新。" >> $LOG_FILE
    exit 1
fi

echo "当前公网 IP 是: $CURRENT_IP" >> $LOG_FILE

# 向 DuckDNS 发送更新请求
URL="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=$CURRENT_IP"
RESULT=$(curl -s $URL)

# 记录结果
if [ "$RESULT" = "OK" ]; then
    echo "[$(date)] 更新成功！IP: $CURRENT_IP" >> $LOG_FILE
else
    echo "[$(date)] 更新失败！返回信息: $RESULT" >> $LOG_FILE
fi