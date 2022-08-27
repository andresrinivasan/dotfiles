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

if [ "$HOMEBREW_PREFIX" ] && [ -r "$HOMEBREW_PREFIX"/etc/profile.d/bash_completion.sh ]; then   ## This is brew installed
  export BASH_COMPLETION_COMPAT_DIR="$HOMEBREW_PREFIX"/etc/bash_completion.d
  # shellcheck source=/dev/null
  . "$HOMEBREW_PREFIX"/etc/profile.d/bash_completion.sh
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  # shellcheck source=/dev/null
  . /usr/share/bash-completion/bash_completion
elif [ -r /etc/bash_completion ]; then
  # shellcheck source=/dev/null
  . /etc/bash_completion
fi

# The next line enables shell command completion for gcloud.
# shellcheck source=/dev/null
if [ -f '/Users/andre/.local/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/andre/.local/google-cloud-sdk/completion.bash.inc'; fi

## XXX source all the files in ~/.local/share/bash-completion/completions. Is this automatic?
## XXX Check for kubectl, check for completion, create it if missing, and source it
## XXX Ditto for oc

alias k=kubectl
complete -F __start_kubectl k

if hash terraform 2>/dev/null; then
  complete -C "$(which terraform)" terraform
fi

if hash gh 2>/dev/null; then 
  eval "$($(which gh) completion -s bash)"
fi

if hash poetry 2>/dev/null; then
  eval "$($(which poetry) completions bash)"
fi

# # Neither pureline nor iTerm2 shell integration export their variables/functions; every child shell
# # then needs this. The order is also important as iTerm shell integration preserves existing prompt
# # commands and pureline does not.

# if [ "$TERM" != "linux" ]; then
#   # shellcheck source=/dev/null
#   . ~/repos/pureline/pureline ~/.pureline
# fi

# if [ "$TERM_PROGRAM" != "vscode" ]; then
#   export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
#   export iterm2_hostname=${HOSTNAME//andre/gcp}
#   # shellcheck source=/dev/null
#   test -e "${HOME}/.iterm2_shell_integration.bash" && . "${HOME}/.iterm2_shell_integration.bash"
# fi

# export ITERM2_SQUELCH_MARK=1
# export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1
# test -e "${HOME}/.iterm2_shell_integration.bash" && . "${HOME}/.iterm2_shell_integration.bash"

eval "$(oh-my-posh init bash --config ~/.config/omp/powerlevel10k_modern.omp.json)"

## Extra stuff that shouldn't go into GitHub
# shellcheck source=/dev/null
if [ -f ~/.bash_extras ]; then . ~/.bash_extras; fi

# shellcheck source=/dev/null
. ~/.bash-funcs
