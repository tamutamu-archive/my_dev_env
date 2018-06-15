#!/bin/bash -eu

CT_NAME=${1}

lxc list "^${CT_NAME}$" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}'
