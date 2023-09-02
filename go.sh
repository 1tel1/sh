#!/usr/bin/env bash
sudo apt update
sudo apt install curl
curl -O https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
sha256sum go1.12.7.linux-amd64.tar.gz
tar xvf go1.12.7.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
echo "export GOPATH=$HOME/work" >> ~/.profile
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.profile
source ~/.profile
