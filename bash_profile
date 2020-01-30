#!/usr/bin/env bash

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
#   esac
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

export HISTCONTROL=ignoreboth
export LESS=-FRX

export GOPATH=~/go
export PKG_CONFIG_PATH=/usr/local/Cellar/zeromq/4.3.2/lib/pkgconfig/
export POETRY_VIRTUALENVS_PATH=~/.virtualenvs

## See https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script

PATH=~/bin:~/.poetry/bin:${GOPATH//://bin:}/bin:$PATH
if hash brew 2>/dev/null; then
  PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/python/libexec/bin:/usr/local/opt/openssl/bin:$PATH
  MANPATH="/usr/local/opt/coreutils/share/man:/usr/local/opt/gnu-tar/libexec/gnuman:/usr/local/opt/openssl/share/man:$MANPATH"
fi

if [ -r /usr/local/etc/profile.d/bash_completion.sh ]; then
  export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
  . /usr/local/etc/profile.d/bash_completion.sh
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -r /etc/bash_completion ]; then
  . /etc/bash_completion
fi

## Extra stuff that shouldn't go into GitHub
[[ -s ~/.bash_extras ]] && . ~/.bash_extras

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/andresrinivasan/.google-cloud-sdk/path.bash.inc' ]; then source '/Users/andresrinivasan/.google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/andresrinivasan/.google-cloud-sdk/completion.bash.inc' ]; then source '/Users/andresrinivasan/.google-cloud-sdk/completion.bash.inc'; fi

. ~/.bash-funcs

. ~/.bashrc
