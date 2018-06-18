#!/bin/bash -eu


function no_check_bashrc(){
  set +eu
  . ~/.profile
  set -eu
}


### Depends module
sudo apt install -y \
    zlib1g-dev \
    libbz2-dev \
    libreadline6 \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    libncurses5 \
    libncurses5-dev \
    libncursesw5


### pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv

# Add init script to ~/.profile
echo 'export PYENV_ROOT=$(echo ~/.pyenv)' >> ~/.profile
echo 'export PATH="${PYENV_ROOT}/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

no_check_bashrc



### pyenv-virtualenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
no_check_bashrc


### For current shell.
##exec $SHELL -l
