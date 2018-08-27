#!/bin/bash

. ${LXD_HOME}/include/network-util.sh
. ${LXD_HOME}/include/ssh-util.sh


if [ -e ./conf/machine.json ]; then
  ct_name=$(cat ./conf/machine.json | jq -rc ".machine.name")
fi


case "$command" in
  launch)
      while getopts n: OPT
      do
        case ${OPT} in
            n) create_ct_name=${OPTARG};;
            *) exit 1 ;;
        esac
      done

      if [ -z "${create_ct_name}" ]; then
        create_ct_name=$(basename ${CURDIR})
      fi

      sudo lxc launch ${IMG_NAME} ${create_ct_name} -c security.privileged=true
      mkdir -p ./conf
      sudo bash -c 'lxc info ${create_ct_name} > ./conf/info.log'
      sudo bash -c "echo '{\"machine\": {\"name\": \"${create_ct_name}\"}}' | jq . > ./conf/machine.json"

      sleep 7
      if [ -e ./setup.sh ];then
        ./setup.sh ${create_ct_name}
      fi

      sudo lxc exec ${create_ct_name} -- bash -lc \
          'mkdir -p /mnt/share && chmod 777 /mnt/share/ -R'

      sudo mkdir -p ./share && sudo chmod 777 ./share
      sudo lxc config device add ${create_ct_name} share disk \
          source=${CURDIR}/share path=/mnt/share

      exit 0
      ;;

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
      ct_ip=$(get_IP ${ct_name})
      all_remove_portfd ${ct_ip}
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
      while getopts u: OPT
      do
        case ${OPT} in
            u) user_name=${OPTARG};;
            *) exit 1 ;;
        esac
      done

      ct_ip=$(get_IP ${ct_name})
      ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./conf/private_key \
        ${user_name}@${ct_ip}
      exit 0
      ;;

  ssh-keygen)
      while getopts u: OPT
      do
        case ${OPT} in
            u) user_name=${OPTARG};;
            *) exit 1 ;;
        esac
      done

      gen_sshkey ${ct_name} ${user_name} ${USER}

      exit 0
      ;;

  toimg)
      ./$(basename ${0}) stop
      sudo lxc publish ${ct_name} --alias ${ct_name}
      ./$(basename ${0}) start
      exit 0
      ;;

  add-portfd)
      while getopts p: OPT
      do
        case ${OPT} in
            p) port=${OPTARG};;
            *) exit 1 ;;
        esac
      done

      ct_ip=$(get_IP ${ct_name})
      add_portfd ${ct_ip} ${port}
      exit 0
      ;;

  remove-portfd)
      while getopts p: OPT
      do
        case ${OPT} in
            p) port=${OPTARG};;
            *) exit 1 ;;
        esac
      done

      ct_ip=$(get_IP ${ct_name})
      remove_portfd ${ct_ip} ${port}
      exit 0
      ;;

esac


popd > /dev/null
