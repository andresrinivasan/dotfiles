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
  export PERL_HOMEDIR=0

  # export DOCKER_TLS_VERIFY="1"
  # export DOCKER_CERT_PATH="/Users/andresrinivasan/.minikube/certs"
  # export MINIKUBE_ACTIVE_DOCKERD="minikube"

  export GCP_VM_FILTER=andre          ## For list-gcp-vm

  # shellcheck source=/dev/null
  export HOMEBREW_PREFIX=$( (/usr/local/bin/brew --prefix || /opt/homebrew/bin/brew --prefix) 2>/dev/null)
  if [ "$HOMEBREW_PREFIX" ]; then
    PATH="$HOMEBREW_PREFIX"/bin:"$PATH"

    for p in coreutils gnu-tar; do
      PATH="$HOMEBREW_PREFIX"/opt/"$p"/libexec/gnubin:"$PATH"
      MANPATH="$HOMEBREW_PREFIX"/opt/"$p"/share/man:"$MANPATH"
    done

    for p in lsof openssl curl openjdk; do
      PATH="$HOMEBREW_PREFIX"/opt/"$p"/bin:"$PATH"
      MANPATH="$HOMEBREW_PREFIX"/opt/"$p"/share/man:"$MANPATH"
    done

    export HOMEBREW_NO_ENV_HINTS=true
  fi

  # The next line updates PATH for the Google Cloud SDK.
  # shellcheck source=/dev/null
  if [ -f '/Users/andre/.local/google-cloud-sdk/path.bash.inc' ]; then 
    . '/Users/andre/.local/google-cloud-sdk/path.bash.inc'
    export USE_GKE_GCLOUD_AUTH_PLUGIN=true
  fi

  PATH=~/bin:~/.krew/bin:$PATH

  if hash java 2>/dev/null; then
    export JAVA_HOME=$(dirname "$(hash -t java)")
  fi
fi

# shellcheck source=/dev/null
. ~/.bashrc
