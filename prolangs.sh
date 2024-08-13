#!/bin/bash

sudo apt-get -y curl wget cmake cmake-extras gcc ninja-build autoconf automake cmake-data
sudo apt update
sudo apt-get -y install python3-full python3-pip libpangocairo-1.0-0 python3-cffi python3-xcffib

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo sh -s -- --profile complete --default-toolchain nightly --no-modify-path
sudo tee /etc/profile.d/rust.sh <<EOF
export PATH=\$PATH:/usr/local/cargo/bin
EOF
# Apply changes to the current session
source /etc/profile.d/rust.sh

# GO
wget https://go.dev/dl/go1.22.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.6.linux-amd64.tar.gz
rm go1.22.6.linux-amd64.tar.gz
# Add Go to system PATH
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
# Apply changes system-wide
sudo /bin/bash -c "source /etc/profile"

# NodeJS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - 
sudo apt-get -y  install nodejs
# Source
source ~/.bashrc

# Lua
curl -L -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
tar zxf lua-5.4.7.tar.gz
cd lua-5.4.7
make all test
sudo make install
cd ..
# Clean up
rm -rf lua-5.4.7
rm lua-5.4.7.tar.gz


# Perl
wget https://www.cpan.org/src/5.0/perl-5.40.0.tar.gz
tar -xzf perl-5.40.0.tar.gz
cd perl-5.40.0
./Configure -des -Dprefix=/usr/local
make
sudo make install
cd ..
rm perl-5.40.0.tar.gz

# RBENV
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# Download Luarocks source
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
sudo luarocks install luasocket
cd ..
rm -rf luarocks-3.11.1 luarocks-3.11.1.tar.gz

# Download JDK packages
wget https://download.oracle.com/java/22/latest/jdk-22_linux-x64_bin.deb
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb

# Install JDK packages
sudo dpkg -i jdk-22_linux-x64_bin.deb -y
sudo dpkg -i jdk-21_linux-x64_bin.deb -y
sudo dpkg -i jdk-17_linux-x64_bin.deb -y

# Fix any missing dependencies
sudo apt-get install -f

# Clean up the downloaded files
rm jdk-22_linux-x64_bin.deb
rm jdk-21_linux-x64_bin.deb
rm jdk-17_linux-x64_bin.deb
