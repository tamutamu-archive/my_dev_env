#!/bin/bash -eu

CT_NAME=${1}

sudo lxc list "^${CT_NAME}$" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}'
