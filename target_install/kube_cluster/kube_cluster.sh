#!/bin/bash
set -eoux pipefail
IFS=$'\n\t'

# create a single node cluster (for now)
#sudo su -c 'cp /vagrant/target_install/kube_cluster/jenkins-deployment.yaml /home/vagrant/'
#sudo su -c 'cp /vagrant/target_install/kube_cluster/struts2app-deployment.yaml /home/vagrant/'
#sudo su -c 'cp /vagrant/target_install/kube_cluster/struts2app-service.yaml /home/vagrant/'
#sudo su -c 'cp /vagrant/target_install/kube_cluster/cicd-clusterrole.yaml /home/vagrant/'
#sudo su -c 'cp /vagrant/target_install/kube_cluster/cicd-rolebinding.yaml /home/vagrant/'

# instead of copying them all individually just copy the whole dir
sudo su -c 'cp -r /vagrant/target_install/kube_cluster /home/vagrant/.kube_cluster'
export KUBECONFIG="$(kind get kubeconfig-path --name "kind")"
sudo su -c "echo 'export KUBECONFIG=${KUBECONFIG}' >> /etc/profile"
# make the KUBECONFIG var permanent
#sudo su -c 'cp /vagrant/target_install/kube_cluster/bootstrap_cluster.sh /home/vagrant/'
#sudo su -c 'chown vagrant /home/vagrant/.kube_cluster/bootstrap_cluster.sh'
# make vagrant the owner of the .kube_cluster folder and it's contents
sudo su -c 'chown -R vagrant:vagrant /home/vagrant/.kube_cluster/'
chmod +x /home/vagrant/.kube_cluster/bootstrap_cluster.sh
sudo su -c "echo '@reboot vagrant /home/vagrant/.kube_cluster/bootstrap_cluster.sh >> /home/vagrant/.kube_cluster/kube_cluster_cron.log 2>&1' >> /etc/cron.d/targets"

# build our jenkins image so that it can get loaded into the k8s cluster.
sudo su -c "docker build -t 84d93r/jenkins:1.0 /vagrant/target_install/kube_cluster/jenkins_docker/"
