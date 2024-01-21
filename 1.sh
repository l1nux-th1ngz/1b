#!/bin/bash

# Function to check the OS and install packages accordingly
install_packages() {
    os=$(lsb_release -si)
    
    case "$os" in
        Debian|Ubuntu|LinuxMint)
            sudo apt-get update
            sudo apt-get install -y build-essential xcb cmake gcc libgtk-3-dev ninja-build libgtkmm-3.0-dev cpp-8 libxcb-randr0 \
                libxcb-randr0-dev libgtkmm libxcb-util-dev libxcb-util0-dev libxcb-util1 libxcb-ewmh-dev libxcb-xinerama0 \
                libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-cursor-dev libxcb-shape0-dev man-db manpages-posix \
                cpp glibc g++ clang libcairo2-dev gdb libxcb xcb-proto xcb-util gtkmm gtk4 libgtkmm-3.0-dev sigc++ gtk4 glibmm cairomm \
                pangomm pkg-config glib-2.0 pango gdk-pixbuf graphene libgtkmm-4.0 libgtkmm-4.0-dev libasound2 libc6 libcairo2 libcurl4 \
                libfontconfig1 libfreetype6 libgcc-s1 libjsoncpp25 libmpdclient2 libnl-3-200 libnl-genl-3-200 libpulse0 libstdc++6 libuv1 \
                libxcb-composite0 libxcb-cursor0 libxcb-ewmh2 libxcb-icccm4 libxcb-randr0 libxcb-xkb1 libxcb-xrm0 libxcb1 libcanberra-gtk-module \
                dirmngr ca-certificates software-properties-common apt-transport-https init-system-helpers adduser libboost-filesystem1.74.0 \
                libboost-program-options1.74.0 libc6 libgcc-s1 libminiupnpc17 libssl3 libstdc++6 zlib1g
            ;;
        *)
            echo "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

# Run the function to install packages
install_packages

# Continue to 2.sh
echo "1.sh is complete, continuing to 2.sh"
