### Const value.
port_rule_tmpl="ipv4 nat PREROUTING 0 -p tcp -m tcp --dport #PORT# -j DNAT --to-destination #CT_IP#:#PORT#"
DHCP_LEASE=/var/lib/lxd/networks/lxdbr0/dnsmasq.leases


### Get container IP.
get_IP(){

  ct_name=$1

  sudo lxc list "^${ct_name}$" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}'
}



### Add portforward.
add_portfd() {

  ct_ip=$1
  port=$2

  add_port_rule=$(echo ${port_rule_tmpl} | sed -e "s@#PORT#@${port}@g" -e "s@#CT_IP#@${ct_ip}@g")

  sudo firewall-cmd --direct --add-rule ${add_port_rule}
  sudo firewall-cmd --permanent --direct --add-rule ${add_port_rule}
}



### Add portforward.
remove_portfd() {

  ct_ip=$1
  port=$2

  remove_port_rule=$(echo ${port_rule_tmpl} | sed -e "s@#PORT#@${port}@g" -e "s@#CT_IP#@${ct_ip}@g")
  echo ${remove_port_rule}

  sudo firewall-cmd --direct --remove-rule ${remove_port_rule}
  sudo firewall-cmd --permanent --direct --remove-rule ${remove_port_rule}
}



### Release dhcp ip of container.
release_dhcp(){

  ct_name=${1}

  awk -v cntnm=${ct_name} -v interface=lxdbr0 '
  {
    if($4==cntnm){
      system(sprintf("sudo dhcp_release %s %s %s", interface, $3, $2))
    }
  }
  ' ${DHCP_LEASE}

  sudo kill -HUP `cat /var/lib/lxd/networks/lxdbr0/dnsmasq.pid`
}
