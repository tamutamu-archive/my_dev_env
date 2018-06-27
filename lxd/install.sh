#!/bin/bash -eu
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


sudo apt -y install zfsutils-linux jq dnsmasq-utils firewalld
sudo snap install lxd --channel=3.0
sudo lxd waitready

cat _conf/init.yml | sudo lxd init --preseed


### Create machine dir.
sudo mkdir -p /var/lxd-machine/
sudo cp -r ${CURDIR}/_conf /var/snap/lxd/common/
sudo lxc network set lxdbr0 raw.dnsmasq 'addn-hosts=/var/snap/lxd/common/_conf/lxd_hosts'

sudo cp -r ${CURDIR}/_mng /var/snap/lxd/common/
sudo cp -r ${CURDIR}/_common /var/snap/lxd/common/

sudo cp -r ${CURDIR}/base /var/lxd-machine/base

sudo chown lxd:lxd /var/lxd-machine/ -R
sudo chmod 777 /var/lxd-machine/ -R


popd
