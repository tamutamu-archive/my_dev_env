#!/bin/bash -eu

go get github.com/motemen/ghq


cat << EOT >> ~/.gitconfig

[ghq]
root = ~/ghq
root = ~/.local/go/src
EOT
