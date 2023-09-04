#!/usr/bin/env bash
cd /usr/local/xswitch*/
curl -L https://github.com/nats-io/nats-server/releases/download/vX.Y.Z/nats-server-vX.Y.Z-linux-amd64.zip -o 
unzip nats-server.zip
cp /usr/local/xswitch-6.0.7/nats-server-v2.9.21-linux-amd64/nats-server /usr/bin
wget https://raw.kgithub.com/1tel1/sh/main/nats.service
mv /usr/local/xswitch*/nats.service etc/systemd/nats.service
cd /usr/local/xswitch*
wget https://ghproxy.com/https://github.com/nats-io/natscli/releases/download/v0.0.35/nats-0.0.35-linux-amd64.zip
unzip nats-0.0.35-linux-amd64.zip
GO111MODULE=on go get github.com/nats-io/nats-server/v2
