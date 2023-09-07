#!/bin/bash
apt-get update && apt-get install -y make zip wget
docker-compose --version
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
wget https://xswitch.cn/download/xswitch-6.1.7.9.tar.gz --user xswitch --password password
tar zxvf xswitch-6.1.7.9.tar.gz -C /usr/local
rm -rf xswitch-6.1.7.9.tar.gz
mv /usr/local/xswitch-6.1.7.9 /usr/local/xswitch
cd /usr/local/xswitch
make setup
ip1= curl ifconfig.me
networkCard=`ifconfig | grep RUNNING |grep BROADCAST| awk -F ':' '{print $1}'`
ip=`ifconfig "$networkCard"|grep inet|grep -v inet6|awk '{print $2}'`
sed 's/EXT_IP=2.2.2.2/EXT_IP=$ip1/g' /usr/local/xswitch/.env
sed 's/LOCAL_IP=192.168.0.1/LOCAL_IP=$ip/g' /usr/local/xswitch/.env
sed 's/NGINX_PROXY=192.168.0.1/NGINX_PROXY=$ip/g' /usr/local/xswitch/.env
make up
make up-nginx
echo "alias xswitch='cd /usr/local/xswitch && make bash'" >> ~/.bashrc
echo "alias xdown='cd /usr/local/xswitch && make down'" >> ~/.bashrc
echo "alias xup='cd /usr/local/xswitch && make up'" >> ~/.bashrc
echo "alias xcli='cd /usr/local/xswitch && make cli'" >> ~/.bashrc
echo "alias xnginx='cd /usr/local/xswitch && make bash-nginx'" >> ~/.bashrc
echo "alias xenv='vim /usr/local/xswitch/.env'" >> ~/.bashrc
sudo source root/.bashrc
echo "$ip1:8081 用户:admin 密码： XSwitch.cn/6753997"
rm -rf xswitch.sh
alias
