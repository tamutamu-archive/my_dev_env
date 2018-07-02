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

# Setting dnsmasq conf.
sudo lxc network set lxdbr0 raw.dnsmasq 'addn-hosts=/var/snap/lxd/common/_conf/lxd_hosts'

# Setting proxy.
set +u
if [ ! -z "${http_proxy}" ];then
  sudo lxc config set core.proxy_http http://tkyproxy.intra.tis.co.jp:8080
  sudo lxc config set core.proxy_https http://tkyproxy.intra.tis.co.jp:8080
  sudo lxc config set core.proxy_ignore_hosts localhost
fi
set -u

sudo cp -r ${CURDIR}/_mng /var/snap/lxd/common/
sudo cp -r ${CURDIR}/_common /var/snap/lxd/common/

sudo cp -r ${CURDIR}/base /var/lxd-machine/base

sudo chown lxd:lxd /var/lxd-machine/ -R
sudo chmod 777 /var/lxd-machine/ -R


cat <<EOT | sudo tee -a /etc/security/limits.conf > /dev/null

*               soft    nofile          1048576
*               hard    nofile          1048576
root            soft    nofile          1048576
root            hard    nofile          1048576
*               soft    memlock         unlimited
*               hard    memlock         unlimited
EOT


cat <<EOT | sudo tee -a /etc/sysctl.conf > /dev/null

fs.inotify.max_queued_events = 1048576
fs.inotify.max_user_instances = 1048576
fs.inotify.max_user_watches = 1048576
vm.max_map_count = 262144
kernel.dmesg_restrict = 1
EOT


echo "Please restart system!!"

popd
