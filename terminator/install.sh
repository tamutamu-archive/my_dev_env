#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}



### Install terminator
sudo apt -y install python-notify terminator

