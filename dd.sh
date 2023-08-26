#!/bin/bash
apt-get install -y xz-utils openssl gawk file wget screen && screen -S os || yum install -y xz openssl gawk file glibc-common wget screen && screen -S os
ufw status
if [ $? -ne 0 ]; then
    apt update -y && apt dist-upgrade -y || yum makecache && yum update -y
else
    wget --no-check-certificate -O AutoReinstall.sh https://d.02es.com/AutoReinstall.sh && chmod a+x AutoReinstall.sh && bash AutoReinstall.sh
fi


