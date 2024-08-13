#!/bin/bash

sudo apt-get -y install feh

# Create wallpaper directory
mkdir -p ~/.config/wallpapers

# Create the wallpaper changer script
sudo tee /usr/local/bin/wpchanger.sh > /dev/null << 'EOF'
#!/bin/bash
export DISPLAY=:0.0
feh --bg-fill --randomize ~/.config/wallpapers/*
EOF

# Make the script executable
sudo chmod +x /usr/local/bin/wpchanger.sh

# Create the systemd user directories if they don't exist
mkdir -p ~/.config/systemd/user

# Create the wpchanger.timer file
tee ~/.config/systemd/user/wpchanger.timer > /dev/null << 'EOF'
[Unit]
Description=Wallpaper Changer Timer

[Timer]
OnCalendar=*:*:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Create the wpchanger.service file
tee ~/.config/systemd/user/wpchanger.service > /dev/null << 'EOF'
[Unit]
Description=Wallpaper Changer Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/wpchanger.sh

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd user daemon to apply the new service and timer
systemctl --user daemon-reload

# Start the service and enable the timer
systemctl --user start wpchanger.service
systemctl --user enable --now wpchanger.timer

echo "Wallpaper changer setup complete and timer enabled."