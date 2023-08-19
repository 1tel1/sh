#!/bin/bash
apt-get update && apt-get install -y make zip wget
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
cd /usr/local
wget https://xswitch.cn/download/xswitch-6.1.7.6.tar.gz --user xswitch --password password
tar zxvf xswitch-6.1.7.6.tar.gz -C /usr/local
cd /usr/local/xswitch-6.1.7.6
make setup
mv .env .env1
ip1= curl ifconfig.me
networkCard=`ifconfig | grep RUNNING |grep BROADCAST| awk -F ':' '{print $1}'`
ip=`ifconfig "$networkCard"|grep inet|grep -v inet6|awk '{print $2}'`
cat>.env<<EOF
# xswitch-lua use env

DSN=postgresql://xui:xui@127.0.0.1/xui
SIP_PORT=7060
SIP_TLS_PORT=7061
SIP_PUBLIC_PORT=7080
SIP_PUBLIC_TLS_PORT=7081
VERTO_WS_PORT=8081
VERTO_WSS_PORT=8082
RTP_START=10000
RTP_END=10099
ESL_PORT=8021
EXT_IP=$ip1
LOCAL_IP=$ip
FREESWITCH_DOMAIN=xswitch.cn
FREESWITCH_DEFAULT_PASSWORD=xyt1234
FREESWITCH_EVENT_SOCKET_PASSWORD=xyt1234
INIT_DB=TRUE

# xswitch-pg use env
PGDATA=/var/lib/postgresql/data/pgdata
TZ=PRC
POSTGRES_PASSWORD=xswitch1qaz!

# xswitch-nginx use env
HTTP_PORT=80
NGINX_PROXY=$ip
EOF
make up
make up-nginx
echo "alias xswitch='cd /usr/local/xswitch-6.1.7.6'" >> ~/.bashrc
source ~/.bashrc
echo "$ip1:8081"
echo "admin : XSwitch.cn/6753997"
