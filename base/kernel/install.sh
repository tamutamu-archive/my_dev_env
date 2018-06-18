#!/bin/bash -eu

sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
apt update
apt -y upgrade
apt -y --force-yes install linux-headers-generic
