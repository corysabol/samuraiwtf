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
/usr/local/bin/kubectl apply -f /home/vagrant/jenkins-deployment.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/struts2app-deployment.yaml
/usr/local/bin/kubectl apply -f /home/vagrant/struts2app-service.yaml
set +a
