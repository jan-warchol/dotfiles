# env variables pointing to various locations in my system
export MY_DROPBOX=$HOME/Dropbox
export MY_REPOS=$HOME/repos
export OTHER_REPOS=$HOME/repos
# LilyPond-related
export LILYPOND_BUILD_DIR=$HOME/lily-builds
export LILYPOND_GIT=$MY_REPOS/lilypond-git
export LILY_SCRIPTS=$MY_REPOS/cli-tools/lilypond
export TRUNKNE_LIED_HOME=$MY_REPOS/nuty/trunkne-lied

# "shortcut" aliases for quick navigation
alias lg='cd $LILYPOND_GIT; git status'
alias fr='cd $MY_REPOS/nuty/fried-songs; git status'
alias tl='cd $TRUNKNE_LIED_HOME/das-trunkne-lied; git status'
alias oll='cd $MY_REPOS/openlilylib; git status'
alias epi='cd $MY_DROPBOX/Epifania; git status'
alias nuty='cd $MY_REPOS/nuty/warsztat-nutowy; git status'
alias ties='cd "$MY_DROPBOX/LilyPond ties"; git status'
