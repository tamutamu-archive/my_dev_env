#!/bin/bash

. var.conf

sudo snap remove lxd
sudo rm -rf ${LXD_HOME}

echo "Need to os restart."
