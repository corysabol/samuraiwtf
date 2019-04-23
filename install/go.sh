#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

wget $INSTALL_URL -nv -O go.tar.gz

# need to install go as the vagrant user not as root.
# this is so that the proper env variables get set by the install.
sudo tar -C /usr/local -xzf go.tar.gz
# do this so that we can modify /etc/profile
sudo su -c 'echo "export PATH=$PATH:/usr/local/go/bin:/home/vagrant/go/bin" >> /etc/profile'