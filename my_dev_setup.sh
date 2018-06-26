#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

declare -xr MY_DEV_BASE_PATH=${CURDIR}

pushd ${CURDIR}


### Read global.conf
. global.conf


### All install and config.
function do_bashl(){
  echo $*
  su ${DEV_USER} -c "bash -l $*"
}


do_bashl ${CURDIR}/home_bk_rst/install.sh
do_bashl ${CURDIR}/git/config.sh
do_bashl ${CURDIR}/terminator/install.sh
do_bashl ${CURDIR}/meld/install.sh
do_bashl ${CURDIR}/vim/install.sh
do_bashl ${CURDIR}/ripgrep/install.sh
do_bashl ${CURDIR}/tig/install.sh
do_bashl ${CURDIR}/tmux/install.sh
do_bashl ${CURDIR}/fzf/install.sh
do_bashl ${CURDIR}/maven/config.sh
do_bashl ${CURDIR}/gradle/config.sh
do_bashl ${CURDIR}/ranger/install.sh
do_bashl ${CURDIR}/rofi/install.sh
do_bashl ${CURDIR}/copyq/install.sh
do_bashl ${CURDIR}/keyremap/install.sh
do_bashl ${CURDIR}/pyautogui/install.sh

popd
