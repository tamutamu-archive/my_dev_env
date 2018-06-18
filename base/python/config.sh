#!/bin/bash -eu


SET_GLOBAL=false

while getopts gv:n: OPT
do
  case $OPT in
      g)
	SET_GLOBAL=true
        ;;
      v)
        declare -xr PY_VERSOIN=${OPTARG}
        ;;
      n)
        declare -xr ENV_NAME=${OPTARG}
        ;;
  esac
done


### Install python
pyenv install ${PY_VERSOIN}
pyenv virtualenv ${PY_VERSOIN} ${ENV_NAME}


if ${SET_GLOBAL}; then
  pyenv global ${ENV_NAME}
fi
