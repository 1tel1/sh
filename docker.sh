#! /bin/bash  
apt-get update && apt-get install -y wget vim  
sudo apt-get purge docker-ce docker-ce-cli containerd.io  
sudo rm -rf /var/lib/docker  
sudo rm -rf /var/lib/containerd  

read -p "国内服务器请输入1,国外2》》》》》》》:" word
if [ $word = 2 ] ; then
wget -qO- get.docker.com | bash  
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  
elif [ $word = 1 ] ; then
curl -sSL https://get.daocloud.io/docker | sh  
curl -L https://get.daocloud.io/docker/compose/releases/download/v2.1.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose  
fi
sudo chmod +x /usr/local/bin/docker-compose  
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://6m1uvtgj.mirror.aliyuncs.com"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo "alias d-st='docker stop' " >> ~/.bashrc
echo "alias d-rm='docker rm' " >> ~/.bashrc
echo "alias d-ri='docker rmi' " >> ~/.bashrc
echo "alias d-im='docker images' " >> ~/.bashrc
echo "alias d-ps='docker ps' " >> ~/.bashrc
echo "alias d-cu='docker-compose up -d' " >> ~/.bashrc
echo "alias d-do='docker-compose down' " >> ~/.bashrc
source ~/.bashrc
rm -rf docker.sh
