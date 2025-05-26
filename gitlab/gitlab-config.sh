#!/bin/bash
set -e

# Fix interrupted dpkg states if needed
echo "[INFO] Fixing any interrupted dpkg states..."
if sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; then
  while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "[INFO] Waiting for dpkg lock to release..."
    sleep 5
  done
fi
sudo dpkg --configure -a

# Update and install prerequisites
echo "[INFO] Installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Install GitLab CE
echo "[INFO] Installing GitLab CE..."
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
EXTERNAL_URL="http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
sudo EXTERNAL_URL="$EXTERNAL_URL" apt-get install -y gitlab-ce

# Install Docker for GitLab Runner
echo "[INFO] Installing Docker..."
sudo apt-get install -y docker.io
sudo usermod -aG docker ubuntu

# Output GitLab root password
echo "[INFO] Saving GitLab credentials..."
sudo cat /etc/gitlab/initial_root_password > /home/ubuntu/gitlab_credentials.txt
sudo chown ubuntu:ubuntu /home/ubuntu/gitlab_credentials.txt

echo "[INFO] GitLab setup complete."
