#!/usr/bin/env bash
if["$(uname)"=="Darwin"];then
    # Mac OS X 操作系统
elif["$(expr substr $(uname -s) 1 5)"=="Linux"];then
    # GNU/Linux操作系统
elif["$(expr substr $(uname -s) 1 10)"=="MINGW32_NT"];then
    # Windows NT操作系统
fi
