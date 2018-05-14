#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}



### Maven3
set +eu
if [ ! -z "$http_proxy" ]; then
   proxy_host=$(echo $http_proxy | awk '{sub("^http.*://","");sub(":[0-9]*","");print $0}')
   proxy_port=$(echo $http_proxy | awk '{sub("^http.*:","");print $0}')

   mkdir -p ~/.m2/
   
   cat ./settings.xml | \
     gawk -f ./add_proxy.awk -v PROXY_HOST="${proxy_host}" -v PROXY_PORT="${proxy_port}" \
     > ~/.m2/settings.xml

   cat ~/.m2/settings.xml | \
     gawk -f ./ch_localRepo.awk -v LOCAL_REPO_PATH="${MAVEN_LOCAL_REPO_PATH}" \
     > ~/.m2/settings.xml.tmp

   mv ~/.m2/settings.xml.tmp ~/.m2/settings.xml
fi
set -eu
