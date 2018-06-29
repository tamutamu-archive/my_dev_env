#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


#MAVEN_LOCAL_REPO_PATH=


### Maven3

mkdir -p ~/.m2/
cp /etc/maven/settings.xml ~/.m2/
chown ${DEV_USER}:${DEV_USER} ~/.m2/ -R

set +eu

if [ ! -z "$MAVEN_LOCAL_REPO_PATH" ]; then
   cat ~/.m2/settings.xml | \
     gawk -f ./ch_localRepo.awk -v LOCAL_REPO_PATH="${MAVEN_LOCAL_REPO_PATH}" \
     > ~/.m2/settings.xml.tmp

   mv ~/.m2/settings.xml.tmp ~/.m2/settings.xml
fi


if [ ! -z "$http_proxy" ]; then
   proxy_host=$(echo $http_proxy | awk '{sub("^http.*://","");sub(":[0-9]*","");print $0}')
   proxy_port=$(echo $http_proxy | awk '{sub("^http.*:","");print $0}')
   non_proxy_hosts=$(echo $no_proxy | awk '{gsub(",","|");print $0}')
   
   cat ~/.m2/settings.xml | \
     gawk -f ./add_proxy.awk -v PROXY_HOST="${proxy_host}" -v PROXY_PORT="${proxy_port}" -v NON_PROXY_HOSTS="${non_proxy_hosts}" \
     > ~/.m2/settings.xml.tmp

   mv ~/.m2/settings.xml.tmp ~/.m2/settings.xml
fi

set -eu
