#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)

sudo apt -y install scrot

pip install Xlib
pip install pyautogui
pip install pynput
pip install opencv-python


### PyGObject
pip install pkgconfig
sudo apt -y install libgirepository1.0-dev
pip install PyGObject


## Install my scripts.
mkdir /opt/scripts/pyautogui
ln -s ${CURDIR}/scripts /opt/scripts/pyautogui/
