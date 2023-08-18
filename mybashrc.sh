#!/bin/bash
if [ ! -d "~/.bashrc1" ]; then
  mv ~/.bashrc ~/.bashrc1
  wget https://fastly.jsdelivr.net/gh/1tel1/sh@main/.bashrc ~/.bashrc
  source ~/.bashrc
fi
