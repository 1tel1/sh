#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y lsb-release apt-transport-https ca-certificates wget
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
sudo apt install php8.0-fpm -y
sudo apt install -y php8.0-{mysql,cli,common,snmp,ldap,curl,mbstring,zip} -y
php -v
if [ $? -eq 0 ]; then
    echo "php8 安装 成功"
else
    echo "php8 安装 失败"
fi
