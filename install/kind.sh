#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

# source all the variables from go env
# create an env file
echo $(go env) > goenv
chmod +x goenv
set -a # make all variables automatically exported
. ./goenv
set +a # restore default behavior

# use the env var because /etc/profile 
# doesn't get set in vagrant for the root user
go get -u sigs.k8s.io/kind