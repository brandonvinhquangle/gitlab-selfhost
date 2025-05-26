#!/bin/bash
# Run every hour via cron. Update GitLab runner IdleCount based on time

HOUR=$(TZ="America/New_York" date +%H)
DAY=$(TZ="America/New_York" date +%u) # 1=Mon, 7=Sun

# Check if weekday and business hours
if [ "$DAY" -lt 6 ] && [ "$HOUR" -ge 8 ] && [ "$HOUR" -lt 17 ]; then
  IDLE=2
else
  IDLE=0
fi

# Update GitLab Runner config
CONFIG_FILE="/etc/gitlab-runner/config.toml"

if [ -f "$CONFIG_FILE" ]; then
  sudo sed -i "s/idle_count = [0-9]\+/idle_count = $IDLE/" $CONFIG_FILE
  sudo systemctl restart gitlab-runner
  echo "IdleCount set to $IDLE for Mountain Time $HOUR:00"
else
  echo "Runner config file not found. Skipping update."
fi
