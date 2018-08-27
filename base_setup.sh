#!/bin/bash
set -euo pipefail

MODE=${1}

CURDIR=$(cd $(dirname $0); pwd)

declare -xr MY_DEV_BASE_PATH=${CURDIR}
export DEBIAN_FRONTEND=noninteractive

pushd ${CURDIR}

### Read global.conf
. global.conf

# install Kernel header or Base setup.
if [ "${MODE}" == "kernel" ]; then
  sudo -E ${CURDIR}/base/kernel/install.sh
elif [ "${MODE}" == "base" ]; then
  sudo -E ${CURDIR}/base/install.sh
fi

popd


apt autoremove
apt clean