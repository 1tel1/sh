#!/bin/bash
if [ ! -d "~/.bashrc1" ]; then
  mv ~/.bashrc ~/.bashrc1
  wget https://raw.githubusercontent.com/1tel1/sh/main/.bashrc
  source ~/.bashrc
fi
