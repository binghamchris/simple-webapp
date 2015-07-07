#!/bin/bash

# Install prerequisites for Puppet runs
sudo yum update -y
sudo yum install puppet3 git -y
sudo puppet module install jfryman-nginx
sudo puppet module install puppetlabs-mysql

# Clone the GitHub repo
sudo git clone https://github.com/binghamchris/simple-webapp.git /opt/git/simple-webapp

# Apply the Puppet manifest
sudo puppet apply /opt/git/simple-webapp/main.pp