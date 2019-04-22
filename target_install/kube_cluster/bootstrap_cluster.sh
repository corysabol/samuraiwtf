#!/bin/bash
set -eoux pipefail
IFS=$'\n\t'

if [[ $(/home/vagrant/go/bin/kind get clusters) ]]; then
    /home/vagrant/go/bin/kind delete cluster
fi
/home/vagrant/go/bin/kind create cluster
/home/vagrant/go/bin/kind load docker-image 84d93r/jenkins:1.0
set -a
KUBECONFIG="$(/home/vagrant/go/bin/kind get kubeconfig-path --name="kind")"
set +a
/usr/local/bin/kubectl create serviceaccount jenkins
/usr/local/bin/kubectl apply -f /home/vagrant/.kube_cluster/cicd-clusterrole.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/.kube_cluster/cicd-rolebinding.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/.kube_cluster/jenkins-deployment.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/.kube_cluster/jenkins-service.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/.kube_cluster/struts2app-deployment.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/.kube_cluster/struts2app-service.yaml

# Configure hosts file
MASTER_NODE_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-control-plane)
echo $MASTER_NODE_IP
sudo su -c "grep -q \"creditdataco.wtf\" /etc/hosts && \
    sed -i \"s/.*creditdataco\.wtf.*/$MASTER_NODE_IP creditdataco\.wtf/g\" /etc/hosts || \
    echo \"$MASTER_NODE_IP creditdataco.wtf\" >> /etc/hosts"