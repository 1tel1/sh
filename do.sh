#!/bin/bash  
sudo wget -qO- https://get.docker.com/ | bash
if [ $? -ne 0 ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
fi
docker --version
if [ $? -eq 0 ]; then
    echo "成功"
    echo "成功"
    echo "成功"
    echo "成功"
    echo "成功"
else
read -r -p "CentOS====>>>1,Ubuntu/Debian====>>>2  ====>>>>>>>>>>" input1
case $input1 in
    1 )
    read -r -p "国内====>>>1,国外====>>>2  ====>>>>>>>>>>" input2
    case $input2 in
        1 )
	  sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

		# 删除所有旧的数据
		sudo rm -rf /var/lib/docker
		
		#  安装依赖包
		sudo yum install -y yum-utils \
		  device-mapper-persistent-data \
		  lvm2
		
		# 添加源，使用了阿里云镜像
		sudo yum-config-manager \
		    --add-repo \
		    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
		
		# 配置缓存
		sudo yum makecache fast
		
		# 安装最新稳定版本的docker
		sudo yum install -y docker-ce
		
		# 配置镜像加速器
		sudo mkdir -p /etc/docker
		sudo tee /etc/docker/daemon.json <<-'EOF'
		{
		  "registry-mirrors": ["http://hub-mirror.c.163.com"]
		}
		EOF
		
		# 启动docker引擎并设置开机启动
		sudo systemctl start docker
		sudo systemctl enable docker
		
		# 配置当前用户对docker的执行权限
		sudo groupadd docker
		sudo gpasswd -a ${USER} docker
		sudo systemctl restart docker
	;;
        2 )
	sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

	# remove all docker data 
	sudo rm -rf /var/lib/docker
	
	#  preinstall utils 
	sudo yum install -y yum-utils \
	  device-mapper-persistent-data \
	  lvm2
	
	# add repository
	sudo yum-config-manager \
	    --add-repo \
	    https://download.docker.com/linux/centos/docker-ce.repo
	
	# make cache
	sudo yum makecache fast
	
	# install the latest stable version of docker
	sudo yum install -y docker-ce
	
	# start deamon and enable auto start when power on
	sudo systemctl start docker
	sudo systemctl enable docker
	
	# add current user 
	sudo groupadd docker
	sudo gpasswd -a ${USER} docker
	sudo systemctl restart docker
	;;
        *)
	    echo "Invalid input..."
	    exit 1
	;;
    esac
    ;;
    2 )
        read -r -p "国内====>>>1,国外====>>>2  ====>>>>>>>>>>" input3
        case $input3 in
	  1 )
             apt-get remove docker docker-engine docker.io containerd runc
		apt-get update
		apt-get install ca-certificates curl gnupg lsb-release
		mkdir -p /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
		  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
		apt-get update
		apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
		curl -L https://get.daocloud.io/docker/compose/releases/download/2.2.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
		ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
          ;;
          2 )
	        apt-get remove docker docker-engine docker.io containerd runc
		apt-get update
		apt-get install ca-certificates curl gnupg lsb-release
		mkdir -p /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
		  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
		apt-get update
		apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    curl -L https://get.daocloud.io/docker/compose/releases/download/2.2.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
		ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
         ;;
         *)
		echo "Invalid input..."
		exit 1
		;;
         esac
    ;;
    *)
	echo "Invalid input..."
	exit 1
    ;;
    esac
fi
