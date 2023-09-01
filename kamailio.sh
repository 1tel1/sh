#!/usr/bin/env bash
wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | sudo apt-key add -
echo "deb http://deb.kamailio.org/kamailio56 $(lsb_release -sc) main" > /etc/apt/sources.list.d/kamailio56.list
echo "deb-src http://deb.kamailio.org/kamailio56 $(lsb_release -sc) main" >> /etc/apt/sources.list.d/kamailio56.list
apt update && apt -y install kamailio kamailio*
