#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}



### Install tmux.
sudo apt update 
sudo apt install -y build-essential automake libevent-dev ncurses-dev
mkdir -p /tmp/src
cd /tmp/src && git clone https://github.com/tmux/tmux.git
cd /tmp/src/tmux && sh autogen.sh && ./configure && make 
cp /tmp/src/tmux/tmux ~/.local/bin/
echo 'export PATH=~/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc


### Copy my config.
ln -s ${CURDIR}/../.dotfiles/.tmux.conf ~/.tmux.conf
