vagrant snapshot restore base
vagrant up --provision-with my_dev
vagrant halt
vagrant snapshot save --force my_dev
