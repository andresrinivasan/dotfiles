#!/usr/bin/env bash

function ls() {
  /bin/ls -FG "$@"
}
export -f ls

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
# if [[ -s ~/.bash-preexec.sh ]]; then
#   . ~/.bash-preexec.sh
#   function preexec() {
#     if [[ `type -t $1` =~ file|function|alias ]]; then
#       echo -ne "\033]0;${PWD/#$HOME/'~'} | ${HOSTNAME} | $1\007"
#     fi
#   }

#   function precmd() { echo -ne "\033]0;${PWD/#$HOME/\~} | ${HOSTNAME} | bash\007"; }
# fi

# export PS1=': \W\$ '

# if [ "$TERM" != "linux" ]; then
#   . ~/repos/pureline/pureline ~/.pureline
# fi

# if [ "$TERM_PROGRAM" != "vscode" ]; then
#   export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
#   test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
# fi

export HISTCONTROL=ignoreboth
export LESS=-FRX

# export NVM_DIR="$HOME/.nvm"
# [[ -s /usr/local/opt/nvm/nvm.sh ]] && . /usr/local/opt/nvm/nvm.sh

export GOPATH=~/go
export PKG_CONFIG_PATH=/usr/local/Cellar/zeromq/4.3.2/lib/pkgconfig/

PATH=~/bin:~/go/bin:~/.poetry/bin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/python/libexec/bin:/usr/local/opt/openssl/bin:$PATH
MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:/usr/local/opt/openssl/share/man:$MANPATH"

export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
##export BASH_COMPLETION_USER_DIR=~/.bash_completion.d

export POETRY_VIRTUALENVS_PATH=~/.virtualenvs

## See https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if hash brew 2>/dev/null; then
  [[ -r $(brew --prefix)/etc/profile.d/bash_completion.sh ]] && . $(brew --prefix)/etc/profile.d/bash_completion.sh
fi

# [[ -s $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion  # This loads nvm bash_completion

## Extra stuff that shouldn't go into GitHub
[[ -s ~/.bash_extras ]] && . ~/.bash_extras

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/andresrinivasan/.google-cloud-sdk/path.bash.inc' ]; then source '/Users/andresrinivasan/.google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/andresrinivasan/.google-cloud-sdk/completion.bash.inc' ]; then source '/Users/andresrinivasan/.google-cloud-sdk/completion.bash.inc'; fi

. ~/.bashrc
