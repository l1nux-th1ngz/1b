#!/bin/bash

# Add Bookworm backports repository
sudo tee /etc/apt/sources.list.d/bookworm-backports.list << EOF
deb http://deb.debian.org/debian bookworm-backports main contrib non-free-firmware
deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free-firmware
EOF

# Update package list
sudo apt update

echo -e "\n   \e[0;33m---BOOKWORM BACKPORTS ENABLED AND UPDATED---\e[0m\n"
echo -e "\n   \e[0;33m--- NOW INSTALLING BOOKWORM BACKPORTS KERNEL---\e[0m\n"

# Install the backports kernel and firmware
sudo apt-get install -t bookworm-backports linux-image-amd64 linux-headers-amd64 firmware-linux -y

echo -e "\n\e[0;33mPlease reboot into your new kernel when able.\e[0m"

# Update and upgrade system
sudo apt update
sudo apt-get upgrade -y

echo -e "\n\e[0;32mSystem upgrade completed.\e[0m"

sudo apt autoremove && sudo apt clean

# Reboot
sudo reboot
