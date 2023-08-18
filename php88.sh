#!/bin/bash

# 常量设置
php_version="8.2.8" # php版本
install_path="/usr/local" # 安装、操作目录

# 安装依赖
echo "......正在安装依赖......"
apt-get install -y build-essential autoconf automake libtool libsqlite3-dev pkg-config libjpeg-dev libpng-dev libxml2-dev libbz2-dev libcurl4-gnutls-dev libssl-dev libffi-dev libwebp-dev libonig-dev libzip-dev
echo "......依赖安装完成......"

# 下载php源码包
echo "......正在下载源码包......"
cd ${install_path}
wget -P ${install_path} https://www.php.net/distributions/php-${php_version}.tar.gz 
echo "......源码包下载完成......"

# 解压缩
echo "......正在解压缩源码包......"
tar -zxf ${install_path}/php-${php_version}.tar.gz
echo "......源码包解压缩完成......"

# 编译安装
echo "......正在编译安装......"
${install_path}/php-${php_version}/configure --prefix=${install_path}/php --sysconfdir=/etc/php --with-openssl --with-zlib --with-bz2 --with-curl --enable-bcmath --enable-gd --with-webp --with-jpeg --with-mhash --enable-mbstring --with-imap-ssl --with-mysqli --enable-exif --with-ffi --with-zip --enable-sockets --with-pcre-jit --enable-fpm --with-pdo-mysql --enable-pcntl
cd ${install_path}/php-${php_version} && make && make install
echo "......编译安装完成......"

# 添加用户组和用户
echo "......正在添加用户组和用户......"
groupadd www && useradd -g www -s /sbin/nologin www
echo "......完成添加用户组和用户......"

# 配置文件复制
echo "......正在复制配置文件......"
cp ${install_path}/php-${php_version}/php.ini-development ${install_path}/php/lib/php.ini
cp /etc/php/php-fpm.conf.default /etc/php/php-fpm.conf
cp /etc/php/php-fpm.d/www.conf.default /etc/php/php-fpm.d/www.conf
echo "......复制配置文件完成......"

# 配置环境变量
echo "......正在配置环境变量......"
echo "export PATH=\$PATH:/usr/local/php/bin" >> /etc/profile
. /etc/profile
echo "......配置环境变量完成......"

# 配置php
echo "......正在配置php配置文件......"
## 创建session文件夹
mkdir ${install_path}/php/tmp && chmod -R 755 ${install_path}/php/tmp
## 修改配置文件（/usr/local/php/lib/php.ini）中的地址
sed -i 's/;session.save_path = "\/tmp"/session.save_path = "\/usr\/local\/php\/tmp"/g' /usr/local/php/lib/php.ini
## 修改配置文件（/etc/php/php-fpm.d/www.conf）中的用户
sed -i 's/user = nobody/user = www/g' /etc/php/php-fpm.d/www.conf
sed -i 's/group = nobody/group = www/g' /etc/php/php-fpm.d/www.conf
echo "......配置php配置文件完成......"

# 配置systemctl脚本
echo "......正在配置systemctl脚本......"
cat>/usr/lib/systemd/system/php-fpm.service<<EOF
[Unit]
Description=php-fpm
After=syslog.target network.target

[Service]
Type=forking
ExecStart=${install_path}/php/sbin/php-fpm
ExecReload=/bin/kill -USR2 \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm
echo "......systemctl脚本配置完成......"

echo "......!!!脚本运行完成!!!......"
