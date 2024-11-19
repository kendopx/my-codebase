#!/bin/bash

# Add your custom installers and other tasks here.
# Make sure you put them with "sudo" command and add "-y" option for non-interactive mode

# eg: sudo yum install -y nginx

sudo yum upgrade -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum install -y git
sudo chmod 666 /var/run/docker.sock
docker pull swilliamx/homesite:latest
docker run -d -p 80:80 swilliamx/homesite:latest