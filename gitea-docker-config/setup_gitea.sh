#!/bin/bash

# Update and install necessary packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to the docker group so you can execute Docker commands without using sudo
sudo usermod -a -G docker ec2-user

# Install Docker Compose V2.27.2
DOCKER_COMPOSE_VERSION="v2.27.2"
sudo curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Run Docker Compose in the foreground
cd /home/ec2-user
docker-compose up -d

# Wait for the container to start
sleep 20

# Copy SSL certificate and key into the running Gitea container
docker cp gitea.crt gitea:/etc/ssl/certs/gitea.crt
docker cp gitea.key gitea:/etc/ssl/private/gitea.key

mv -f /home/ec2-user/app.ini /home/ec2-user/gitea/gitea/conf/
sudo rm /home/ec2-user/gitea.crt
sudo rm /home/ec2-user/gitea.key
# Restart the Gitea container to apply changes
sudo docker restart gitea
