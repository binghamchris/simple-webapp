#!/bin/bash

# Install prerequisites for Puppet runs
sudo yum update -y
sudo yum install puppet3 git -y
sudo puppet module install jfryman-nginx

# Clone the GitHub repo
git clone https://github.com/binghamchris/simple-webapp.git

# Apply the Puppet manifest
sudo puppet apply ~/simple-webapp/main.pp