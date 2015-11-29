# originally written by Pat Regan and published at
# http://blog.patshead.com/2011/05/my-take-on-the-go-command.html

go() {
  if [ -f "$1" ]; then
    if [ -n "`file $1 | grep '\(text\|empty\|no magic\)'`" ]; then
      if [ -w "$1" ]; then
        $EDITOR "$1"
      else
         sudo $EDITOR "$1"
         #$EDITOR /sudo::"$1" # For emacsclient+tramp
      fi
    else
      if [ -e "`which xdg-open`" ]; then
        if [ -n "$DISPLAY" ]; then
          xdg-open "$1" > /dev/null
        else
          echo "DISPLAY not set:  xdg-open requires X11"
        fi
      else
        echo "xdg-open not found:  unable to open '$1'"
      fi
    fi
  elif [ -d "$1" ]; then
    cd "$1"
  elif [ "" = "$1" ]; then
    cd
  elif [ -n "`declare -f | grep '^j ()'`" ]; then
    j "$1"
  else
    echo "Ran out of things to do with '$1'"
  fi
}

alias g=go
