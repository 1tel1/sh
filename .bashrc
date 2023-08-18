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
mcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

cls ()
{
  cd "$1" && ls
}
