#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

