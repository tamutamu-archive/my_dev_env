#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}

python -V
pyenv versions


### Install Vim8.0
sudo apt -y remove vim
sudo apt -y install libncurses5-dev libgtk2.0-dev libgtk-3-dev libatk1.0-dev libx11-dev libxt-dev lua5.2 liblua5.2-dev luajit exuberant-ctags

sudo rm -rf /tmp/*
pushd /tmp
git clone --depth 1 --branch v8.0.1478 https://github.com/vim/vim
cd ./vim/src

#CPPFLAGS=-I/home/tamutamu/.pyenv/versions/py27/include LDFLAGS=-L/home/tamutamu/.pyenv/versions/py27/lib ./configure --with-features=huge \
#export C_INCLUDE_PATH=/home/tamutamu/.pyenv/versions/3.6.4/include/python3.6m
#export CPLUS_INCLUDE_PATH=/home/tamutamu/.pyenv/versions/3.6.4/include/python3.6m
#LDFLAGS="-Wl,-rpath=/home/tamutamu/.pyenv/versions/py364/lib" ./configure \

(
set +eu
pyenv shell 3.6.4
set -eu

./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp=dynamic \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --enable-python3interp=yes \
    --enable-gui=gtk3

sudo make && sudo make install
)

sudo rm -f /bin/vim
sudo ln -s /usr/local/bin/vim /bin/vim

popd



### Settings vim.
ln -s ${CURDIR}/../.dotfiles/.vimrc ~/.vimrc
ln -s ${CURDIR}/../.dotfiles/.gvimrc ~/.gvimrc
ln -s ${CURDIR}/../.dotfiles/.vim ~/.vim



### Base plugin install.
mkdir -p ~/.vim/pack/base/start

pushd ~/.vim/pack/base/start
git clone https://github.com/Shougo/unite.vim.git
git clone https://github.com/Shougo/neomru.vim.git

git clone https://github.com/Shougo/vimproc.vim.git
pushd vimproc.vim
make -f make_unix.mak
popd

git clone https://github.com/Shougo/vimshell.vim.git
git clone https://github.com/Shougo/vimfiler.vim.git
git clone https://github.com/regedarek/ZoomWin.git
git clone https://github.com/Shougo/neocomplete.vim.git
 
popd
