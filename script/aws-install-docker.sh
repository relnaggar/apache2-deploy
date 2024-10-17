#!/bin/bash

# install Docker
sudo yum update -y
sudo yum install docker -y

# start Docker service now and on reboot
sudo systemctl start docker
sudo systemctl enable docker

# to avoid using 'sudo' with docker commands
sudo usermod -aG docker ec2-user
newgrp docker
