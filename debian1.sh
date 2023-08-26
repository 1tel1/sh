#!/usr/bin/env bash
if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
        yum install kde-l10n-Chinese
        yum reinstall glibc-common
        mv /etc/locale.conf /etc/locale.conf1
cat>/etc/locale.conf<<EOF  
LANG=zh_CN.UTF-8
EOF
        # 连接配置文件
        ls -l /etc/localtime
        # 查看当前时区
        timedatectl
        # 查看可用时区
        timedatectl list-timezones
        # 更改时区
        timedatectl set-timezone Asia/Shanghai
        yum update
        yum upgrade
        if [ ! -d "~/.bashrc1" ]; then
          mv ~/.bashrc ~/.bashrc1
          wget https://raw.githubusercontent.com/1tel1/sh/main/.centos-bashrc ~/.bashrc
          source ~/.bashrc
        fi
        
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
        read -r -p "输入主机名" newhostname
        hostnamectl set-hostname $newhostname
        echo "127.0.0.1    $newhostname      $newhostname" >>/etc/hosts
        apt-get install locales 
        dpkg-reconfigure locales 
        locale
        # 连接配置文件
        ls -l /etc/localtime
        timedatectl set-timezone Asia/Shanghai
        sudo apt update
        sudo apt upgrade
        apt install sudo 
        apt install  net-tools
        apt install git wget curl make vim lsof
        if [ ! -d "~/.bashrc1" ]; then
          mv ~/.bashrc ~/.bashrc1
          wget https://raw.githubusercontent.com/1tel1/sh/main/.bashrc ~/.bashrc
          source ~/.bashrc
        fi
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    echo $DISTRO;


