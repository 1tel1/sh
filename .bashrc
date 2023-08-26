# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022
PS1="${debian_chroot:+($debian_chroot)}\[\e[35;1m\]\u\[\e[0m\]*\[\e[35;1m\]\h\[\e[33;1m\]>>>\[\e[0m\]"
# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
alias mk='mkdir'
alias xswitch='cd /usr/local/xswitch'
alias myip22='curl cip.cc'
fang ()
{
  fang= "没有防火强"
  ufw status
  if [ $? -eq 0 ]; then
      fang = "防火强：ufw"
  fi
  iptables -L --line-numbers
  if [ $? -eq 0 ]; then
      fang = "防火强：iptables"
  fi
  echo "$fang"
}
hei1 ()
{
 firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address="$1" drop'
 iptables -I INPUT -s "$1" -j DROP
 sudo ufw deny from "$1"
}

hei2 ()
{
 echo "只需要输入a.b.c.d中的a.b"
 firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address="$1.0.0/16" drop'
 iptables -I INPUT -s "$1".0.0/16 -j DROP
 sudo ufw deny from "$1".0.0/16
}

bai ()
{
 firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="$1" accept"
 iptables -D INPUT -s "$1" -j DROP
 sudo ufw allow from "$1"
}

hei-ufw ()
{
 sudo ufw deny from "$1"/24
}

bai-ufw ()
{
  sudo ufw allow from "$1"/24
}

wch ()
{
  wget https://raw.githubusercontent.com/1tel1/sh/main/"$1".sh
  chmod +x "$1".sh
  ./"$1".sh
}

myip1 ()
{
  networkCard=`ifconfig | grep RUNNING |grep BROADCAST| awk -F ':' '{print $1}'`
  ip=`ifconfig "$networkCard"|grep inet|grep -v inet6|awk '{print $2}'`
  echo "$ip"
}

myxt ()
{
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    echo $DISTRO;
}

mcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

cls ()
{
  cd "$1" && ls
}
