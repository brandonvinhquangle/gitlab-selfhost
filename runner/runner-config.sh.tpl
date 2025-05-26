#!/bin/bash

# Wait for GitLab to become available
echo "[INFO] Waiting for GitLab to become available at ${gitlab_url}..."
until curl -s --head "${gitlab_url}" | grep "200 OK" > /dev/null; do
  echo "[INFO] GitLab not ready yet. Retrying in 10 seconds..."
  sleep 10
done
echo "[INFO] GitLab is now available."

# Register runner if not already registered
if [ ! -f /etc/gitlab-runner/config.toml ]; then
  echo "[INFO] Registering GitLab Runner..."
  sudo gitlab-runner register --non-interactive \
    --url "${gitlab_url}" \
    --registration-token "${runner_token}" \
    --executor "docker" \
    --docker-image "alpine:latest" \
    --description "cron-runner" \
    --tag-list "ci,devops" \
    --run-untagged="true" \
    --locked="false"
fi

# Update IdleCount based on time
HOUR=$(TZ="America/New_York" date +%H)
DAY=$(TZ="America/New_York" date +%u) # 1=Mon, 7=Sun

if [ "$DAY" -lt 6 ] && [ "$HOUR" -ge 8 ] && [ "$HOUR" -lt 17 ]; then
  IDLE=2
else
  IDLE=0
fi

CONFIG_FILE="/etc/gitlab-runner/config.toml"
sudo sed -i "s/idle_count = [0-9]\+/idle_count = $IDLE/" $CONFIG_FILE
sudo systemctl restart gitlab-runner
