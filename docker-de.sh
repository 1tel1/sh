#! /bin/bash  
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
