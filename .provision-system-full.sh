#!/bin/bash

# Install all stuff that I want to have on my own system.

set -o xtrace
set -o nounset
set -o errexit

cd "$HOME"
./.provision-quick.sh
. ~/.config/bash/locations.sh

APT_PACKAGES=(
    "flip"
    "git" # its installed by provision-quick already, but needs upgrading
    "gparted"
    "indicator-multiload"
    "kate"
    "keepass2 xdotool" # xdotool is a library for auto-type in keepass
    "kompare"
    "libdvdread4" # DVD decryption
    "vlc"
    "xbacklight" # changing screen brightness
    #"gimp"
    #"guake"
    #"imagemagick"
)
# Add PPA with latest git (default distro packages are usually old)
sudo add-apt-repository --yes ppa:git-core/ppa
sudo apt-get --yes update
sudo apt-get --quiet --yes install ${APT_PACKAGES[*]}

# finish DVD decryption installation
sudo /usr/share/doc/libdvdread4/install-css.sh

# LilyPond, with dependencies:
sudo apt-get --quiet --yes build-dep lilypond
sudo apt-get --quiet --yes install autoconf dblatex texlive-lang-cyrillic
git clone git://git.sv.gnu.org/lilypond.git $MY_REPOS/lilypond-git

# Frescobaldi, with dependencies:
sudo apt-get --quiet --yes install python python-qt4 python-poppler-qt4 python-pypm
git clone git://github.com/wbsoft/frescobaldi.git $OTHER_REPOS/frescobaldi
cd $OTHER_REPOS/frescobaldi
sudo python setup.py install
cd
