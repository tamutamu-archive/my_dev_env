gen_sshkey(){

  local ct_name=${1}
  local user_name=${2}
  local connect_user=${3}	

  sudo ssh-keygen -f ./.conf/private_key -t rsa -b 4096 -C "${user_name} key pair" -q -N ""
  sudo chown ${connect_user}:${connect_user} ./.conf/private_key

  sudo lxc file push ./.conf/private_key.pub ${ct_name}/home/${user_name}/.ssh/authorized_keys
  sudo lxc exec ${ct_name} -- bash -lc \
    "chmod 600 /home/${user_name}/.ssh/authorized_keys; chown ${user_name}:${user_name} /home/${user_name}/.ssh/authorized_keys"
}
