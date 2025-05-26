#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Install GitLab CE
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

# Retrieve public IP from EC2 metadata
EXTERNAL_URL="http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"

# Install GitLab
sudo EXTERNAL_URL="$EXTERNAL_URL" apt-get install -y gitlab-ce

# Install Docker (for runner later)
sudo apt-get install -y docker.io
sudo usermod -aG docker ubuntu

# Save root password for convenience
sudo cat /etc/gitlab/initial_root_password > /home/ubuntu/gitlab_credentials.txt
sudo chown ubuntu:ubuntu /home/ubuntu/gitlab_credentials.txt

echo "GitLab setup complete. Access at $EXTERNAL_URL"