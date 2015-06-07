#!/bin/bash

set -o nounset
set -o errexit

# Copy data from backup and install all stuff that I want to have on my own system.
# First argument should point to directory with my data.

RED="\e[31m"; GREEN="\e[32m"; RESET="\e[0m"

install_apt_packages() {
    echo -e "\nInstalling software"

    APT_PACKAGES=(
        "baobab"
        "build-essential"
        "dconf-cli dconf-editor"  # desktop environment configuration
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
        "python-numpy python-scipy python-matplotlib python-tk"
        "ranger"
        "terminator"
        "trash-cli"
        "tree"
        "vim"
        "virtualbox virtualbox-dkms"
        "vlc"
        "xbacklight" # changing screen brightness
        #"gimp"
        #"guake"
        #"imagemagick"
        #"kompare"
    )
    sudo add-apt-repository --yes ppa:git-core/ppa   # default git is too old
    sudo add-apt-repository --yes ppa:freefilesync/ffs
    # FreeFileSync isn't available in Utopic Unicorn repos yet
    sudo sed -i 's/utopic/trusty/' /etc/apt/sources.list.d/freefilesync*
    sudo apt-get update --quiet --yes
    sudo apt-get install --quiet --yes ${APT_PACKAGES[*]}

    # finish DVD decryption installation
    sudo /usr/share/doc/libdvdread4/install-css.sh

    echo -e "${GREEN}Finished installing software.${RESET}"
    sleep 3
}

cleanup_home() {
    echo -e "\nRemoving default XDG directories (Pictures, Music etc.)..."

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

    echo -e "\nTransferring personal data from $SRC to $DEST..."

    PATHS_TO_COPY=(
        "jan"
        "media"
        "repos"
        "zasoby"
        ".fonts"
        ".mozilla"
        ".ssh"
        ".bash_history"
        ".config/dotfiles-git-dir"
        ".config/terminator"
        ".config/gtk-3.0/bookmarks"
        ".config/monitors.xml"
        ".config/system-setup-todo"
        ".kde/share/apps/kate"
        ".kde/share/config/katerc"
        ".vagrant.d"
        ".vim"
        ".vimrc"
        #.chrome
        #virtualbox vms
    )

    SRC_PARTITION=$(df -P "$SRC" | tail -1 | cut -d' ' -f1)
    DEST_PARTITION=$(df -P "$DEST" | tail -1 | cut -d' ' -f1)

    if [ $SRC_PARTITION = $DEST_PARTITION ]; then
        command="mv"
        verb="Moving"
    else
        command="cp --recursive"
        verb="Copying"
    fi

    for path in ${PATHS_TO_COPY[*]}; do
        if [ -e "$SRC"/"$path" ]; then
            if [ -e "$DEST"/"$path" ]; then
                echo -e ${RED}"$DEST"/"$path" already exists, renaming...${RESET}
                echo "$path" >> ~/conflicting-paths.txt
                mv "./$path" "./$path.old" --backup=numbered
            fi
            echo -n $verb "$path"...
            mkdir --parents "$DEST"/$(dirname "$path")/
            $command "$SRC"/"$path" "$DEST"/$(dirname "$path")/
            echo -e ${GREEN} done.${RESET}
        fi
        sleep 0.1
    done

    mkdir --parents "$DEST"/media
    echo -e "${GREEN}Data transferred.\n${RESET}"
    sleep 3
}

install_dotfiles() {
    if [ ! -f "$HOME/.config/dotfiles-git-dir" ]; then
        echo -e "\nInstalling dotfiles..."
        git clone https://github.com/janek-warchol/dotfiles ~/repos/dotfiles --branch janek
        ~/repos/dotfiles/.install-dotfiles.sh
    else
        echo -e "\nDotfiles already installed, updating files..."
        DOTFILES_REPO=$(cat "$HOME/.config/dotfiles-git-dir")
        git --work-tree="$HOME" --git-dir="$DOTFILES_REPO" status --short --untracked-files=no
        git --work-tree="$HOME" --git-dir="$DOTFILES_REPO" stash
        echo -e "${GREEN}Done.\n${RESET}"
    fi
    source .config/bash/*.sh
}

install_lilypond() {
    # FIXME I'm getting "Unable to find a source package for lilypond" on Mint 17.1
    sudo apt-get build-dep --quiet --yes lilypond || true
    sudo apt-get install --quiet --yes autoconf dblatex texlive-lang-cyrillic
    if [ ! -d "$MY_REPOS/lilypond-git" ]; then
        git clone git://git.sv.gnu.org/lilypond.git "$MY_REPOS/lilypond-git"
    fi
}

install_frescobaldi() {
    if [ -z `which frescobaldi` ]; then
        sudo apt-get install --quiet --yes python python-qt4 python-poppler-qt4 python-pypm
        if [ ! -d ~/bin/frescobaldi ]; then
            git clone git://github.com/wbsoft/frescobaldi.git ~/bin/frescobaldi
        fi
        cd ~/bin/frescobaldi
        sudo python setup.py install
        cd -
    fi
}

install_vagrant() {
    if [ -z `which vagrant` ]; then
        # version in apt repos is ancient, so we scrape Vagrant's website for the latest .deb
        VAGRANT_PKG_URL=$(wget --quiet https://www.vagrantup.com/downloads.html -O- | \
                        grep -P "\d+\.\d+\.\d+_x86_64\.deb" | cut -d'"' -f2)
        wget $VAGRANT_PKG_URL -O vagrant.deb
        sudo dpkg --install vagrant.deb
        rm vagrant.deb
    fi
}

apply_settings() {
    # set terminator as default system terminal
    gsettings set org.gnome.desktop.default-applications.terminal exec 'terminator'
    gsettings set org.cinnamon.desktop.default-applications.terminal exec 'terminator'

    # make nautilus/nemo open executable text files in editor by default
    dconf write /org/gnome/nautilus/preferences/executable-text-activation "'open'"
    dconf write /org/nemo/preferences/executable-text-activation "'display'"
}

cleanup_home
copy_data "$1" "$HOME"
install_apt_packages  # some of the later operations require git
install_dotfiles
install_vagrant
install_frescobaldi
install_lilypond
apply_settings
