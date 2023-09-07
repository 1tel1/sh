#!/usr/bin/env bash
echo -e "\n$(date "+%d-%m-%Y --- %T") --- Starting work\n"
read -p "升级Debian12:1.升级Debian11:2，》》》》》》》》》" word
if [ "$word" == 1 ] ;then
sudo apt update
sudo apt upgrade
sudo apt full-upgrade
sudo apt --purge autoremove
sudo reboot
sudo apt-mark showhold | more
sudo apt-mark unhold <pkg-name>
sudo cp -v /etc/apt/sources.list /opt/sources.list-bakup-debian11
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo apt update
echo "q和直接回车"
sudo apt full-upgrade
sudo apt full-upgrade
sudo reboot
lsb_release -a
uname -rms
sudo apt --purge autoremove

elif [ "$word" == 2 ] ;then
  apt update && apt upgrade -y
删除未使用的依赖项：
apt --purge autoremove
apt --purge autoremove
fi
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
sudo rm -rf 1.sh debian.sh
echo -e "\n$(date "+%T") \t happy"


