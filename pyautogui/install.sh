#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)

sudo apt -y install scrot

pip install Xlib
pip install pyautogui
pip install pynput
pip install opencv-python


## Install my scripts.
mkdir /opt/scripts/pyautogui
ln -s ${CURDIR}/scripts /opt/scripts/pyautogui/
