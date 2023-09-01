#!/usr/bin/env bash
sudo apt update
sudo apt install mailutils
sudo apt install postfix
echo "# 回车 **Internet Site** 回车 输入主机名（域名）回车"
sed 's/mydestination = $myhostname, example.com, localhost.com, , localhost/mydestination = $myhostname, localhost.$mydomain, $mydomain/' /etc/postfix/main.cf
sed 's/inet_interfaces = all/inet_interfaces = loopback-only/' /etc/postfix/main.cf
sudo systemctl restart postfix
