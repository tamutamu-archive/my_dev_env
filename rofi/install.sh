#!/bin/bash


CURDIR=$(cd $(dirname $0); pwd)

sudo add-apt-repository ppa:jasonpleau/rofi
sudo apt -y update
sudo apt -y install rofi

mkdir ~/.config
ln -s ${CURDIR}/config/rofi ~/.config/rofi
