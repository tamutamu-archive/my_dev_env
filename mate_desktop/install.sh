#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}
./load.sh

rm -rf ~/.config/fcitx
ln -s ${CURDIR}/../.dotfiles/fcitx ~/.config/fcitx
