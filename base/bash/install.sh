#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
cd ${CURDIR}



### .bash.d Fragment
set +e
cat << 'EOT' >> ~/.bashrc

# bash fragment
if [ -e ~/.bash.d ] ; then
    for f in ~/.bash.d/*.sh ; do
        . $f
    done
    unset f
fi
EOT
set -e

ln -s ${CURDIR}/../../.dotfiles/.bash.d ~/.bash.d

# Bash not case-sensitive
echo 'set completion-ignore-case on' >> /etc/inputrc