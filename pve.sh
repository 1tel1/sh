#!/bin/bash
rm /etc/apt/sources.list
cat>/etc/apt/sources.list<<EOF  
deb http://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security bullseye-security main contrib 
deb http://mirrors.ustc.edu.cn/proxmox/debian bullseye pve-no-subscription
EOF
apt update && apt install -y apt-transport-https wget
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
apt update && apt install -y apt-transport-https wget
ip1= curl ifconfig.me
HOSTNAME=$(hostname).pvetest.com debian
a=$ip1  $HOSTNAME.pvetest.com   $HOSTNAME
sed -i '1 a $a' /etc/hosts
sed -i '1 a 127.0.0.1 localhost.localdomain localhost' /etc/hosts
sed -i '1' /etc/hosts
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
apt update && apt install -y proxmox-ve postfix open-iscsi
DEBIAN_FRONTEND=noninteractiv apt-get --no-install-recommends install -y proxmox-ve
