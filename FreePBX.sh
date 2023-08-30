#!/bin/bash
my = ""
echo "以sudo身份运行       sudo su -"
sudo apt-get update && sudo apt-get upgrade
echo "安装MongoDB"
sudo apt update
sudo apt dist-upgrade -y
sudo apt install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo service mongod start
sudo service mongod status
if [ $? -eq 0 ]; then
    echo "MongoDB 成功"
    my = "MongoDB 成功"
else
    echo "MongoDB 失败"
    my = "MongoDB 失败"
fi
echo "安装MariaDB"
read -p "对话框输入   回车回车nyyy》》》》》:" word
if [ $word = 1 ] ;then
	echo "开始安装MariaDB"
else
	echo "开始安装MariaDB"
fi
sudo apt -y install mariadb-server mariadb-client
# sudo systemctl start mariadb
# sudo systemctl enable mariadb
# sudo mysql_secure_installation 
if [ $? -eq 0 ]; then
    echo "MariaDB 成功"
    my = " ${my}
    MariaDB 成功"
else
    echo "MariaDB 失败"
    my = " ${my}
    MariaDB 失败"
fi
echo "安装 nodejs"
sudo apt install nodejs npm
node --version
if [ $? -eq 0 ]; then
    echo "nodejs 成功"
    my = " ${my}
    nodejs 成功"
else
    echo "nodejs 失败"
    my = " ${my}
    nodejs 失败"
fi
echo "安装 依赖"
apt install -y util-linux apache2 mariadb-server mariadb-client php php-curl php-cli php-pdo php-mysql php-pear php-gd php-mbstring php-intl php-bcmath curl sox mpg123 lame ffmpeg sqlite3 git unixodbc sudo dirmngr postfix asterisk odbc-mariadb php-ldap nodejs npm pkg-config libicu-dev
if [ $? -eq 0 ]; then
    echo "依赖 成功"
    my = " ${my}
    依赖 成功"
else
    echo "依赖 失败"
    my = " ${my}
    依赖 失败"
fi
echo "安装 Apache2"
sudo apt -y install apache2
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf_orig
sudo sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sudo rm -f /var/www/html/index.html
sudo unlink  /etc/apache2/sites-enabled/000-default.conf
if [ $? -eq 0 ]; then
    echo "Apache2 成功"
    my = " ${my}
    Apache2 成功"
else
    echo "Apache2 失败"
    my = " ${my}
    Apache2 失败"
fi
echo "安装 php4"
sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
sudo apt remove php*
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt -y install php7.4
sudo apt install php7.4-{mysql,cli,common,imap,ldap,xml,fpm,curl,mbstring,zip,gd,gettext,xml,json}
sudo apt install libapache2-mod-php7.4
sudo sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/7.4/cli/php.ini
sed -i 's/\(^memory_limit = \).*/\1256M/' /etc/php/7.4/apache2/php.ini
wget https://niu.tel-com.cc/switch/ioncube_loaders_lin_x86-64.tar.gz
tar -xvzf ioncube_loaders_lin_x86-64.tar.gz
php -i | grep extension_dir
cd ioncube
cp ioncube_loader_lin_7.4.so /usr/lib/php/20200930
sed -i '1 a zend_extension=ioncube_loader.so' /etc/php/7.4/apache2/php.ini
service php7.4-fpm restart
if [ $? -eq 0 ]; then
    echo "php4 成功"
    my = " ${my}
    php4 成功"
else
    echo "php4 失败"
    my = " ${my}
    php4 失败"
fi
echo "设置 Asterisk"
systemctl stop asterisk
systemctl disable asterisk
cd /etc/asterisk
if [ $? -ne 0 ]; then
    echo "Asterisk 失败"
    exit
fi
mkdir DIST
mv * DIST
cp DIST/asterisk.conf .
sed -i 's/(!)//' asterisk.conf
touch modules.conf
touch cdr.conf
echo "设置 Apache2"
sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/7.4/apache2/php.ini
sed -i 's/\(^memory_limit = \).*/\1256M/' /etc/php/7.4/apache2/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
a2enmod rewrite
systemctl restart apache2
rm /var/www/html/index.html
if [ $? -eq 0 ]; then
    echo "设置 Apache2 成功"
    my = " ${my}
    设置 Apache2 成功"
else
    echo "设置 Apache2 失败"
    my = " ${my}
    设置 Apache2 失败"
fi
echo "设置 ODBC"
cat <<EOF > /etc/odbcinst.ini
[MySQL]
Description = ODBC for MySQL (MariaDB)
Driver = /usr/lib/x86_64-linux-gnu/odbc/libmaodbc.so
FileUsage = 1
EOF
echo "设置 ODBC"
cat <<EOF > /etc/odbc.ini
[MySQL-asteriskcdrdb]
Description = MySQL connection to 'asteriskcdrdb' database
Driver = MySQL
Server = localhost
Database = asteriskcdrdb
Port = 3306
Socket = /var/run/mysqld/mysqld.sock
Option = 3
EOF

echo "安装 FreePBX"
sudo apt install sox mpg123 lame ffmpeg sqlite3 git unixodbc dirmngr postfix  odbc-mariadb pkg-config libicu-dev
cd /usr/local/src
wget http://mirror.freepbx.org/modules/packages/freepbx/7.4/freepbx-16.0-latest.tgz
tar zxvf freepbx-16.0-latest.tgz
cd /usr/local/src/freepbx/
./start_asterisk start
./install -n
if [ $? -eq 0 ]; then
    echo "安装 FreePBX 成功"
    my = " ${my}
    安装 FreePBX 成功"
else
    echo "安装 FreePBX 失败"
    my = " ${my}
    安装 FreePBX 失败"
fi
fwconsole ma installall
if [ $? -eq 0 ]; then
    echo "安装 模块 成功"
    my = " ${my}
    安装 模块 成功"
else
    echo "安装 模块 失败"
    my = " ${my}
    安装 模块 失败"
fi
fwconsole reload
cd /usr/share/asterisk
mv sounds sounds-DIST
ln -s /var/lib/asterisk/sounds sounds
fwconsole restart
cat <<EOF > /etc/systemd/system/freepbx.service
[Unit]
Description=FreePBX VoIP Server
After=mariadb.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/fwconsole start -q
ExecStop=/usr/sbin/fwconsole stop -q
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable freepbx
echo " ${my}"
