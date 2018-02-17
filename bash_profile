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

function GET() {
  if [ "$1" == "-M" ]; then
    mono=-M
    shift
  fi

  /usr/bin/curl "$@" | jq $mono .
}

function EVTGET() {
  if [ "$1" == "-M" ]; then
    mono=-M
    shift
  fi

  GET $mono -Hauthorization:$EVT_API_KEY -Haccept:application/json $EVT_API"$@"
}
export EVT_API=https://api.evrythng.com

function set_title_bar() {
  case "$BASH_COMMAND" in
    *\033]0*)
      # The command is trying to set the title bar as well;
      # this is most likely the execution of $PROMPT_COMMAND.
      # In any case nested escapes confuse the terminal, so don't
      # output them.
      ;;
    *)
      if [ "`type -t ${BASH_COMMAND}`" = "file" ]; then
        append=${BASH_COMMAND}
        PROMPT_COMMAND='echo -ne "\033]0;`pwd` | ${HOSTNAME} | bash\007"'
      else
        append='bash'
        unset PROMPT_COMMAND
      fi
      echo -ne "\033]0;`pwd` | ${HOSTNAME} | ${append}\007"
      ;;

    esac
}
trap set_title_bar DEBUG

export PS1=': \W\$ '
##export PROMPT_COMMAND='echo -ne "\033]0;`pwd` | ${HOSTNAME} | bash\007"'

export HISTCONTROL=ignoreboth
export LESS=-FRX
export HOMEBREW_GITHUB_API_TOKEN=61911fd78224da6ee9376b6d631d2d593d3a96ed

export NVM_DIR="/Users/andre/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

PATH=~/bin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/python/libexec/bin:$PATH
MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"

## See https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if hash brew 2>/dev/null; then
  [ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion
fi

[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
