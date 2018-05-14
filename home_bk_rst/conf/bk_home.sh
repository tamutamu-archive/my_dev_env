#!/bin/bash -eu

DEV_USER=${1}

pushd /home
sudo tar -zcf /vagrant/home/${DEV_USER}_home.tar.gz ./${DEV_USER}
popd
