#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# append to the history file and trim it to 1000 lines
HISTFILESIZE=1000
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if hash dircolors 2>/dev/null; then
  if [ -r ~/.dircolors ]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

if [ -r /usr/local/etc/profile.d/bash_completion.sh ]; then   ## This is brew installed
  export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
  # shellcheck source=/dev/null
  . /usr/local/etc/profile.d/bash_completion.sh
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  # shellcheck source=/dev/null
  . /usr/share/bash-completion/bash_completion
elif [ -r /etc/bash_completion ]; then
  # shellcheck source=/dev/null
  . /etc/bash_completion
fi

## XXX source all the files in ~/.local/share/bash-completion/completions. Is this automatic?
## XXX Check for kubectl, check for completion, create it if missing, and source it
## XXX Ditto for oc

alias k=kubectl
complete -F __start_kubectl k

# shellcheck source=/dev/null
for gcpsdkpath in ~/.google-cloud-sdk /snap/google-cloud-sdk/current; do
  for sdkfiles in path.bash.inc completion.bash.inc; do
    sdkfile=${gcpsdkpath}/${sdkfiles}
    if [ -f ${sdkfile} ]; then . ${sdkfile}; fi
  done
done

complete -C "$(which terraform)" terraform

# Neither pureline nor iTerm2 shell integration export their variables/functions; every child shell
# then needs this. The order is also important as iTerm shell integration preserves existing prompt
# commands and pureline does not.

if [ "$TERM" != "linux" ]; then
  # shellcheck source=/dev/null
  . ~/repos/pureline/pureline ~/.pureline
fi

if [ "$TERM_PROGRAM" != "vscode" ]; then
  export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
  export iterm2_hostname=${HOSTNAME//andre/gcp}
  # shellcheck source=/dev/null
  test -e "${HOME}/.iterm2_shell_integration.bash" && . "${HOME}/.iterm2_shell_integration.bash"
fi

## Extra stuff that shouldn't go into GitHub
# shellcheck source=/dev/null
if [ -f ~/.bash_extras ]; then . ~/.bash_extras; fi

# shellcheck source=/dev/null
. ~/.bash-funcs
