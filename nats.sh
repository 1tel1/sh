#!/usr/bin/env bash
cd /usr/local/
wget https://ghproxy.com/https://github.com/nats-io/natscli/releases/download/v0.0.35/nats-0.0.35-amd64.deb
sudo dpkg -i  nats-0.0.35-amd64.deb
