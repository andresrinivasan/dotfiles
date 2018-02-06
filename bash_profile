#!/bin/bash

function ls() {
  /bin/ls -FG "$@"
}

function jq() {
  local color

  if [ "$1" == "-M" ]; then
    color=--monochrome-output
    shift
  else
    color=--color-output
  fi

  /usr/local/bin/jq $color "$@"
}

function GET {
  if [ "$1" == "-M" ]; then
    mono=-M
    shift
  fi

  /usr/bin/curl "$@" | jq $mono .
}

function EVTGET {
  if [ "$1" == "-M" ]; then
    mono=-M
    shift
  fi

  GET $mono -Hauthorization:$EVT_API_KEY -Haccept:application/json $EVT_API"$@"
}
export EVT_API=https://api.evrythng.com

export HISTCONTROL=ignoreboth

export LESS=-FRX
export PS1='\[\e]0;\h\a\]: \w\$ '
export HOMEBREW_GITHUB_API_TOKEN=61911fd78224da6ee9376b6d631d2d593d3a96ed

export NVM_DIR="/Users/andre/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

PATH=~/bin:/usr/local/opt/gnu-tar/libexec/gnubin:$PATH
MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi


##test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
