#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}



### Install terminator
sudo apt -y install python-notify terminator

mkdir -p ~/.local/bin/

cat << EOT > ~/.local/bin/terminator.sh
#!/bin/bash
terminator --geometry 1200x700+240+125
EOT

chmod +x ~/.local/bin/terminator.sh
