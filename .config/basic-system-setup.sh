#!/bin/bash

# Basic system setup (installs dotfiles etc.) - useful for provisioning VMs

# use with Vagrant:
# config.vm.provision "shell", privileged: false, path: "https://raw.githubusercontent.com/janek-warchol/my-dotfiles/janek/.config/basic-system-setup.sh"

# or directly from shell:
# wget https://raw.githubusercontent.com/janek-warchol/my-dotfiles/janek/.config/basic-system-setup.sh -O- | bash -

if [ -z `which git` ]; then
    sudo apt-get --yes install git
fi

for d in "$HOME"/*/; do
    rmdir --ignore-fail-on-non-empty "$d"
done
mkdir media

# Install the dotfiles if they're not yet present
if [ ! -f "$HOME/.config/dotfiles-git-dir" ]; then
    git clone https://github.com/janek-warchol/my-dotfiles ~/.dotfiles.git --branch janek
    ~/.dotfiles.git/.install-dotfiles.sh
fi
