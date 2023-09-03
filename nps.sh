#!/usr/bin/env bash
cd /usr/local
wget https://ghproxy.com/https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_server.tar.gz
tar -zxvf linux_amd64_server.tar.gz
sudo ./nps install
sed 's/web_port = 8080/web_port = 18080/g' /etc/nps/conf/nps.conf
sed 's/http_proxy_port = 80/web_port = 1080/g' /etc/nps/conf/nps.conf
sed 's/https_proxy_port = 443/web_port = 10443/g' /etc/nps/conf/nps.conf
sudo nps start
echo "ip:web服务端口（18080）用户名和密码admin/123"
