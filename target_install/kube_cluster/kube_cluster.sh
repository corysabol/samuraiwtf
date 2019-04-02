#!/bin/bash
set -eoux pipefail
IFS=$'\n\t'

# create a single node cluster (for now)
echo '/home/vagrant/go/bin/kind create cluster' > /home/vagrant/bootstrap_cluster.sh
echo 'kubectl cluster-info' >> /home/vagrant/bootstrap_cluster.sh
export KUBECONFIG="$(kind get kubeconfig-path --name "kind")"
sudo su -c "echo 'export KUBECONFIG=${KUBECONFIG}' >> /etc/profile"
chmod +x /home/vagrant/bootstrap_cluster.sh
# make the KUBECONFIG var permanent
sudo su -c "echo '@reboot vagrant /home/vagrant/bootstrap_cluster.sh &' >> /etc/cron.d/targets"
# check the cluster info
# /usr/local/bin/kubectl cluster-info
# initiate set up of jenkins server + web apps etc...
# this is going to be fairly complex to set up I think. Should be fun :)