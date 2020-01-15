#!/usr/bin/env bash

if [ "$TERM" != "linux" ]; then
  . ~/repos/pureline/pureline ~/.pureline
fi

if [ "$TERM_PROGRAM" != "vscode" ]; then
  export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
  test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

if hash dircolors 2>/dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
