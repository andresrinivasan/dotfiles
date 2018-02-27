#!/bin/bash

function ls() {
  /bin/ls -FG "$@"
}

function jq() {
  local color

  if [[ $1 == -M ]]; then
    color=--monochrome-output
    shift
  else
    color=--color-output
  fi

  /usr/local/bin/jq $color "$@"
}

function GET() {
  if [[ $1 == -M ]]; then
    mono=-M
    shift
  fi

  /usr/bin/curl "$@" | jq $mono .
}

function EVTGET() {
  if [[ $1 == -M ]]; then
    mono=-M
    shift
  fi

  GET $mono -Hauthorization:$EVT_API_KEY -Haccept:application/json $EVT_API"$@"
}
export EVT_API=https://api.evrythng.com

## See https://www.davidpashley.com/articles/xterm-titles-with-bash/ and https://mg.pov.lt/blog/bash-prompt.html
# function set_title_bar() {
#   case "${BASH_COMMAND}" in
#     *\033]0*)
#       # The command is trying to set the title bar as well;
#       # this is most likely the execution of $PROMPT_COMMAND.
#       # In any case nested escapes confuse the terminal, so don't
#       # output them.
#       ;;
#     *)
#       if [ "`type -t ${BASH_COMMAND}`" = "file" ]; then
#         echo -ne "\033]0;${PWD/#$HOME/'~'} | ${HOSTNAME} | ${BASH_COMMAND}\007"
#       fi
#       ;;

#     esac
# }
# trap set_title_bar DEBUG
# export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/\~} | ${HOSTNAME} | bash\007"'

## See https://github.com/rcaloras/bash-preexec
[[ -s ~/.bash-preexec.sh ]] && . ~/.bash-preexec.sh
function preexec() {
  if [[ `type -t $1` =~ file|function|alias ]]; then
    echo -ne "\033]0;${PWD/#$HOME/'~'} | ${HOSTNAME} | $1\007"
  fi
}

function precmd() { echo -ne "\033]0;${PWD/#$HOME/\~} | ${HOSTNAME} | bash\007"; }

export PS1=': \W\$ '

export HISTCONTROL=ignoreboth
export LESS=-FRX

export NVM_DIR="$HOME/.nvm"
[[ -s /usr/local/opt/nvm/nvm.sh ]] && . /usr/local/opt/nvm/nvm.sh

PATH=~/bin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/python/libexec/bin:$PATH
MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"

## See https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if hash brew 2>/dev/null; then
  [[ -f $(brew --prefix)/etc/bash_completion ]] && . $(brew --prefix)/etc/bash_completion
fi

[[ -s $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion  # This loads nvm bash_completion

## Extra stuff that shouldn't go into GitHub
[[ -s ~/.bash_extras ]] && . ~/.bash_extras
