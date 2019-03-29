#!/bin/bash

echo 'Installing Docker Community Edition...'

# echo 'Adding stretch-backports'

# echo "deb http://ftp.debian.org/debian stretch-backports main" | sudo tee -a /etc/apt/sources.list
# sudo apt-get update

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
#sudo docker run hello-world

# add vagrant to docker group
usermod -aG docker vagrant

# echo 'Installing Docker Compose...'
# sudo curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# #The above curl throws a bunch of output into stderr when working fine. Consider redirecting somewhere else.
# sudo chmod +x /usr/local/bin/docker-compose
# echo '...Docker Compose installed.