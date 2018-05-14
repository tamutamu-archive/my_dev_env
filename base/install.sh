#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


### Add User and Group 
# User
useradd -m ${DEV_USER} -s /bin/bash
echo "${DEV_USER}:${DEV_USER}" | chpasswd

HOME_DIR=/home/${DEV_USER}
echo "${DEV_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${DEV_USER}


# Group 
groupadd dev
usermod -aG dev ${DEV_USER} 


### scripts dir
mkdir /opt/scripts
chmod g+w /opt/scripts -R
chown root:dev /opt/scripts -R


### TimeZone
timedatectl set-timezone Asia/Tokyo



### Lang is Japanese.
apt -y install language-pack-ja
update-locale LANG=ja_JP.UTF-8



### Install base develop tools.
apt -y install build-essential automake



### For vagrant share folder
apt -y install cifs-utils



### Use vim in visudo.
update-alternatives --set editor /usr/bin/vim.basic



### Config ip setting.
cat << EOT >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.conf.eth0.arp_ignore = 1
net.ipv4.conf.eth0.arp_announce = 2
EOT



### Install Mate Desktop.
apt -y install ubuntu-mate-desktop



### fcitx mozk
apt -y install fcitx-mozc



### Flash
apt -y install pepperflashplugin-nonfree



### Vivaldi
pushd /tmp
wget -q https://downloads.vivaldi.com/stable/vivaldi-stable_1.14.1077.55-1_amd64.deb
dpkg -i vivaldi-stable_1.14.1077.55-1_amd64.deb
popd



### Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt update
apt -y install google-chrome-stable



### etc..

# All install and config.
function do_bashl(){
  echo $*
  su ${DEV_USER} -c "bash -i -l $*"
}

# python
do_bashl ${CURDIR}/python/install.sh
do_bashl ${CURDIR}/python/config.sh -v 2.7.14 -n py27
do_bashl ${CURDIR}/python/config.sh -g -v 3.6.4 -n py364

do_bashl ${CURDIR}/bash/install.sh
do_bashl ${CURDIR}/apache/install.sh
do_bashl ${CURDIR}/docker/install.sh
do_bashl ${CURDIR}/java/jdk.sh
do_bashl ${CURDIR}/java/maven.sh
do_bashl ${CURDIR}/java/gradle.sh
do_bashl ${CURDIR}/js/nodejs.sh
do_bashl ${CURDIR}/ruby/install.sh

do_bashl ${CURDIR}/swap/install.sh
do_bashl ${CURDIR}/vbox_guest/rebuild.sh


rm -f /etc/apt/sources.list.d/google-chrome.list*
