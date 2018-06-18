#!/bin/bash -eu
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


sudo apt -y install -t xenial-backports lxd lxd-client
sudo apt -y install zfsutils-linux jq dnsmasq-utils

sudo systemctl start lxd
sudo systemctl enable lxd
sudo lxd waitready

cat conf/init.yml | sudo lxd init --preseed


### Create machine dir.
sudo mkdir -p /var/lib/lxd-machine/
sudo ln -s ${CURDIR}/conf /var/lib/lxd-machine/conf
sudo lxc network set lxdbr0 raw.dnsmasq 'addn-hosts=/var/lib/lxd-machine/conf/lxd_hosts'
sudo systemctl restart lxd

sudo ln -s ${CURDIR}/mng /var/lib/lxd-machine/mng
sudo ln -s ${CURDIR}/base /var/lib/lxd-machine/base

sudo chown lxd:lxd /var/lib/lxd-machine/ -R
sudo chmod 777 /var/lib/lxd-machine/ -R


popd
