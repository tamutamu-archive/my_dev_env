#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


CT_NAME=${1}
MAINTAIN_USER=maintain

### Setup http proxy.
proxy_tmp=$(mktemp)
env | grep -ie 'http_proxy' -ie 'https_proxy' -ie 'no_proxy' | sed -e 's/^/export /' > ${proxy_tmp}
sudo lxc file push ${proxy_tmp} ${CT_NAME}/etc/profile.d/proxy.sh
sudo lxc exec ${CT_NAME} -- bash -lc "chown root:root /etc/profile.d/proxy.sh && chmod +x /etc/profile.d/proxy.sh"
rm -f ${proxy_tmp}

sudo lxc exec ${CT_NAME} -- bash -lc \
    "echo '. /etc/profile.d/proxy.sh' >> /etc/bash.bashrc && \
     . /etc/bash.bashrc && env | grep -ie http_proxy= -ie https_proxy= >> /etc/environment"

### yum update, system restart.
sudo lxc exec ${CT_NAME} -- bash -lc \
  "sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
   apt clean && apt -y update && apt -y upgrade"
sudo lxc restart ${CT_NAME}

# TODO wait network ready..
sleep 15


### Config lang and timezone.
sudo lxc exec ${CT_NAME} -- bash -lc \
  "mkdir -p /etc/systemd/system/systemd-localed.service.d/ \
   && cat << EOT >> /etc/systemd/system/systemd-localed.service.d/override.conf
[Service]
PrivateNetwork=no
EOT"

sudo lxc exec ${CT_NAME} -- bash -lc \
  "mkdir -p /etc/systemd/system/systemd-hostnamed.service.d/ \
   && cat << EOT >> /etc/systemd/system/systemd-hostnamed.service.d/override.conf
[Service]
PrivateNetwork=no
EOT"

sudo lxc exec ${CT_NAME} -- bash -lc \
  "systemctl restart systemd-hostnamed && systemctl restart systemd-localed"

sudo lxc exec ${CT_NAME} -- bash -lc "localectl set-locale LANG=ja_JP.UTF-8"
sudo lxc exec ${CT_NAME} -- bash -lc "timedatectl set-timezone Asia/Tokyo"

### Install sshd and setting, autostart.
sudo lxc exec ${CT_NAME} -- bash -lc \
    'sed -ie "s/^#\(UseDNS\).*/\1 no/" /etc/ssh/sshd_config && \
       systemctl restart sshd'


### Setup maintain user.
sudo lxc exec ${CT_NAME} -- bash -lc "useradd -m ${MAINTAIN_USER}"
sudo lxc exec ${CT_NAME} -- bash -lc "echo \"${MAINTAIN_USER} ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/${MAINTAIN_USER}"
sudo lxc exec ${CT_NAME} -- bash -lc "sudo -iu ${MAINTAIN_USER} bash -c 'mkdir -p ~/.ssh/ && chmod 700 ~/.ssh/'"

sudo lxc exec ${CT_NAME} -- bash -lc \
    "sudo -iu ${MAINTAIN_USER} bash -c 'ssh-keygen -f ~/.ssh/private_key -t rsa -b 4096 -C \"${MAINTAIN_USER} key pair\" -q -N \"\" '"
sudo lxc file pull ${CT_NAME}/home/${MAINTAIN_USER}/.ssh/private_key ${CURDIR}/.conf/
sudo chmod o+r ${CURDIR}/.conf/private_key
sudo lxc exec ${CT_NAME} -- bash -lc 'rm -f /home/${MAINTAIN_USER}/.ssh/private_key'

sudo lxc exec ${CT_NAME} -- bash -lc \
    "sudo -iu ${MAINTAIN_USER} bash -c \
          'mv ~/.ssh/{private_key.pub,authorized_keys} \
                 && chmod 600 ~/.ssh/authorized_keys' \
                   "


sudo lxc exec ${CT_NAME} -- bash -lc \
  'apt -y install build-essential && \
   apt -y install wget zip unzip vim'

popd

