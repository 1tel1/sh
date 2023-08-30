#!/usr/bin/env bash
if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
    DISTRO='Fedora'
    PM='yum' 
elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
    DISTRO='RHEL'
    PM='yum'
elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
    DISTRO='Aliyun'
    PM='yum'
elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
    DISTRO='CentOS'
    PM='yum'
elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
    DISTRO='Debian'
  wget https://raw.githubusercontent.com/1tel1/sh/main/debian.sh
  chmod +x debian.sh && ./debian.sh
elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
    DISTRO='Ubuntu'
  wget https://raw.githubusercontent.com/1tel1/sh/main/debian.sh
  chmod +x debian.sh && ./debian.sh
elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
    DISTRO='Raspbian'
  wget https://raw.githubusercontent.com/1tel1/sh/main/debian.sh
  chmod +x debian.sh && ./debian.sh
else
    DISTRO='unknow'
fi
if [ ${PM} ="apt" ]; then
  wget https://raw.githubusercontent.com/1tel1/sh/main/debian.sh
  chmod +x debian.sh && ./debian.sh
elif [ ${PM} ="yum" ]; then
  wget https://raw.githubusercontent.com/1tel1/sh/main/centos.sh
  chmod +x centos.sh && ./centos.sh
fi
