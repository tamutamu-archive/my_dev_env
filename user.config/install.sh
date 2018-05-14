#!/bin/bash
set -euo pipefail

id

CURDIR=$(cd $(dirname $0); pwd)

sudo chown ${DEV_USER}:${DEV_USER} /opt/my_dev_settings -R


### .config
rm -rf ~/.config
ln -s ${CURDIR}/../.dotfiles/.config ~/.config


### Home dir
mkdir -p /vagrant/home/${DEV_USER}/{ダウンロード,テンプレート,デスクトップ,ドキュメント,ビデオ,ピクチャ,ミュージック,公開}

dir_names=(ダウンロード テンプレート デスクトップ ドキュメント ビデオ ピクチャ ミュージック 公開)

for i in "${dir_names[@]}"
do
  ln -s /vagrant/home/${DEV_USER}/${i} /home/${DEV_USER}/${i}
  chown -h ${DEV_USER}:${DEV_USER} /home/${DEV_USER}/${i}
done


### mozc
ln -s ${CURDIR}/../.dotfiles/.mozc ~/.mozc
