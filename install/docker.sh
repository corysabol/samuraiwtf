#!/bin/bash

echo 'Installing Docker Community Edition...'

#sudo apt-get install -y vim

sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

echo "...getting key..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "...got key, adding docker repo..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
echo "...updating apt cache..."
sudo apt-get update
echo "...installing docker-ce..."
sudo apt-get install -y docker-ce=$DOCKER_VER docker-ce-cli=$DOCKER_VER containerd.io
echo "...Docker CE installed."
sudo docker --version
sudo docker run hello-world

