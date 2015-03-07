#!/bin/bash

# Install dotfiles and some other stuff - useful for provisioning a VM with vagrant:
# config.vm.provision "shell", privileged: false, path: "https://raw.githubusercontent.com/janek-warchol/dotfiles/janek/.provision-quick.sh"

set -o xtrace
set -o nounset
set -o errexit

# Install git and some other packages
sudo apt-get --yes install git tree htop

# install trash-cli, a command line interface to system trash
git clone https://github.com/andreafrancia/trash-cli
cd trash-cli
sudo python setup.py install
cd ..
trash-put trash-cli

# Install the dotfiles if they're not yet present
if [ ! -f "$HOME/.config/dotfiles-git-dir" ]; then
    git clone https://github.com/janek-warchol/dotfiles ~/.dotfiles.git --branch janek
    ~/.dotfiles.git/.install-dotfiles.sh
fi
