# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source *.sh configuration files
configs="$HOME/.config/bash/"
if [[ -d "${configs}" && $(ls "${configs}"/*.sh 2>/dev/null) ]]; then
    for f in "${configs}"/*.sh; do
        . "$f"
    done
    # load site-specific overrides at the end (if they exist)
    [ -e "${configs}/config.local" ] && . "${configs}/config.local"
fi

