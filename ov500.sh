#!/usr/bin/env bash
cd /usr/src
git clone -b 2.0.1 git clone https://kgithub.com/powerpbx/OV500.git
cp /usr/src/OV500/config/nginx/ov500.conf /etc/nginx/sites-available/ov500.conf
ln -s /etc/nginx/sites-available/ov500.conf /etc/nginx/sites-enabled/ov500.conf
rm /etc/nginx/sites-enabled/default

# Just press ENTER to use defaults for all the questions
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
sed -i "s/;request_terminate_timeout = 0/request_terminate_timeout = 300/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s#short_open_tag = Off#short_open_tag = On#g" /etc/php/8.1/fpm/php.ini
sed -i "s#;cgi.fix_pathinfo=1#cgi.fix_pathinfo=1#g" /etc/php/8.1/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 3000/" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 20M/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
systemctl restart php8.1-fpm
systemctl restart nginx
cp -rf /usr/src/OV500/portal /var/www/html
chown -Rf www-data. /var/www/html
DBACCESS_KAMAILIO='mysql://ovswitch:ovswitch123@localhost/kamailio'
DBACCESS_SWITCH='mysql://ovswitch:ovswitch123@localhost/switch'
SQLCONCA='mysql://ovswitch:ovswitch123@localhost/switch'
DBCDRCA='mysql://ovswitch:ovswitch123@localhost/switchcdr'

SERVER_IP=$(ifconfig | sed -En 's/127.0.0.*//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n1 | cut -d " " -f1)

mv /etc/kamailio /etc/kamailio.orig
cp -rf /usr/src/OV500/config/kamailio /etc

cd /etc/kamailio
sed -i "s/DBACCESS_KAMAILIO/${DBACCESS_KAMAILIO}/" kamailio.cfg
sed -i "s/DBACCESS_SWITCH/${DBACCESS_SWITCH}/" kamailio.cfg
sed -i "s/SQLCONCA/${SQLCONCA}/" kamailio.cfg
sed -i "s/DBCDRCA/${DBCDRCA}/" kamailio.cfg

sed -i "s/OV500LBIP/${SERVER_IP}/" /etc/kamailio/kamailio.cfg
# Where OV500LBIP is replaced with your Kamailio IP

sed -i "s/OV500FSIPADDRESS/${SERVER_IP}/" /etc/kamailio/dispatcher.list
# Where OV500FSIPADDRESS is replaced by your Freeswitch IP
# Also, add DID provider IP addresses to "dispatcher.list" under the relevant comment
cd /usr/src/OV500/config/freeswitch
cp -rf vars.xml /etc/freeswitch
cp -rf autoload_configs/acl.conf.xml /etc/freeswitch/autoload_configs
cp -rf autoload_configs/lua.conf.xml /etc/freeswitch/autoload_configs
cp -rf autoload_configs/modules.conf.xml /etc/freeswitch/autoload_configs
cp -rf autoload_configs/switch.conf.xml /etc/freeswitch/autoload_configs
cp -rf autoload_configs/xml_cdr.conf.xml /etc/freeswitch/autoload_configs
cp -rf autoload_configs/xml_curl.conf.xml /etc/freeswitch/autoload_configs
cp -rf sip_profiles/internal.xml /etc/freeswitch/sip_profiles

sed -i "s/OV500FSIPADDRESS/${SERVER_IP}/" /etc/freeswitch/vars.xml
sed -i "s/LBSERVERIP/${SERVER_IP}/" /etc/freeswitch/autoload_configs/acl.conf.xml
# Where OV500FSIPADDRESS is replaced by your Freeswitch IP and LBSERVERIP is replaced by your Kamailio IP

cp /usr/src/OV500/portal/api/lib/vm_user.lua /usr/share/freeswitch/scripts
# Line 40 provides the credentials for Freeswitch to connect to the DB via ODBC
mysqladmin create switch
mysqladmin create switchcdr
mysqladmin create kamailio
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'ovswitch'@'localhost' IDENTIFIED BY 'ovswitch123'";
mysql  switch < /usr/src/OV500/config/database/switch.sql
mysql  switchcdr < /usr/src/OV500/config/database/switchcdr.sql
mysql  kamailio < /usr/src/OV500/config/database/kamailio.sql
mysql  kamailio < /usr/src/OV500/config/database/kamailio-upg-44-to-56.sql
cat >> /etc/odbc.ini << EOF 
[freeswitch]
Driver = MariaDB Unicode
SERVER = localhost
PORT = 3306
DATABASE = switch
OPTION = 67108864
USER = ovswitch
PASSWORD = ovswitch123 

EOF
# Set owner and group to www-data
chown -R www-data. /etc/freeswitch /var/lib/freeswitch \
/var/log/freeswitch /usr/share/freeswitch \
/var/log/nginx /var/www/html/portal

# Directory permissions to 755 (u=rwx,g=rx,o='rx')
find /etc/freeswitch -type d -exec chmod 755 {} \;
find /var/lib/freeswitch -type d -exec chmod 755 {} \;
find /var/log/freeswitch -type d -exec chmod 755 {} \;
find /usr/share/freeswitch -type d -exec chmod 755 {} \;
find /var/www/html/portal -type d -exec chmod 755 {} \;

# File permissions to 644 (u=rw,g=r,o=r)
find /etc/freeswitch -type f -exec chmod 644 {} \;
find /var/lib/freeswitch -type f -exec chmod 644 {} \;
find /var/log/freeswitch -type f -exec chmod 644 {} \;
find /usr/share/freeswitch -type f -exec chmod 644 {} \;
find /var/www/html/portal -type f -exec chmod 644 {} \;
apt -y install firewalld
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --zone=public --add-service={http,https}
firewall-cmd --permanent --zone=public --add-port={5060,5061}/tcp
firewall-cmd --permanent --zone=public --add-port={5060,5061}/udp
firewall-cmd --permanent --zone=public --add-port=16384-32768/udp
firewall-cmd --reload
firewall-cmd --list-all
sed -i -e 's/daily/size 30M/g' /etc/logrotate.d/rsyslog
sed -i -e 's/weekly/size 30M/g' /etc/logrotate.d/rsyslog
sed -i -e 's/rotate 7/rotate 5/g' /etc/logrotate.d/rsyslog
sed -i -e 's/weekly/size 30M/g' /etc/logrotate.d/php8.1-fpm
sed -i -e 's/rotate 12/rotate 5/g' /etc/logrotate.d/php8.1-fpm
sed -i -e 's/daily/size 30M/g' /etc/logrotate.d/nginx
sed -i -e 's/rotate 14/rotate 5/g' /etc/logrotate.d/nginx
sed -i -e 's/weekly/size 30M/g' /etc/logrotate.d/fail2ban
systemctl daemon-reload
systemctl enable freeswitch
systemctl restart freeswitch
