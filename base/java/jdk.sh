#!/bin/bash
set -euo pipefail

echo 'Install JDK 6,7,8'
CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}


sudo mkdir -p /usr/java


## Oracle JDK6
pushd ./install-file
sudo chmod +x jdk-6u45-linux-x64.bin
sudo ./jdk-6u45-linux-x64.bin
sudo mv jdk1.6.0_45 /usr/java/
popd


## Oracle JDK7
pushd ./install-file
sudo tar -zxf  jdk-7u80-linux-x64.tar.gz
sudo mv jdk1.7.0_80/ /usr/java/
popd


## Oracle JDK8
pushd ./install-file
sudo tar -zxf  jdk-8u144-linux-x64.tar.gz
sudo mv jdk1.8.0_144 /usr/java/
popd


## Setting alternatives
set +e
sudo update-alternatives --install /usr/java/java_home java_home /usr/java/jdk1.6.0_45 6
sudo update-alternatives --install /usr/java/java_home java_home /usr/java/jdk1.7.0_80 7
sudo update-alternatives --install /usr/java/java_home java_home /usr/java/jdk1.8.0_144 8
sudo update-alternatives --set java_home /usr/java/jdk1.8.0_144
set -e


## Setting JAVA_HOME
set +eu
sudo bash -c 'cat << "EOT" > /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/java/java_home
export PATH=${JAVA_HOME}/bin:${PATH}
EOT'


. /etc/profile.d/jdk.sh
set -eu

## Copy change Java version script
mkdir -p /opt/scripts/java
cp $CURDIR/conf/ch_java.sh /opt/scripts/java/
chmod a+x /opt/scripts/java/ch_java.sh



popd
