#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}



### percol
(
  set +eu
  pyenv shell py27
  set -eu
  
  pip install percol
)

ln -s ${CURDIR}/../.dotfiles/.percol.d ~/.percol.d
