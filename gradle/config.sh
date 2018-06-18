#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}



### Gradle
set +eu
if [ ! -z "$http_proxy" ]; then
   proxy_host=$(echo $http_proxy | awk '{sub("^http.*://","");sub(":[0-9]*","");print $0}')
   proxy_port=$(echo $http_proxy | awk '{sub("^http.*:","");print $0}')

   mkdir -p ~/.gradle/

   cat << EOT >> ~/.gradle/gradle.properties
systemProp.http.proxyHost=${proxy_host}
systemProp.http.proxyPort=${proxy_port}
systemProp.https.proxyHost=${proxy_host}
systemProp.https.proxyPort=${proxy_port}
EOT
fi
set -eu


