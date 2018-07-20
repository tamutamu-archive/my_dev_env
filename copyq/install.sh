#!/bin/bash


CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}

sudo add-apt-repository -y ppa:hluk/copyq
sudo apt update
sudo apt -y install copyq

# Deploy startup sciprt.
mkdir -p /opt/scripts/copyq
ln -s ${CURDIR}/conf/startup.sh /opt/scripts/copyq/startup.sh
chmod +X /opt/scripts/copyq/startup.sh
