docker -v
if [ $? -ne 0 ]; then
 curl -sSL https://get.docker.com | sh
 sudo usermod -aG docker $(whoami)
fi
ip1= curl ifconfig.me
read -p "🚨🚨🚨🚨🚨🚨需要公网IP : "$ip1" 正确请回车。不正确请输入》》》》：" in
if [ ${#in} -gt 5 ] ; then
	ip1 = ${in} 
fi
read -p "🚨🚨🚨🚨🚨🚨需要密码，请输入》》》》：" pas
if [ ${#pas} -gt 1 ] ; then
	pass = "$pas"
fi

docker run -d \
  --name=wg-easy \
  -e WG_HOST="$ip1" \
  -e PASSWORD="$pass" \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  weejewel/wg-easy
  echo "http://"$ip1":51821"
  echo "密码:"$pass" "
  echo " 配置文件地址："~/.wg-easy"
