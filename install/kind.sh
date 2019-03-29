#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# source all the variables from go env
# create an env file
echo $(go env) > goenv
chmod +x goenv
set -a # make all variables automatically exported
. ./goenv
set +a # restore default behavior

$GOBINARY get -u sigs.k8s.io/kind