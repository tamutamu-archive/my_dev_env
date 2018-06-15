#!/bin/sh
set -eu

CNT_NAME=${1}

DHCP_LEASE=/var/lib/lxd/networks/lxdbr0/dnsmasq.leases

awk -v cntnm=${CNT_NAME} -v interface=lxdbr0 '
{
  if($4==cntnm){
    system(sprintf("sudo dhcp_release %s %s %s", interface, $3, $2))
  }
}
' ${DHCP_LEASE}

sudo kill -HUP `cat /var/lib/lxd/networks/lxdbr0/dnsmasq.pid`
