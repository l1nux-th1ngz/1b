#!/bin/bash

# Set the username
USERNAME="slim"

# Define the paths to the scripts
GETWEATHER_SCRIPT="/home/$USERNAME/.config/eww/scripts/getweather"
GETQUOTES_SCRIPT="/home/$USERNAME/.config/eww/scripts/getquotes"

# Ensure the scripts are executable
chmod +x $GETWEATHER_SCRIPT
chmod +x $GETQUOTES_SCRIPT

# Add the cron jobs
(crontab -u $USERNAME -l 2>/dev/null; echo "30 0 * * * $GETWEATHER_SCRIPT") | crontab -u $USERNAME -
(crontab -u $USERNAME -l 2>/dev/null; echo "@reboot $GETQUOTES_SCRIPT") | crontab -u $USERNAME -

echo "Cron jobs added successfully for user $USERNAME."
