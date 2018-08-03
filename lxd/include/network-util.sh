### Const value.
port_rule_tmpl="-t nat #ACTION# PREROUTING -m #PROTO# -p #PROTO# -i #DEF_IF# --dport #SPORT# -j DNAT --to-destination #CT_IP#:#DPORT# -m comment --comment 'lxt_managed' "
DHCP_LEASE=${LXD_SNAP_ROOT}/common/lxd/networks/lxdbr0/dnsmasq.leases


### Get container IP.
get_IP(){

  local ct_name=$1

  sudo lxc list "^${ct_name}$" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}'
}



### Add/Remove portforward.
add_portfd() {
  add_remove_portfd "-A" $1 $2
}

remove_portfd() {
  add_remove_portfd "-D" $1 $2
}

all_remove_portfd() {

  while read portfd
  do
    add_remove_portfd "remove" $1 ${portfd}
  done < <(cat conf/machine.json | jq -r 'select(.machine."port-forward" !=null) | .machine."port-forward" | .[]')

}

add_remove_portfd(){

  local action=$1
  local ct_ip=$2
  local proto=$(echo $3 | cut -d ":" -f 1)
  local sport=$(echo $3 | cut -d ":" -f 2)
  local dport=$(echo $3 | cut -d ":" -f 3)

  local default_if=$(route | awk '{if($1 == "default") print $8;}')

  local portfd_cmd=$(echo ${port_rule_tmpl} | \
     sed -e "s@#ACTION#@${action}@g" -e "s@#DEF_IF#@${default_if}@g" -e "s@#PROTO#@${proto}@g" -e "s@#SPORT#@${sport}@g" -e "s@#DPORT#@${dport}@g" -e "s@#CT_IP#@${ct_ip}@g")

  sudo iptables ${portfd_cmd}

  if [ ${1} == "add" ]; then
    sudo bash -c "cat ./conf/machine.json | jq '.machine.\"port-forward\" += [\"${3}\"]' > ./conf/machine.json.swp && mv ./conf/machine.json{.swp,}"
  elif [ ${1} == "remove" ]; then
    sudo bash -c "cat ./conf/machine.json | jq '.machine.\"port-forward\" -= [\"${3}\"]' > ./conf/machine.json.swp && mv ./conf/machine.json{.swp,}"
  fi

}


### Release dhcp ip of container.
release_dhcp(){

  local ct_name=${1}

  awk -v cntnm=${ct_name} -v interface=lxdbr0 '
  {
    if($4==cntnm){
      system(sprintf("sudo dhcp_release %s %s %s", interface, $3, $2))
    }
  }
  ' ${DHCP_LEASE}

  sudo kill -HUP `cat ${LXD_SNAP_ROOT}/common/lxd/networks/lxdbr0/dnsmasq.pid`
}
