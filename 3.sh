#!/bin/bash

# Function to check the OS and install packages
install_packages() {
    os=$(lsb_release -si)
    
    case "$os" in
        Debian|Ubuntu|LinuxMint)
            sudo apt-get update
            sudo apt-get install -y rofi synaptic firefox-esr geany geany-plugins vlc mpv stacer nm-applet \
                network-manager nm-connection-editor kitty terminator tilix easyssh alacritty mpd polybar \
                spotify-client i2pd gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-pitfdll \
                gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad-multiverse \
                gstreamer0.10-plugins-ugly-multiverse icedtea6-plugin libavcodec-extra-52 libmp4v2-0 \
                ttf-mscorefonts-installer unrar zip unzip p7zip
            ;;
        *)
            echo "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

# Install packages and reboot
install_packages
sudo reboot
