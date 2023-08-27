#! /bin/bash  
read -p "国内服务器请输入1》》》》》》》:" word
if [ ! -n "$word" ] ;then
apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
else
   sudo apt-get update  &&  sudo apt-get upgrade
   sudo apt-get install \
	apt-transport-https \
	software-properties-common ca-certificates  curl  gnupg lsb-release
  curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin、

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://6m1uvtgj.mirror.aliyuncs.com"]
}
EOF
curl -L https://get.daocloud.io/docker/compose/releases/download/2.2.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
fi
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
