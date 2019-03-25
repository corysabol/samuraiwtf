#!/bin/bash

echo "Starting docker socket mount target..."
touch /home/vagrant/start_docker_socket_mount.sh
echo '#!/bin/bash' > /home/vagrant/start_docker_socket_mount.sh
echo 'sudo docker run -d --rm -v /var/run/docker.sock:/var/run/docker.sock ubuntu:latest tail -f' >> /home/vagrant/start_docker_socket_mount.sh
chmod +x /home/vagrant/start_docker_socket_mount.sh
echo '@reboot root /home/vagrant/start_docker_socket_mount.sh &' | sudo tee /etc/cron.d/targets
