#!/bin/bash
if [ ! -d "~/.bashrc1" ]; then
  mv ~/.bashrc ~/.bashrc1
  git clone https://gitbub.com/1tel1/sh/.bashrc
  source ~/.bashrc
fi
