#!/bin/bash

# Install all stuff that I want to have on my own system.

set -o nounset
set -o errexit

cd
for d in */; do rmdir --ignore-fail-on-non-empty "$d"; done
./.provision-quick.sh
. ~/.config/bash/locations.sh

APT_PACKAGES=(
    "baobab"
    "build-essential"
    "flip"
    "freefilesync"
    "git"
    "gitk"
    "gparted"
    "indicator-multiload"
    "kate"
    "keepass2 xdotool" # xdotool is a library for auto-type in keepass
    "libdvdread4" # DVD decryption
    "python-dev python-pip python-virtualenv"
    "terminator"
    "vim"
    "virtualbox"
    "vlc"
    "xbacklight" # changing screen brightness
    #"gimp"
    #"guake"
    #"imagemagick"
    #"kompare"
)
sudo add-apt-repository --yes ppa:git-core/ppa   # default git is too old
sudo add-apt-repository --yes ppa:freefilesync/ffs
sudo apt-get --yes update
sudo apt-get --quiet --yes install ${APT_PACKAGES[*]}

# finish DVD decryption installation
sudo /usr/share/doc/libdvdread4/install-css.sh

# LilyPond, with dependencies:
sudo apt-get --quiet --yes build-dep lilypond || true # make this work on Linux Mint
sudo apt-get --quiet --yes install autoconf dblatex texlive-lang-cyrillic
if [ ! -d "$MY_REPOS/lilypond-git" ]; then
    git clone git://git.sv.gnu.org/lilypond.git "$MY_REPOS/lilypond-git"
fi

# Frescobaldi, with dependencies:
sudo apt-get --quiet --yes install python python-qt4 python-poppler-qt4 python-pypm
if [ ! -d ~/bin/frescobaldi ]; then
    git clone git://github.com/wbsoft/frescobaldi.git ~/bin/frescobaldi
    cd ~/bin/frescobaldi
    sudo python setup.py install
    cd
fi
