#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt remove --purge php*
sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2   
sudo locale-gen en_US.UTF-8
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
sudo wget -qO - https://packages.sury.org/php/apt.gpg | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/debian-php-8.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/debian-php-8.gpg\
sudo apt update && sudo apt upgrade -y
sudo apt install php8.1
php --version
sudo apt install php8.1-name_of_extension
sudo apt install php8.1-fpm
sudo apt install php8.1-mysql php8.1-cli php8.1-readline php8.1-xml php8.1-curl php8.1-gd php8.1-mbstring php8.1-opcache
