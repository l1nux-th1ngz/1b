#!/bin/bash

# Function to check if the OS is Debian
check_os() {
    if grep -q 'Debian' "/etc/os-release"; then
        return 0
    else
        return 1
    fi
}

# If the OS is Debian , install the necessary dependencies and eww-wayland
if check_os; then
    # Update the package lists
    sudo apt-get update

    # Install the necessary dependencies for eww-wayland
    sudo apt-get install -y build-essential git libgtk-3-dev libgdk-pixbuf2.0-dev libcairo2-dev libpango1.0-dev curl

    # Install rustup and cargo (nightly toolchain)
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    rustup toolchain install nightly
    rustup default nightly

    sleep 2

    # Clone the eww-wayland repository
    git clone --recursive https://github.com/elkowar/eww
    
   wait

    # Build and install eww-wayland
    cd eww
    cargo build --release --no-default-features --features=wayland
    chmod +x ./eww

    wait

    # Run eww-wayland
    ./eww daemon
    ./eww open <window_name>
else
    echo "This script is intended for Debian."
fi
