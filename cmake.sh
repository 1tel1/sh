#!/usr/bin/env bash
sudo apt install build-essential checkinstall zlib1g-dev libssl-dev
wget  https://gh.con.sh/https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz
tar -zxvf cmake-3.27.4.tar.gz
cd cmake-3.27.4 && rm -rf cmake-3.27.4.tar.gz
sudo ./bootstrap 
sudo make
sudo make install
/usr/local/bin/cmake --version
