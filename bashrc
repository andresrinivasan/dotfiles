#!/usr/bin/env bash

if hash dircolors 2>/dev/null; then
  if [ -r ~/.dircolors ]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias k=kubectl
complete -F __start_kubectl k

# Neither pureline nor iTerm2 shell integration export their variables/functions; every child shell
# then needs this. The order is also important as iTerm shell integration preserves existing prompt
# commands and pureline does not.

if [ "$TERM" != "linux" ]; then
  # shellcheck source=/dev/null
  . ~/repos/pureline/pureline ~/.pureline
fi

if [ "$TERM_PROGRAM" != "vscode" ]; then
  export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
  # shellcheck source=/dev/null
  test -e "${HOME}/.iterm2_shell_integration.bash" && . "${HOME}/.iterm2_shell_integration.bash"
fi
