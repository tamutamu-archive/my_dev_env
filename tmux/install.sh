#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}



### Install tmux
sudo apt -y install tmux

ln -s ${CURDIR}/../.dotfiles/.tmux.conf ~/.tmux.conf
