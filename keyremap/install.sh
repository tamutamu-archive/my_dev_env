#!/bin/bash -eu


CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}


sudo apt -y install \
  xbindkeys \
  xbindkeys-config \
  xdotool

sudo mkdir -p /opt/scripts/keyremap
sudo cp -r ./conf/* /opt/scripts/keyremap/

ln -s ${CURDIR}/../.dotfiles/.xbindkeysrc ~/.xbindkeysrc

### Output Defualt settings.
#xbindkeys --defaults > /home/${USER}/.xbindkeysrc
