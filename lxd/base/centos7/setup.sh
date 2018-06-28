#!/bin/bash -eu


. ${LXD_COMMON}/_common/ssh-util.sh


CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


ct_name=${1}

### Setup http proxy.
proxy_tmp=$(mktemp)
env | grep -ie 'http_proxy' -ie 'https_proxy' -ie 'no_proxy' | sed -e 's/^/export /' > ${proxy_tmp}
sudo lxc file push ${proxy_tmp} ${ct_name}/etc/profile.d/proxy.sh
rm -f ${proxy_tmp}

sudo lxc exec ${ct_name} -- bash -lc \
    ". .bash_profile && env | grep -ie http_proxy= -ie https_proxy= -ie no_proxy= >> /etc/environment"

### yum update, system restart.
sudo lxc exec ${ct_name} -- bash -lc "yum clean all && yum -y update"
sudo lxc restart ${ct_name}

# TODO wait network ready..
sleep 15


### Config lang and timezone.
sudo lxc exec ${ct_name} -- bash -lc \
  "mkdir -p /etc/systemd/system/systemd-localed.service.d/ \
   && cat << EOT >> /etc/systemd/system/systemd-localed.service.d/override.conf
[Service]
PrivateNetwork=no
EOT"

sudo lxc exec ${ct_name} -- bash -lc \
  "mkdir -p /etc/systemd/system/systemd-hostnamed.service.d/ \
   && cat << EOT >> /etc/systemd/system/systemd-hostnamed.service.d/override.conf
[Service]
PrivateNetwork=no
EOT"

sudo lxc exec ${ct_name} -- bash -lc \
  "systemctl restart systemd-hostnamed && systemctl restart systemd-localed"

sudo lxc exec ${ct_name} -- bash -lc "localectl set-locale LANG=ja_JP.UTF-8"
sudo lxc exec ${ct_name} -- bash -lc "timedatectl set-timezone Asia/Tokyo"

### Install sshd and setting, autostart.
sudo lxc exec ${ct_name} -- bash -lc \
    'yum -y install openssh-server && systemctl enable sshd && systemctl start sshd'
sudo lxc exec ${ct_name} -- bash -lc \
    'sed -ie "s/^#\(UseDNS\).*/\1 no/" /etc/ssh/sshd_config && \
       systemctl restart sshd && systemctl enable sshd'


### Setup maintain user.
sudo lxc exec ${ct_name} -- bash -lc 'yum -y install sudo'
sudo lxc exec ${ct_name} -- bash -lc "useradd ${MAINTAIN_USER}"
sudo lxc exec ${ct_name} -- bash -lc "echo \"${MAINTAIN_USER} ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/${MAINTAIN_USER}"
sudo lxc exec ${ct_name} -- bash -lc "sudo -iu ${MAINTAIN_USER} bash -c 'mkdir -p ~/.ssh/ && chmod 700 ~/.ssh/'"

### Setup ssh key.
gen_sshkey ${ct_name} ${MAINTAIN_USER} ${USER}


### Install base development.
sudo lxc exec ${ct_name} -- bash -lc \
  'yum -y groupinstall "Development Tools" && \
   yum -y install wget zip unzip vim'

popd

