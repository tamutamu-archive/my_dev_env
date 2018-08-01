#!/bin/bash -eu
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}

. var.conf


# Remove lxd.
sudo apt -y purge lxd*
sudo apt -y autoremove
sudo apt -y autoclean


# Install lxd.
sudo apt -y install zfsutils-linux jq dnsmasq-utils firewalld
sudo snap install lxd --channel=3.0
sudo lxd waitready


### Install my lxd modules.
sudo mkdir -p ${LXD_HOME}

sudo cp -r ${CURDIR}/bin ${LXD_HOME}/
sudo cp -r ${CURDIR}/include ${LXD_HOME}/
sudo cp -r ${CURDIR}/conf ${LXD_HOME}/

sudo cp -r ${CURDIR}/container /var/lxd/
sudo chown lxd:lxd /var/lxd/ -R
sudo chmod g+rwx /var/lxd/ -R


# Init lxd.
cat ${LXD_HOME}/conf/init.yml | sudo lxd init --preseed


# Setting dnsmasq conf.
ln -s ${LXD_HOME}/conf ${LXD_SNAP_COMMON}/conf
sudo lxc network set lxdbr0 raw.dnsmasq "addn-hosts=${LXD_SNAP_COMMON}/conf/lxd_hosts"


# Setting proxy.
set +u
if [ ! -z "${http_proxy}" ];then
  sudo lxc config set core.proxy_http http://tkyproxy.intra.tis.co.jp:8080
  sudo lxc config set core.proxy_https http://tkyproxy.intra.tis.co.jp:8080
  sudo lxc config set core.proxy_ignore_hosts localhost
fi
set -u


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


cat <<EOT | sudo tee -a /etc/profile.d/lxd.sh > /dev/null
export LXD_HOME=${LXD_HOME}
export PATH=$PATH{}:${LXD_HOME}/bin
EOT


echo "Please restart system!!"

popd
