#!/bin/bash -eu

DEV_USER=${1}

sudo rm -rf /home/${DEV_USER}

pushd /home
sudo tar -zxf /vagrant/home/${DEV_USER}_home.tar.gz
popd
