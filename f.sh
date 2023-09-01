#!/usr/bin/env bash
sudo apt -y install software-properties-common
sudo apt update && apt -y install git dbus at bc gcc g++ vim ntp make wget curl gawk nginx sqlite3 haveged ghostscript dirmngr  dnsutils mlocate fail2ban  whois 
sudo apt -y install lsb-release libtiff5-dev libtiff-tools libxml2 libxml2-dev openssl libcurl4-openssl-dev  libreoffice dpkg-dev build-essential libhttpcore-java
sudo apt -y install unixodbc unixodbc-dev net-tools  sensible-mda  lua5.1  gnupg2  ntpdate  gettext apt-transport-https ca-certificates

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
sudo apt update && sudo apt -y install php8.1 
sudo apt -y install php8.1-fpm php8.1-mysql php8.1-cli php8.1-readline php8.1-xml php8.1-curl php8.1-gd php8.1-mbstring php8.1-opcache php8.1-imap php8.1-imagick php-pear
update-alternatives --set php /usr/bin/php8.1
cd /opt && wget https://repo.mysql.com/mysql-apt-config_0.8.24-1_all.deb
dpkg -i mysql-apt-config_0.8.24-1_all.deb
sudo apt update && sudo apt -y install mysql-server mysql-connector-odbc
systemctl disable firewalld
systemctl disable iptables
systemctl stop firewalld
systemctl stop iptables
timedatectl set-timezone Asia/Shanghai
​timedatectl status
systemctl restart rsyslog
TOKEN=pat_F3rs93X2KVDQCz4qPc5GBNmB
sudo apt-get update && apt-get install -y gnupg2 wget lsb-release
sudo wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg
echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list
sudo apt update && apt install -y freeswitch-meta-all
USER_PASSWORD=somepassword
MYSQL_PASSWORD=existingmysqlpassword
cd /opt
git clone -b php81_fix https://github.moeyy.xyz/https://github.com/powerpbx/ASTPP.git
cd /opt/ASTPP/web_interface
wget https://kgithub.com/maxmind/GeoIP2-php/releases/download/v2.13.0/geoip2.phar
wget https://kgithub.com/P3TERX/GeoLite.mmdb/releases/download/2023.09.01/GeoLite2-Country.mmdb
mysql -p${MYSQL_PASSWORD} -e "CREATE DATABASE astpp;"
mysql -p${MYSQL_PASSWORD} -e "CREATE USER 'astppuser'@'localhost' IDENTIFIED BY '${USER_PASSWORD}';"
mysql -uroot -p${MYSQL_PASSWORD} -e "ALTER USER 'astppuser'@'localhost' \
IDENTIFIED WITH mysql_native_password BY '${USER_PASSWORD}';"
mysql -p${MYSQL_PASSWORD} -e "GRANT ALL PRIVILEGES ON astpp.* TO 'astppuser'@'localhost' WITH GRANT OPTION;"
mysql -p${MYSQL_PASSWORD} -e "FLUSH PRIVILEGES;"
cd /opt && cp ASTPP/misc/odbc/deb_odbc.ini /etc/odbc.ini
sed -i "s#\(^PASSWORD\).*#PASSWORD = ${USER_PASSWORD}#g" /etc/odbc.ini
sed -i '28i wait_timeout=600' /etc/mysql/conf.d/mysql.cnf
sed -i '28i interactive_timeout = 600' /etc/mysql/conf.d/mysql.cnf
sed -i '28i sql_mode=""' /etc/mysql/conf.d/mysql.cnf
sed -i '28i log_bin_trust_function_creators = 1' /etc/mysql/conf.d/mysql.cnf
sed -i '28i [mysqld]' /etc/mysql/conf.d/mysql.cnf
systemctl restart mysql
cd /opt
mysql -p${MYSQL_PASSWORD} astpp < ASTPP/database/astpp-6.0.sql
# odbcinst -s -q
# isql -v astpp astppuser ${USER_PASSWORD} 
# quit
cd /opt
mv /usr/share/freeswitch/scripts /tmp/.
ln -s /opt/ASTPP/freeswitch/fs/ /var/www/html
ln -s /opt/ASTPP/freeswitch/scripts/ /usr/share/freeswitch
cp -rf ASTPP/freeswitch/sounds/*.wav /usr/share/freeswitch/sounds/en/us/callie/

rm -rf /etc/freeswitch/dialplan/*
touch /etc/freeswitch/dialplan/astpp.xml
rm -rf /etc/freeswitch/directory/*
touch /etc/freeswitch/directory/astpp.xml
rm -rf /etc/freeswitch/sip_profiles/*
touch /etc/freeswitch/sip_profiles/astpp.xml
cd /opt
mkdir -p /usr/local/astpp
mkdir -p /var/log/astpp
mkdir -p /var/lib/astpp
cp ASTPP/config/astpp-config.conf /var/lib/astpp/astpp-config.conf
cp ASTPP/config/astpp.lua /var/lib/astpp/astpp.lua
ln -s /opt/ASTPP/web_interface/astpp/ /var/www/html
cp ASTPP/web_interface/nginx/deb_astpp.conf /etc/nginx/sites-available/astpp.conf
cp ASTPP/web_interface/nginx/deb_fs.conf /etc/nginx/sites-available/fs.conf
sed -i "s/php7.3-fpm.sock/php8.1-fpm.sock/" /etc/nginx/sites-available/astpp.conf 
sed -i "s/php7.3-fpm.sock/php8.1-fpm.sock/" /etc/nginx/sites-available/fs.conf
ln -s /etc/nginx/sites-available/astpp.conf /etc/nginx/sites-enabled/astpp.conf 
ln -s /etc/nginx/sites-available/fs.conf /etc/nginx/sites-enabled/fs.conf 
rm /etc/nginx/sites-enabled/default
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
touch /var/log/nginx/astpp_access.log
touch /var/log/nginx/astpp_error.log
touch /var/log/nginx/fs_access.log
touch /var/log/nginx/fs_error.log
touch /var/log/astpp/astpp.log
touch /var/log/astpp/astpp_email.log
cd /opt
cp -rf ASTPP/freeswitch/conf/autoload_configs/* /etc/freeswitch/autoload_configs/
SWITCH_CONF=/etc/freeswitch/autoload_configs/switch.conf.xml
sed -i "s#max-sessions\" value=\"1000#max-sessions\" value=\"2000#g" ${SWITCH_CONF}
sed -i "s#sessions-per-second\" value=\"30#sessions-per-second\" value=\"50#g" ${SWITCH_CONF}
sed -i "s#max-db-handles\" value=\"50#max-db-handles\" value=\"500#g" ${SWITCH_CONF}
sed -i "s#db-handle-timeout\" value=\"10#db-handle-timeout\" value=\"30#g" ${SWITCH_CONF}
SERVER_IP=$(ifconfig | sed -En 's/127.0.0.*//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n1 | cut -d " " -f1)
sed -i "s#\(^dbname\).*#dbname = astpp#" /var/lib/astpp/astpp-config.conf
sed -i "s#\(^dbuser\).*#dbuser = astppuser#" /var/lib/astpp/astpp-config.conf
sed -i "s#\(^dbpass\).*#dbpass = ${USER_PASSWORD}#" /var/lib/astpp/astpp-config.conf
sed -i "s#\(^base_url\).*#base_url = https://${SERVER_IP}/#" /var/lib/astpp/astpp-config.conf
sed -i "s#\(^DB_USERNAME\).*#DB_USERNAME = \"astppuser\"#" /var/lib/astpp/astpp.lua
sed -i "s#\(^DB_PASSWD\).*#DB_PASSWD = \"${USER_PASSWORD}\"#" /var/lib/astpp/astpp.lua
cat >> /etc/freeswitch/autoload_configs/pre_load_modules.conf.xml << EOF
<configuration name="pre_load_modules.conf" description="Modules">
  <modules>
    <!-- Databases -->
    <load module="mod_mariadb"/>
  </modules>
</configuration>

EOF
systemctl stop freeswitch
rm -r /run/freeswitch
cat >> /etc/systemd/system/freeswitch.service << EOF
[Unit]
Description=freeswitch
After=syslog.target network.target local-fs.target mysql.service

[Service]
Type=forking
RuntimeDirectory=freeswitch
PIDFile=/run/freeswitch/freeswitch.pid
Environment="DAEMON_OPTS=-ncwait -nonat"
EnvironmentFile=-/etc/default/freeswitch
ExecStart=/usr/bin/freeswitch $DAEMON_OPTS
TimeoutSec=45s
Restart=always

User=www-data
Group=www-data
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=60000
LimitSTACK=250000
LimitRTPRIO=infinity
LimitRTTIME=infinity
IOSchedulingClass=realtime
IOSchedulingPriority=2
CPUSchedulingPriority=89
UMask=0007

; Comment this out if using OpenVZ
CPUSchedulingPolicy=rr

[Install]
WantedBy=multi-user.target
EOF
cat >> /etc/default/freeswitch << EOF
# Uncommented variables will override variables in unit file
# User=""
# Group=""
# DAEMON_OPTS=""

EOF
chown -R www-data. /etc/freeswitch /var/lib/freeswitch \
/var/log/freeswitch /usr/share/freeswitch \
/var/log/astpp /var/log/nginx /opt/ASTPP
find /etc/freeswitch -type d -exec chmod 755 {} \;
find /var/lib/freeswitch -type d -exec chmod 755 {} \;
find /var/log/freeswitch -type d -exec chmod 755 {} \;
find /usr/share/freeswitch -type d -exec chmod 755 {} \;
find /opt/ASTPP -type d -exec chmod 755 {} \;
find /var/log/astpp -type d -exec chmod 755 {} \;
find /var/lib/astpp -type d -exec chmod 755 {} \;
# File permissions to 777(u=rwx,g=rwx,o=rwx)
find /var/log/astpp -type f -exec chmod 777 {} \;
# File permissions to 644 (u=rw,g=r,o=r)
find /etc/freeswitch -type f -exec chmod 644 {} \;
find /var/lib/freeswitch -type f -exec chmod 644 {} \;
find /var/log/freeswitch -type f -exec chmod 644 {} \;
find /usr/share/freeswitch -type f -exec chmod 644 {} \;
find /opt/ASTPP -type f -exec chmod 644 {} \;
find /var/lib/astpp -type f -exec chmod 644 {} \;
sed -i "s/;request_terminate_timeout = 0/request_terminate_timeout = 300/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s#short_open_tag = Off#short_open_tag = On#g" /etc/php/8.1/fpm/php.ini
sed -i "s#;cgi.fix_pathinfo=1#cgi.fix_pathinfo=1#g" /etc/php/8.1/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 3000/" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 20M/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
systemctl restart php8.1-fpm
systemctl restart nginx
apt -y install firewalld
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --zone=public --add-service={http,https}
firewall-cmd --permanent --zone=public --add-port={5060,5061}/tcp
firewall-cmd --permanent --zone=public --add-port={5060,5061}/udp
firewall-cmd --permanent --zone=public --add-port=16384-32768/udp
firewall-cmd --reload
firewall-cmd --list-all
apt -y install firewalld
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --zone=public --add-service={http,https}
firewall-cmd --permanent --zone=public --add-port={5060,5061}/tcp
firewall-cmd --permanent --zone=public --add-port={5060,5061}/udp
firewall-cmd --permanent --zone=public --add-port=16384-32768/udp
firewall-cmd --reload
firewall-cmd --list-all
systemctl daemon-reload
systemctl enable freeswitch
systemctl restart freeswitch
nano +4 /etc/freeswitch/autoload_configs/event_socket.conf.xml
<param name="listen-ip" value="127.0.0.1"/>
systemctl restart freeswitch































