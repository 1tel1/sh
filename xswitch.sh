#!/bin/bash
apt-get update && apt-get install -y make zip wget
docker -v
if [ $? -ne 0 ]; then
apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
curl -L https://get.daocloud.io/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi
cd /usr/local
read -p "1:社区版，2:企业版" word1
if [ $word1 == 1 ] ;then
  read -p "1:稳定版，2:开发版" word2
  if [ $word2 == 1 ] ;then
    wget https://xswitch.cn/download/xswitch-community-6.0.7.tar.gz --user xswitch --password password
    tar zxvf xswitch-community-6.0.7.tar.gz -C /usr/local
    rm -rf xswitch-community-6.0.7.tar.gz
    mv /usr/local/xswitch-community-6.0.7 /usr/local/xswitch
  elif [ $word2 == 2 ] ;then
    wget https://xswitch.cn/download/xswitch-community-6.1.7.9.tar.gz --user xswitch --password password
    tar zxvf xswitch-community-6.1.7.9.tar.gz -C /usr/local
    rm -rf xswitch-community-6.1.7.9.tar.gz
    mv /usr/local/xswitch-community-6.1.7.9 /usr/local/xswitch
  fi
elif [ $word1 == 2 ] ;then  
  read -p "1:稳定版，2:开发版" word3
  if [ $word3 == 1 ] ;then
    wget https://xswitch.cn/download/xswitch-6.0.7.tar.gz --user xswitch --password password
    tar zxvf xswitch-6.0.7.tar.gz -C /usr/local
    rm -rf xswitch-6.0.7.tar.gz
    mv /usr/local/xswitch-6.0.7 /usr/local/xswitch
  elif [ $word3 == 2 ] ;then
    wget https://xswitch.cn/download/xswitch-6.1.7.9.tar.gz --user xswitch --password password
    tar zxvf xswitch-6.1.7.9.tar.gz -C /usr/local
    rm -rf xswitch-6.1.7.9.tar.gz
    mv /usr/local/xswitch-6.1.7.9 /usr/local/xswitch
  fi
fi
cd /usr/local/xswitch
make setup
ip1= curl ifconfig.me
read -p "公网IP：$ip1 ，如不正确请重新输入：" ip11
if [ ${#ip11} -gt 2 ] ; then
	ip1 = $ip11
fi

networkCard=`ifconfig | grep RUNNING |grep BROADCAST| awk -F ':' '{print $1}'`
ip2=`ifconfig "$networkCard"|grep inet|grep -v inet6|awk '{print $2}'`
read -p "内网IP：$ip2 ，如不正确请重新输入：" ip12
if [ ${#ip12} -gt 2 ] ; then
  ip2 = $ip12
fi
echo $ip2
sed 's/EXT_IP=2.2.2.2/EXT_IP=$ip1/g' /usr/local/xswitch/.env
sed 's/LOCAL_IP=192.168.0.1/LOCAL_IP=$ip2/g' /usr/local/xswitch/.env
sed 's/NGINX_PROXY=192.168.0.1/NGINX_PROXY=$ip2/g' /usr/local/xswitch/.env
make up
make up-nginx
echo "alias xswitch='cd /usr/local/xswitch && make bash'" >> ~/.bashrc
echo "alias xdown='cd /usr/local/xswitch && make down'" >> ~/.bashrc
echo "alias xup='cd /usr/local/xswitch && make up'" >> ~/.bashrc
echo "alias xcli='cd /usr/local/xswitch && make cli'" >> ~/.bashrc
echo "alias xnginx='cd /usr/local/xswitch && make bash-nginx'" >> ~/.bashrc
echo "alias xenv='vim /usr/local/xswitch/.env'" >> ~/.bashrc
echo "$ip1:8081 用户:admin 密码： XSwitch.cn/6753997"
rm -rf xswitch.sh
alias
