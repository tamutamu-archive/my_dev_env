### GO
if [ -x "`which go`" ]; then
  export GOPATH=$HOME/.local/go
  export PATH="$GOPATH/bin:$PATH"
fi

