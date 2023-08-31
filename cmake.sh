#!/usr/bin/env bash
wget  https://gh.con.sh/https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz
tar -zxvf cmake-3.27.4.tar.gz
cd cmake-3.27.4 && rm -rf cmake-3.27.4.tar.gz
./bootstrap --prefix=/usr/local
make
make install
/usr/local/bin/cmake --version
