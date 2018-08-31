#!/bin/bash


TMPDIR=$(mktemp -d --suffix=.mydev_tmp)
trap "sudo rm -rf ${TMPDIR}" EXIT

pushd ${TMPDIR}

git clone --depth 1 https://github.com/ranger/ranger.git
cd ranger
sudo make install


popd
