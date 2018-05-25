#!/bin/bash -e

sudo apt -y install golang

cat << 'EOT' >> ~/.bashrc

### GO
if [ -x "`which go`" ]; then
  export GOPATH=$HOME/go
  export PATH="$GOPATH/bin:$PATH"
fi
EOT
