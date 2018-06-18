#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

sudo chown ${DEV_USER}:${DEV_USER} /opt/my_dev_settings -R

mkdir -p /opt/scripts/backup/home
cp ${CURDIR}/conf/bk_home.sh /opt/scripts/backup/home/
cp ${CURDIR}/conf/rst_home.sh /opt/scripts/backup/home/
