#!/bin/bash
set -euo pipefail


CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}

sudo apt -y install squid

popd
