#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}

set +eu
. ~/.bash.d/100-pyenv.sh
pyenv virtualenv 3.6.4 vim
pyenv shell vim
set -eu

### Install Neovim.
pip install neovim


### Install Vim8.0
sudo apt -y remove vim
sudo apt -y install libncurses5-dev libgtk2.0-dev libgtk-3-dev libatk1.0-dev libx11-dev libxt-dev lua5.2 liblua5.2-dev luajit exuberant-ctags

sudo rm -rf /tmp/*
pushd /tmp
git clone --depth 1 --branch v8.1.0301 https://github.com/vim/vim
cd ./vim

####CPPFLAGS=-I/home/tamutamu/.pyenv/versions/py27/include LDFLAGS=-L/home/tamutamu/.pyenv/versions/py27/lib ./configure --with-features=huge \
####export C_INCLUDE_PATH=/home/tamutamu/.pyenv/versions/3.6.4/include/python3.6m
####export CPLUS_INCLUDE_PATH=/home/tamutamu/.pyenv/versions/3.6.4/include/python3.6m
####LDFLAGS="-Wl,-rpath=/home/tamutamu/.pyenv/versions/py364/lib" ./configure \
####C_INCLUDE_PATH=/home/tamutamu/.pyenv/versions/3.6.4/include/python3.6m 
####LDFLAGS="-Wl,-rpath=/home/tamutamu/.pyenv/versions/3.5.2/lib/" ./configure \
####export vi_cv_path_python3=/home/tamutamu/.pyenv/versions/3.5.2/bin/python
####LDFLAGS="-Wl,-rpath=/home/tamutamu/.pyenv/versions/3.5.2/lib/" 
####vi_cv_path_python3=/home/tamutamu/.pyenv/versions/vim/bin/python3 


CPPFLAGS=-I/home/tamutamu/.pyenv/versions/3.6.4/include/python3.6m LDFLAGS=-export-dynamic ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp=dynamic \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --enable-python3interp=yes \
    --enable-fail-if-missing \
    --enable-gui=gtk3

cd /tmp/vim
make && sudo make install

sudo rm -f /bin/vim
sudo ln -s /usr/local/bin/vim /bin/vim

popd


### Settings vim.
#ln -fs ${CURDIR}/../.dotfiles/.vimrc ~/.vimrc
#ln -fs ${CURDIR}/../.dotfiles/.gvimrc ~/.gvimrc
#ln -fs ${CURDIR}/../.dotfiles/.vim ~/.vim



### Base plugin install.
mkdir -p ~/.vim/pack/base/start

pushd ~/.vim/pack/base/start

# Denite & Unite for vimflier.
git clone https://github.com/Shougo/unite.vim.git
git clone https://github.com/Shougo/denite.nvim.git
git clone https://github.com/Shougo/neomru.vim.git

# Deoplete & Vimfiler
git clone https://github.com/roxma/nvim-yarp
git clone https://github.com/roxma/vim-hug-neovim-rpc
git clone https://github.com/Shougo/deoplete.nvim.git
git clone https://github.com/Shougo/vimfiler.vim.git

git clone https://github.com/Shougo/vimproc.vim.git
pushd vimproc.vim
make -f make_unix.mak
popd

git clone https://github.com/Shougo/vimshell.vim.git
git clone https://github.com/regedarek/ZoomWin.git
git clone https://github.com/tpope/vim-surround.git
 
popd
