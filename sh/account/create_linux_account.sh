#!/bin/bash
set -e

USER="modifyapp"
HOME_DIR="/usr/local/docker/nginx/app"
PASSWORD="linux"

userdel modifyapp
useradd -m -d "$HOME_DIR" -s /bin/bash "$USER"
echo "$USER:$PASSWORD" | chpasswd
chown -R $USER:$USER $HOME_DIR
chmod -R 755 "$HOME_DIR"
chmod 755 /usr/local/docker/nginx


echo "用户 $USER 创建完成！"
echo "home目录: $HOME_DIR"
echo "初始密码: $PASSWORD"
echo "权限已改为 755"