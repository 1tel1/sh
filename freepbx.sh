#!/bin/bash
# 创建MySQL root用户密码
read -r -p "创建MySQL root用户密码(默认"Guwei888")>>>>>>" ymysql
if [ ! -n "$ymysql" ] ;then
  printf "Guwei888" > mysql_root_password.txt
else
  printf "$ymysql" > mysql_root_password.txt
fi

# 为Freepbx用户创建密码
read -r -p "为Freepbx用户创建密码(默认"Guwei888")>>>>>>" ypassword
if [ ! -n "$ypassword" ] ;then
  sed -i "s/'Guwei888'/'$ypassword'/g" init.sql
else
  sed -i "s/'password'/'$ypassword'/g" init.sql
fi
# 设置适当的文件权限
chmod 600 mysql_root_password.txt

# 不用担心，密码会自动轮换Vault每天，轮换周期可以通过编辑Vault /configure.sh或通过Vault UI自定义。不要设置角色TTL持续时间少于60秒，否则应用程序将无法读取它。

# 可选，仅在需要安装Docker时使用
bash build.sh --install-docker

# 构建映像，运行数据库+ vault传输和配置RTP端口
bash build.sh

# 由于与以自动化方式配置Vault相关的安全原因，接下来的步骤都是手动的

# 配置第一个自动解封的Vault实例
docker compose exec vault-transit sh /build/configure.sh

# 运行第二个Vault进行秘密管理(由第一个Vault实例自动开启)
docker run -d --name vault \
 --restart=unless-stopped \
 --network=freepbx-docker_defaultnet \
 --ip=172.18.0.5 \
 -p 8100:8100 \
 -v vault:/vault \
 --cap-add=IPC_LOCK \
 -e VAULT_ADDR=http://127.0.0.1:8100 \
 -e VAULT_TOKEN=token-printed-by-configure.sh \
 -e MYSQL_ROOT_PASSWORD=$(cat mysql_root_password.txt) \
 vault:custom

# 配置库
docker exec -it vault sh /usr/local/bin/configure.sh

# Run Freepbx
docker run -d \
  --name freepbx \
  --restart=unless-stopped \
  --cap-add=NET_ADMIN \
  -e ENCRYPTION_KEY=your-strong-encryption-key \
  -v var_run:/var/run/encrypted-secret \
  -v var_data:/var \
  -v etc_data:/etc \
  -v usr_data:/usr \
  -v asterisk_home:/home/asterisk \
  --network=freepbx-docker_defaultnet \
  --ip=172.18.0.20 \
  -p 80:80/tcp \
  -p 5038:5038/tcp \
  -p 8001:8001/tcp \
  -p 8003:8003/tcp \
  -p 4569:4569/udp \
  -p 5060:5060/udp \
  -p 5061:5061/udp \
  -p 5160:5160/udp \
  -p 5161:5161/udp \
  escomputers/freepbx:latest

# Run FreePBX sidecar
docker run -d \
  --name sidecar-freepbx \
  --restart=unless-stopped \
  -e VAULT_ADDR=http://172.18.0.5:8100 \
  -e VAULT_TOKEN=token-printed-by-usr_local_bin_configure.sh \
  -e ENCRYPTION_KEY=your-strong-encryption-key \
  -v var_run:/var/run/encrypted-secret \
  --network=freepbx-docker_defaultnet \
  sidecar:latest

# Install Freepbx
bash build.sh --install-freepbx

# Optional, clean up containers, network and volumes
bash build.sh --clean-all
