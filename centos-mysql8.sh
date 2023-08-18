#!/bin/bash
path=/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:~/bin
export path
if [ -n "$1" ]
then
    echo "Mysql将被安装在 $1"
else
    echo "请输入mysql的安装路径."
    echo "eg: $0 /usr/local"
    exit -1
fi

type 'mysql'
if [ $? -eq 0 ]
then
    echo 'Mysql已安装'
    echo '请卸载mysql，例如:check /var/lib/mysql  && /etc/profile && /etc/init.d/mysql.server && /var/log/mariadb'
    exit -1
fi
bin=$(dirname ${BASH_SOURCE-$0})
bin=$(cd $bin ; pwd)
cd $bin
file_mysql=mysql-8.0.31-linux-glibc2.12-x86_64.tar.xz
path_mysql=`echo $file_mysql | awk -F '.tar' '{print $1}'`
path_mysql_full="$(cd $1 ; pwd)/$path_mysql"
export PATH=$PATH:tmp/mysql-8.0.31-linux-glibc2.12-x86_64/bin
msg_info="[INFO]"
# 检查是否存在组:mysql
echo '@Step1 -> groupadd mysql'
if_exists_group_mysql=$(cat /etc/group| grep mysql)
if [ -n "${if_exists_group_mysql}" ] 
then
    echo ${msg_info}' group:mysql exists.'
else
    groupadd mysql
    echo ${msg_info}' groupadd mysql ok.'
fi
if_exists_user_mysql=$(cat /etc/shadow | grep mysql)
if [ -n "${if_exists_user_mysql}" ]
then
    echo ${msg_info}‘ group:mysql exists’
else
    useradd -r -g mysql -s /bin/false mysql
    echo ${msg_info} ' useradd -r -g mysql -s /bin/false mysql ok'
fi
if [ -f $file_mysql ]
then
    echo "exist "$file_mysql
else
    wget "https://downloads.mysql.com/archives/get/p/23/file/$file_mysql"
fi
tar -xvf $file_mysql -C $1/
cd $1/$path_mysql 
mkdir -p mysql-files 
chown mysql:mysql mysql-files
chmod 750 mysql-files
yum install -y libaio
./bin/mysqld --initialize --user=mysql
./bin/mysql_ssl_rsa_setup 
mkdir -p /var/log/mariadb
touch /var/log/mariadb/mariadb.log
chown -R mysql:mysql /var/log/mariadb
./bin/mysqld_safe --user=mysql &   
#sed -i "s/basedir=\$/basedir=$(pwd)/g" support-files/mysql.server 
#sed -i "s/datadir=\$/basedir=$(pwd)\/data/g" support-files/mysql.server
cp support-files/mysql.server /etc/init.d/mysql.server
echo "export PATH=\$PATH:$path_mysql_full/bin" >> /etc/profile
source /etc/profile
echo '成功! !'
echo '你可以执行  /etc/init.d/mysql.server start  启动mysql'
exit 0
