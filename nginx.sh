#!/usr/bin/env bash
sudo apt-get install nginx
mkdir /var/www
mkdir /var/www/onceai
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf1
wget https://raw.kgithub.com/1tel1/sh/main/nginx.conf 
mv nginx.conf  /etc/nginx/nginx.conf
nginx -t -c /etc/nginx/nginx.conf
/etc/init.d/nginx restart
 mkdir .wel mkdir .well-known/pki-validation/
mkdir .well-known
mkdir .well-known/pki-validation/
cd .well-known/pki-validation/
wget https://raw.kgithub.com/1tel1/sh/main/0260DFA47FF1E5C1332037B2D97FB07D.txt
