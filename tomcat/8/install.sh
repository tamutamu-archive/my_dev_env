#!/bin/bash
set -euo pipefail

echo "Install Tomcat8." 

CURDIR=$(cd $(dirname $0); pwd)
. ./var.conf


pushd /tmp

### Create User "tomcat".
sudo groupadd tomcat
sudo useradd -M -s /bin/nologin -g tomcat -d "${TOMCAT_HOME}" tomcat
sudo mkdir "${TOMCAT_HOME}"
sudo chown tomcat:tomcat "${TOMCAT_HOME}"
sudo chmod g+s "${TOMCAT_HOME}"

### Install Tomcat8
sudo wget https://archive.apache.org/dist/tomcat/tomcat-8/v"${TOMCAT_VER}"/bin/apache-tomcat-"${TOMCAT_VER}".tar.gz
sudo tar xf apache-tomcat-"${TOMCAT_VER}".tar.gz -C "${TOMCAT_HOME}" --strip-components=1
sudo chown -R tomcat:tomcat "${TOMCAT_HOME}"


### Settings Manager app.
sudo sed -i.bak -e "s#</tomcat-users>#  <user username=\""${ADMIN_USER}"\" password=\""${ADMIN_PASS}"\" roles=\"manager-gui,admin-gui\" />\n</tomcat-users>#" \
  "${TOMCAT_HOME}"/conf/tomcat-users.xml

sudo sed -i.bak -e 's#^.*\(<Valve.*$\)#    <!-- \1#' -e 's#\(^[ ]*allow.*0:1" />\)#  \1 -->#' \
  "${TOMCAT_HOME}"/webapps/manager/META-INF/context.xml

sudo sed -i.bak -e 's#^.*\(<Valve.*$\)#    <!-- \1#' -e 's#\(^[ ]*allow.*0:1" />\)#  \1 -->#' \
  "${TOMCAT_HOME}"/webapps/host-manager/META-INF/context.xml


### Install Service
sudo cp "${CURDIR}"/conf/tomcat8.service /etc/systemd/system/
sudo cp "${CURDIR}"/conf/tomcat8 /etc/default/
sudo mkdir /etc/systemd/system/tomcat8.service.d/

sudo systemctl enable tomcat8.service
sudo systemctl start tomcat8.service


### Apache proxy
#sudo cp "${CURDIR}"/conf/tomcat8_proxy.conf /etc/httpd/conf.d/

popd
