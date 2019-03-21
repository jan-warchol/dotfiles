# Some shell commands are dangerous - rm deletes files permamently, cp and mv
# silently overwrite destination files if they exist. To protect myself from
# my own mistakes I define "safe versions" of such commands.

# Instead of rm, I use trash-cli (https://github.com/andreafrancia/trash-cli)
# which moves files to system trash.  It can be installed with pip or apt-get.

alias rm='trash-put'
alias mv='\mv --interactive --verbose'
alias cp='\cp --recursive --backup=numbered'
# Bypass these aliases by prepending a slash, e.g. \rm file-without-hope
