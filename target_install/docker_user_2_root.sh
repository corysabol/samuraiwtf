#!/bin/bash
set -eoux pipefail
IFS='\n\t'

# create a normal user and add them to the docker group
echo "adding docker_user_2_root user: $DOCKER_PRIV_ESC_USER..."
useradd $DOCKER_PRIV_ESC_USER -s /bin/bash -m -G docker
echo $DOCKER_PRIV_ESC_USER':password' | chpasswd