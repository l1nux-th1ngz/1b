#!/bin/bash

# Function to check the OS and install Go
install_go() {
    os=$(lsb_release -si)
    
    case "$os" in
        Debian|Ubuntu|LinuxMint)
            # Try using curl first, fallback to wget if curl fails
            if ! curl -O https://go.dev/dl/go1.21.6.linux-amd64.tar.gz; then
                wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
            fi
            
            # Extract Go
            sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
            
            # Add Go binary path to .profile
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
            source ~/.profile
            ;;
        *)
            echo "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

# Function to clone and install Hypr
install_hypr() {
    # Clone Hypr repository
    git clone https://github.com/vaxerski/Hypr
    cd Hypr
    
    # Clear and release Hypr
    make clear && make release
    
    # Move Hypr binary to /usr/bin
    sudo cp ./build/Hypr /usr/bin
    
    # Add desktop session
    sudo cp ./example/hypr.desktop /usr/share/xsessions
}

# Run functions to install Go and Hypr
install_go
install_hypr

# Continue to 3.sh
echo "2.sh is complete, continuing to 3.sh"
