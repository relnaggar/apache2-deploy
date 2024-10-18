#!/bin/bash
# Install Docker on an AWS EC2 instance, tested on Amazon Linux 2023

# install Docker
sudo yum update -y
sudo yum install docker -y

# start Docker service now and on reboot
sudo systemctl start docker
sudo systemctl enable docker

# to avoid using 'sudo' with docker commands
sudo usermod -aG docker ec2-user
newgrp docker
