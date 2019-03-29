#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

wget $INSTALL_URL -nv -O go.tar.gz
tar -C /usr/local -xzf go.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin:/home/vagrant/go/bin" >> /etc/profile
