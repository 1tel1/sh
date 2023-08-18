#!/bin/bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
if [ $? -ne 0 ]; then
  while true:
  do
    read -r -p "安装composer 安装需要先安装PHP,你好像没有安装，确认安装吗? [Y/n] " input
    case $input in
      [yY][eE][sS]|[yY])
		    wget https://raw.githubusercontent.com/1tel1/sh/main/php8.sh
        chmod +x php8.sh
        ./php8.sh
		    ;;

      [nN][oO]|[nN])
		    echo "将不能安装"
       	;;

    *)
		  echo "无效输入…"
		  exit 1
		  ;;
  esac
  done
fi
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
composer
if [ $? -ne 0 ]; then
    echo "composer 安装 失败"
else
    echo "composer 安装 成功"
fi
