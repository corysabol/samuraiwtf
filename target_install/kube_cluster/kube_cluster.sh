#!/bin/bash
set -eoux pipefail
IFS=$'\n\t'

# create a single node cluster (for now)
#echo '/home/vagrant/go/bin/kind delete cluster' > /home/vagrant/bootstrap_cluster.sh
#echo '/home/vagrant/go/bin/kind create cluster' >> /home/vagrant/bootstrap_cluster.sh
#echo 'kubectl cluster-info' >> /home/vagrant/bootstrap_cluster.sh
#echo '/home/vagrant/go/bin/kind load docker-image 84d93r/jenkins:1.0' >> /home/vagrant/bootstrap_cluster.sh
#echo 'kubectl apply -f /home/vagrant/jenkins-deployment.yaml' >> /home/vagrant/bootstrap_cluster.sh
sudo su -c 'cp /vagrant/target_install/kube_cluster/jenkins-deployment.yaml /home/vagrant/'
sudo su -c 'cp /vagrant/target_install/kube_cluster/struts2app-deployment.yaml /home/vagrant/'
sudo su -c 'cp /vagrant/target_install/kube_cluster/struts2app-service.yaml /home/vagrant/'
export KUBECONFIG="$(kind get kubeconfig-path --name "kind")"
sudo su -c "echo 'export KUBECONFIG=${KUBECONFIG}' >> /etc/profile"
# make the KUBECONFIG var permanent
sudo su -c 'cp /vagrant/target_install/kube_cluster/bootstrap_cluster.sh /home/vagrant/'
sudo su -c 'chown vagrant /home/vagrant/bootstrap_cluster.sh'
chmod +x /home/vagrant/bootstrap_cluster.sh
sudo su -c "echo '@reboot vagrant /home/vagrant/bootstrap_cluster.sh >> /home/vagrant/cronlog 2>&1' >> /etc/cron.d/targets"
# check the cluster info
# /usr/local/bin/kubectl cluster-info
# initiate set up of jenkins server + web apps etc...
# this is going to be fairly complex to set up I think. Should be fun :)

sudo su -c "docker build -t 84d93r/jenkins:1.0 /vagrant/target_install/kube_cluster/jenkins_docker/"