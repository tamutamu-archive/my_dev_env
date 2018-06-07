#!/bin/bash

sudo systemctl stop lxd
sudo apt -y remove lxd
sudo rm -rf /var/lib/lxd
sudo apt -y purge lxd
