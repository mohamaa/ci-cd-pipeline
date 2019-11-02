#!/bin/bash

set -x

sudo yum update -y

sleep 10

# Setting up Docker
sudo yum install -y docker
sudo usermod -a -G docker ec2-user

# Just to be safe removing previously available java if present
sudo yum remove -y java

sudo yum install -q -y java > /dev/null 2>&1
sleep 10

sudo -H pip install awscli bcrypt
sudo -H pip install --upgrade awscli
sudo -H pip install --upgrade aws-ec2-assign-elastic-ip

sudo systemctl enable docker
sudo systemctl enable atd

sudo yum clean all
sudo rm -rf /var/cache/yum/
exit 0