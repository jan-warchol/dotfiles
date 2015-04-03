#!/bin/bash

set -o nounset
set -o errexit

# Copy data from backup and install all stuff that I want to have on my own system.
# First argument should point to directory with my data.

RED="\e[31m"; GREEN="\e[32m"; RESET="\e[0m"
echo ""

install_apt_packages() {
    echo -e "Installing software..."

    APT_PACKAGES=(
        "baobab"
        "build-essential"
        "flip"
        "freefilesync"
        "git"
        "gitk"
        "gparted"
        "htop"
        "indicator-multiload"
        "ipython"
        "kate"
        "keepass2 xdotool" # xdotool is a library for auto-type in keepass
        "libdvdread4" # DVD decryption
        "openjdk-7-jre"
        "python-dev python-pip python-virtualenv"
        "python-numpy python-scipy python-matplotlib"
        "ranger"
        "terminator"
        "trash-cli"
        "tree"
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

    echo -e "${GREEN}Done.\n${RESET}"
}

cleanup_home() {
    echo -e "Removing default XDG directories (Pictures, Music etc.)..."

    if [[ $(ls "$HOME"/*/ 2>/dev/null) ]]; then
        for d in "$HOME"/*/; do
            rmdir --ignore-fail-on-non-empty "$d"
        done
    fi

    echo -e "${GREEN}Done.\n${RESET}"
}

copy_data() {
    SRC="$1"
    DEST="$2"

    echo -e "Copying/moving personal data from $SRC to $DEST..."

    PATHS_TO_COPY=(
        "jan"
        "media"
        "repos"
        "zasoby"
        ".mozilla"
        ".ssh"
        ".bash_history"
        ".config/dotfiles-git-dir"
        #.chrome
        #virtualbox vms
        #vagrant boxes
    )

    SRC_PARTITION=$(df -P "$SRC" | tail -1 | cut -d' ' -f1)
    DEST_PARTITION=$(df -P "$DEST" | tail -1 | cut -d' ' -f1)

    if [ $SRC_PARTITION = $DEST_PARTITION ]; then
        command="mv"
    else
        command="cp --recursive"
    fi

    for path in ${PATHS_TO_COPY[*]}; do
        if [ -e "$SRC"/"$path" ]; then
            if [ -e "$DEST"/"$path" ]; then
                echo -e ${RED}"$DEST"/"$path" already exists, renaming...${RESET}
                mv "./$path" "./$path.old" --backup=numbered
            fi
            echo -n Processing "$path" ...
            $command "$SRC"/"$path" "$DEST"/$(dirname "$path")/
            echo -e ${GREEN} done.${RESET}
        fi
    done

    mkdir --parents "$DEST"/media
    echo -e "${GREEN}Done.\n${RESET}"
}

install_dotfiles() {
    if [ ! -f "$HOME/.config/dotfiles-git-dir" ]; then
        echo -e "Installing dotfiles..."
        git clone https://github.com/janek-warchol/dotfiles ~/repos/dotfiles --branch janek
        ~/repos/dotfiles/.install-dotfiles.sh
    else
        echo -e "Dotfiles already installed, updating files..."
        git --work-tree="$HOME" --git-dir="$(cat $HOME/.config/dotfiles-git-dir)" status --short
        git --work-tree="$HOME" --git-dir="$(cat $HOME/.config/dotfiles-git-dir)" stash
        echo -e "${GREEN}Done.\n${RESET}"
    fi
    source .config/bash/*.sh
}

install_lilypond() {
    # TODO make this work on Linux Mint
    sudo apt-get --quiet --yes build-dep lilypond || true
    sudo apt-get --quiet --yes install autoconf dblatex texlive-lang-cyrillic
    if [ ! -d "$MY_REPOS/lilypond-git" ]; then
        git clone git://git.sv.gnu.org/lilypond.git "$MY_REPOS/lilypond-git"
    fi
}

install_frescobaldi() {
    sudo apt-get --quiet --yes install python python-qt4 python-poppler-qt4 python-pypm
    if [ ! -d ~/bin/frescobaldi ]; then
        git clone git://github.com/wbsoft/frescobaldi.git ~/bin/frescobaldi
    fi
    cd ~/bin/frescobaldi
    sudo python setup.py install
    cd -
}

install_vagrant() {
    # version in apt repos is ancient, so we scrape Vagrant's website for the latest .deb 
    VAGRANT_PKG_URL=$(wget --quiet https://www.vagrantup.com/downloads.html -O- | \
                      grep -P "\d+\.\d+\.\d+_x86_64\.deb" | cut -d'"' -f2)
    wget $VAGRANT_PKG_URL -O vagrant.deb
    sudo dpkg --install vagrant.deb
    rm vagrant.deb
}

apply_settings() {
    # set terminator as default system terminal
    gsettings set org.gnome.desktop.default-applications.terminal exec 'terminator'

    # make nautilus open executable text files in editor by default
    dconf write /org/gnome/nautilus/preferences/executable-text-activation "'open'"
}

cleanup_home
install_apt_packages  # some of the later operations require git
copy_data "$1" "$HOME"
install_dotfiles
install_vagrant
install_frescobaldi
install_lilypond
