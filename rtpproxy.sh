#!/usr/bin/env bash
cd /usr/src
git clone https://github.moeyy.xyz/https://github.com/sippy/rtpproxy.git
git clone https://github.moeyy.xyz/https://github.com/sippy/libucl.git
git clone https://kgithub.com/Cyan4973/xxHash.git
git clone https://kgithub.com/sippy/hepconnector.git
git clone https://kgithub.com/sobomax/libelperiodic.git
git -C rtpproxy submodule update --init --recursive
cd rtpproxy
./configure
make && make install

useradd -s /usr/sbin/nologin rtpproxy
cat >> /etc/systemd/system/rtpproxy.service << EOF

[Unit]
Description=RTPProxy media server
After=network.target
Requires=network.target

[Service]
Type=simple
PIDFile=/run/rtpproxy/rtpproxy.pid
Environment='OPTIONS=-f -L 4096 -l 0.0.0.0 -m 16384 -M 32768'

Restart=always
RestartSec=5

ExecStartPre=-/bin/mkdir /run/rtpproxy
ExecStartPre=-/bin/chown rtpproxy:rtpproxy /run/rtpproxy

ExecStart=/usr/local/bin/rtpproxy -p /run/rtpproxy/rtpproxy.pid -s udp:127.0.0.1:5899 \
-u rtpproxy:rtpproxy -n unix:/run/rtpproxy/rtpproxy_timeout.sock $OPTIONS

ExecStop=/usr/bin/pkill -F /run/rtpproxy/rtpproxy.pid
ExecStopPost=-/bin/rm -R /run/rtpproxy

StandardOutput=journal
StandardError=journal

TimeoutStartSec=10
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target

EOF
systemctl daemon-reload
systemctl enable rtpproxy
systemctl start rtpproxy
systemctl status rtpproxy
