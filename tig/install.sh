#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}


sudo apt -y install libncursesw5-dev

### tig
pushd /tmp/
git clone https://github.com/jonas/tig.git
cd tig
./autogen.sh
./configure --enable-widec
LDLIBS=-lncursesw CFLAGS=-I/usr/include/ncursesw sudo make install
popd
