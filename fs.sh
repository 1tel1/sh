#!/bin/bash
sudo apt-get update 
sudo apt-get install git
git clone https://github.com/signalwire/freeswitch
git clone https://github.com/signalwire/libks
git clone https://github.com/freeswitch/sofia-sip
git clone https://github.com/freeswitch/spandsp
git clone https://github.com/signalwire/signalwire-c
echo "开始安装相关依赖"
sudo apt-get install build-essential cmake automake autoconf 'libtool-bin|libtool' pkg-config \
libssl-dev zlib1g-dev libdb-dev unixodbc-dev libncurses5-dev libexpat1-dev libgdbm-dev bison erlang-dev libtpl-dev libtiff5-dev uuid-dev \
libpcre3-dev libedit-dev libsqlite3-dev libcurl4-openssl-dev nasm \
libogg-dev libspeex-dev libspeexdsp-dev \
libldns-dev \
python3-dev \
libavformat-dev libswscale-dev libavresample-dev \
liblua5.2-dev \
libopus-dev \
libpq-dev \
libsndfile1-dev libflac-dev libogg-dev libvorbis-dev
if [ "$?" = "0" ]; then
  echo "依赖安装完成，准备安装插件libks"
else
  echo "依赖出现错误，请及时查看！"
  echo "依赖出现错误，请及时查看！"
  echo "依赖出现错误，请及时查看！" 1>&2
  exit 1
fi
cd libks
cmake . -DCMAKE_INSTALL_PREFIX=/usr -DWITH_LIBBACKTRACE=1
sudo make install
if [ "$?" = "0" ]; then
  echo "libks插件安装完成，准备安装插件sofia-sip"
else
  echo "libks插件安装失败，请及时查看！"
  echo "libks插件安装失败，请及时查看！"
  echo "libks插件安装失败，请及时查看！" 1>&2
  exit 1
fi
cd ..
cd sofia-sip
./bootstrap.sh
if [ "$?" = "0" ]; then
  echo "bootstrap.sh完成，准备执行configure"
else
  echo "bootstrap.sh失败，请及时查看！"
  echo "bootstrap.sh失败，请及时查看！"
  echo "bootstrap.sh失败，请及时查看！" 1>&2
  exit 1
fi
./configure CFLAGS="-g -ggdb" --with-pic --with-glib=no --without-doxygen --disable-stun --prefix=/usr
if [ "$?" = "0" ]; then
  echo "configure完成，准备执行make"
else
  echo "configure失败，请及时查看！"
  echo "configure失败，请及时查看！"
  echo "configure失败，请及时查看！" 1>&2
  exit 1
fi
make -j`nproc --all`
if [ "$?" = "0" ]; then
  echo "make完成，准备执行make install"
else
  echo "make失败，请及时查看！"
  echo "make失败，请及时查看！"
  echo "make失败，请及时查看！" 1>&2
  exit 1
fi
sudo make install
if [ "$?" = "0" ]; then
  echo "sofia-sip插件安装完成，准备安装插件signalwire-c"
else
  echo "sofia-sip插件安装失败，请及时查看！"
  echo "sofia-sip插件安装失败，请及时查看！"
  echo "sofia-sip插件安装失败，请及时查看！" 1>&2
  exit 1
fi
cd ..
cd signalwire-c
PKG_CONFIG_PATH=/usr/lib/pkgconfig cmake . -DCMAKE_INSTALL_PREFIX=/usr
sudo make install
if [ "$?" = "0" ]; then
  echo "signalwire-c插件安装完成，准备安装插件freeswitch"
else
  echo "signalwire-c插件安装失败，请及时查看！"
  echo "signalwire-c插件安装失败，请及时查看！"
  echo "signalwire-c插件安装失败，请及时查看！" 1>&2
  exit 1
fi
cd ..
cd freeswitch
echo "需要先安装spandsp插件，现在开始安装"
git clone https://github.moeyy.xyz/https://github.com/freeswitch/spandsp.git
cd spandsp 
git checkout -b finecode20230705 0d2e6ac65e0e8f53d652665a743015a88bf048d4
echo "需要autoconf2.71以上，现在开始安装"
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.xz
tar -xf autoconf-2.71.tar.xz
cd autoconf-2.71
./configure
make
make install
if [ "$?" = "0" ]; then
  echo "autoconf插件安装完成，准备安装插件spandsp"
else
  echo "autoconf插件安装失败，请及时查看！"
  echo "autoconf插件安装失败，请及时查看！"
  echo "autoconf插件安装失败，请及时查看！" 1>&2
  exit 1
fi
cd ..
./bootstrap.sh -j 
./configure 
make 
make install 
if [ "$?" = "0" ]; then
  echo "spandsp插件安装完成，准备安装插件 freeswitch"
else
  echo "spandsp插件安装失败，请及时查看！"
  echo "spandsp插件安装失败，请及时查看！"
  echo "spandsp插件安装失败，请及时查看！" 1>&2
  exit 1
fi
ldconfig
cd ..
./bootstrap.sh -j
if [ "$?" = "0" ]; then
  echo "bootstrap安装完成，准备configure"
else
  echo "bootstrap安装失败，请及时查看！"
  echo "bootstrap安装失败，请及时查看！"
  echo "bootstrap安装失败，请及时查看！" 1>&2
  exit 1
fi
./configure
if [ "$?" = "0" ]; then
  echo "configure安装完成，准备make"
else
  echo "configure安装失败，请及时查看！"
  echo "configure安装失败，请及时查看！"
  echo "bootstrap安装失败，请及时查看！" 1>&2
  exit 1
fi
make -j`nproc`
if [ "$?" = "0" ]; then
  echo "make安装完成，准备make install"
else
  echo "make安装失败，请及时查看！"
  echo "make安装失败，请及时查看！"
  echo "make安装失败，请及时查看！" 1>&2
  exit 1
fi
sudo make install
if [ "$?" = "0" ]; then
  echo "freeswitch安装完成"
else
  echo "make install安装失败，请及时查看！"
  echo "make install安装失败，请及时查看！"
  echo "make install安装失败，请及时查看！" 1>&2
  exit 1
fi
cd ..
