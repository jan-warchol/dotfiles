# Some shell commands are dangerous - rm deletes files permamently, cp and mv
# silently overwrite destination files if they exist. To protect myself from
# my own mistakes I define "safe versions" of such commands.

# Instead of rm, I use trash-cli (https://github.com/andreafrancia/trash-cli)
# which moves files to system trash.  It can be installed with pip or apt-get.
alias tp='trash-put --verbose'

alias mw='\mv --interactive --verbose'
alias kp='\cp --recursive --backup=numbered --verbose'

# Make sure that I won't accidentally use plain rm, mv or cp
alias rm='echo "This is not the command you are looking for."; false'
alias mv='echo "This is not the command you are looking for."; false'
alias cp='echo "This is not the command you are looking for."; false'
# Bypass these aliases by prepending a slash, e.g. \rm file-without-hope
