#!/usr/bin/env bash
yum update && yum upgrade
yum install kde-l10n-Chinese
yum reinstall glibc-common
mv /etc/locale.conf /etc/locale.conf1
cat>/etc/locale.conf<<EOF  
LANG=zh_CN.UTF-8
EOF
# 连接配置文件
ls -l /etc/localtime && timedatectl set-timezone Asia/Shanghai
rm -rf ~/.bashrc1
mv ~/.bashrc ~/.bashrc1
wget https://raw.githubusercontent.com/1tel1/sh/main/.centos-bashrc ~/.bashrc
source ~/.bashrc
read -r -p "输入主机名" newhostname
hostnamectl set-hostname $newhostname
echo "127.0.0.1    $newhostname      $newhostname" >>/etc/hosts
echo "$ip1 $newhostname      $newhostname" >>/etc/hosts
rm -rf 1.sh
