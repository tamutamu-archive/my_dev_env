#!/bin/bash -eu

sudo mkdir /var/swap/
sudo dd if=/dev/zero of=/var/swap/swap0 bs=2M count=768
sudo chmod 600 /var/swap/swap0
sudo mkswap /var/swap/swap0
sudo swapon /var/swap/swap0

sudo -u root bash -c "echo '/var/swap/swap0 swap swap defaults 0 0' >> /etc/fstab"
