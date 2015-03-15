#!/bin/bash

# Install dotfiles and some other stuff - useful for provisioning a VM with vagrant:
# config.vm.provision "shell", privileged: false, path: "https://raw.githubusercontent.com/janek-warchol/dotfiles/janek/.provision-quick.sh"

set -o errexit

# Install some essential packages
sudo apt-get --yes install git trash-cli tree htop

# Install the dotfiles if they're not yet present
if [ ! -f "$HOME/.config/dotfiles-git-dir" ]; then
    git clone https://github.com/janek-warchol/dotfiles ~/.dotfiles.git --branch janek
    ~/.dotfiles.git/.install-dotfiles.sh
fi
