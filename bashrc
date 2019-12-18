#!/usr/bin/env bash

if [ "$TERM" != "linux" ]; then
  . ~/repos/pureline/pureline ~/.pureline
fi

if [ "$TERM_PROGRAM" != "vscode" ]; then
  export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
  test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi