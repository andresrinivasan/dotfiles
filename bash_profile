#!/usr/bin/env bash

if [ ! -v BASH_PROFILE ]; then
  export BASH_PROFILE=true

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
  export VISUAL=vi

  ##export PKG_CONFIG_PATH=/usr/local/Cellar/zeromq/4.3.2/lib/pkgconfig/

  ## See https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
  if hash brew 2>/dev/null; then
    PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/python/libexec/bin:$PATH
    MANPATH=/usr/local/opt/coreutils/share/man:/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH

    r=/usr/local/opt
    for p in openssl curl; do
      PATH=$r/$p/bin:$PATH
      MANPATH=$r/$p/man:$MANPATH
    done
  fi

  PATH=~/bin:~/.krew/bin:$PATH
fi

# shellcheck source=/dev/null
. ~/.bashrc
