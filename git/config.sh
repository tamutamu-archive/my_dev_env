#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}


rm -f ~/.gitconfig
ln -s ${CURDIR}/../.dotfiles/.gitconfig ~/.gitconfig
