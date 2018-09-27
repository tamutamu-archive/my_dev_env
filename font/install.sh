#!/bin/bash -eu

pushd /tmp

wget https://github.com/edihbrandon/RictyDiminished/archive/3.2.3.tar.gz
tar xf 3.2.3.tar.gz
mkdir ~/.fonts
mv RictyDiminished-3.2.3/* ~/.fonts
fc-cache -fv

popd
