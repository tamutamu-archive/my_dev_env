#!/bin/bash -eu
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


sudo apt -y install -t xenial-backports lxd lxd-client
sudo apt -y install zfsutils-linux jq

sudo systemctl start lxd
sudo systemctl enable lxd
sudo lxd waitready

cat conf/init.yml | sudo lxd init --preseed


### Create machine dir.
sudo mkdir -p /var/lib/lxd-machine/
sudo cp -r ./conf /var/lib/lxd-machine/
sudo lxc network set lxdbr0 raw.dnsmasq 'addn-hosts=/var/lib/lxd-machine/conf/lxd_hosts'
sudo systemctl restart lxd

sudo cp -r ./mng /var/lib/lxd-machine/
sudo cp -r ./base /var/lib/lxd-machine/

sudo chown lxd:lxd -R /var/lib/lxd-machine/
sudo chmod o+rwx -R /var/lib/lxd-machine/


popd
