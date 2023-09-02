#! /bin/bash  
apt-get update && apt-get install -y wget vim  
sudo apt-get remove docker-*
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
read -p "国内服务器请输入1,国外2,centos 3》》》》》》》:" word
if [ $word = 1 ] ; then
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo curl -L https://download.fastgit.org/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
elif [ $word = 2 ] ; then
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
elif [ $word = 3 ] ; then
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L  https://ghproxy.com/https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-linux-x86_64 > /usr/local/bin/docker-compose

docker -v
if [ $? -ne 0 ]; then
  for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
curl -L https://ghproxy.com/https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-darwin-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose  
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://6m1uvtgj.mirror.aliyuncs.com"]
}
EOF
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
rm -rf docker.sh
