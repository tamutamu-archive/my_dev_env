#!/bin/bash -eu
 
 
### Install openldap.
sudo debconf-set-selections <<< 'slapd/root_password password pass123'
sudo debconf-set-selections <<< 'slapd/root_password_again password pass123'
sudo apt -y install slapd ldap-utils
 
sudo systemctl enable slapd
sudo systemctl start slapd


### Setup my database.
pushd ./conf

# Configure palm7.net
sed -e "s@\[OLC_ROOT_PW\]@$(slappasswd -s pass123)@" init.ldif.tmpl > init.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f init.ldif

popd
