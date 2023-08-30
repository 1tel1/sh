#!/usr/bin/env bash
echo -e "\n$(date "+%d-%m-%Y --- %T") --- Starting work\n"
apt-get update
apt-get -y upgrade
apt-get -y autoremove
apt-get autoclean
apt-get install locales 
dpkg-reconfigure locales 
locale
ls -l /etc/localtime
timedatectl set-timezone Asia/Shanghai
read -r -p "输入新主机名>>>>>>:" input
hostnamectl set-hostname $input
echo "127.0.0.1 ${input} ${input}" >> /etc/hosts
ip1= curl ifconfig.me
echo "$ip1 $newhostname      $newhostname" >>/etc/hosts
sudo apt install net-tools git wget curl make vim lsof
rm -rf .bashrc1
mv ~/.bashrc ~/.bashrc1
wget https://ghproxy.com/https://raw.githubusercontent.com/1tel1/sh/main/.bashrc 
mv .bashrc ~/.bashrc
source ~/.bashrc
echo -e "\n$(date "+%T") \t 脚本终止"

