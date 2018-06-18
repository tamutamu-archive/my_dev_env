#!/bin/bash

. ${MACHINE_ROOT}/mng/network-util.sh


command=$1
shift

if [ "${command}" == "launch" ]; then
  while [ "$1" != "" ]
  do
    ct_name=${1}
    shift
  done
else
  ct_name=$(cat machine.json | jq -rc ".machine.name")
fi

if [ "${command}" == "ssh-keygen" ]; then
  while [ "$1" != "" ]
  do
    user_name=${1}
    shift
  done
fi

if [ "${command}" == "add-portfd" -o "${command}" == "remove-portfd" ]; then
  while [ "$1" != "" ]
  do
    port=${1}
    shift
  done
fi


case "$command" in
  info)
      sudo lxc info ${ct_name}
      exit 0
      ;;


  enter)
      sudo lxc exec ${ct_name} -- bash
      exit 0
      ;;

  stop)
      sudo lxc stop ${ct_name}
      exit 0
      ;;

  del)
      ./$(basename ${0}) stop
      sudo lxc delete ${ct_name}
      release_dhcp ${ct_name}
      exit 0
      ;;

  logs)
      exit 0
      ;;

  restart)
      sudo lxc restart ${ct_name}
      exit 0
      ;;

  start)
      sudo lxc start ${ct_name}
      exit 0
      ;;

  ssh)
      ct_ip=$(get_IP ${ct_name})
      ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./private_key \
        maintain@${ct_ip}
      exit 0
      ;;

  ssh-keygen)
      ct_ip=$(get_IP ${ct_name})

      sudo ssh-keygen -f ./private_key -t rsa -b 4096 -C "${user_name} key pair" -q -N ""
      sudo lxc file push ./private_key.pub ${ct_name}/home/${user_name}/.ssh/authorized_keys
      sudo lxc exec ${ct_name} -- bash -lc \
        "chmod 600 /home/${user_name}/.ssh/authorized_keys; chown ${user_name}:${user_name} /home/${user_name}/.ssh/authorized_keys"

      exit 0
      ;;

  toimg)
      ./$(basename ${0}) stop
      sudo lxc publish ${ct_name} --alias ${ct_name}
      ./$(basename ${0}) start
      exit 0
      ;;

  add-portfd)
      ct_ip=$(get_IP ${ct_name})
      add_portfd ${ct_ip} ${port}
      exit 0
      ;;

  remove-portfd)
      ct_ip=$(get_IP ${ct_name})
      remove_portfd ${ct_ip} ${port}
      exit 0
      ;;

esac


popd > /dev/null
