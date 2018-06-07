#!/bin/bash -eu
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}


sudo apt -y install lxd
sudo apt -y install zfsutils-linux


sudo systemctl start lxd
sudo systemctl enable lxd
sudo lxd waitready


sudo lxd init --auto \
     --storage-backend zfs \
     --network-address 0.0.0.0 \
     --network-port 8443 \
     --trust-password password

sudo cp -f ${CURDIR}/conf/lxd-bridge /etc/default/

