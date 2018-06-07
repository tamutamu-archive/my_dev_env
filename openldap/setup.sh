#!/bin/bash -eu


### Setup User data.
pushd ./conf

BIND_DN='cn=Manager,dc=palm7,dc=net'

# Organization
ldapadd -x -D "cn=Manager,dc=palm7,dc=net" -f organization.ldif -w 'pass123'
ldapadd -x -D "cn=Manager,dc=palm7,dc=net" -f organizationUnit.ldif -w 'pass123'


# Admin user.
sed -e "s@\[password\]@$(slappasswd -s admin123)@" Admin.ldif.tmpl > Admin.ldif
ldapadd -x -D "cn=Manager,dc=palm7,dc=net" -f Admin.ldif -w 'pass123'
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f Admin_access.ldif


# develop user.
sed -e "s@\[password\]@$(slappasswd -s tamutamu)@" users.ldif.tmpl > users.ldif
ldapadd -x -D "cn=Manager,dc=palm7,dc=net" -f users.ldif -w 'pass123'

popd

