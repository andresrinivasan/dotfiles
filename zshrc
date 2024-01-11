# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Lines configured by zsh-newuser-install
HISTFILE=${ZDOTDIR:-~}/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

setopt ignore_eof

# Added by compinstall
zstyle :compinstall filename ${ZDOTDIR:-~}/.zshrc

## Copied from https://github.com/mattmc3/antidote
if ! [[ -e ${ZDOTDIR:-~}/.antidote ]]; then
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

fpath=(~/.zfunc $fpath)

## XXX review what these flags mean
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

complete -o nospace -C /opt/homebrew/bin/terraform terraform

## pipx completions
eval "$(register-python-argcomplete pipx)"

## Configure zsh plugins loaded by Antidote
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# source ${ZDOTDIR:-~}/.p10k.zsh
# export POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
# export POWERLEVEL9K_VIRTUALENV_CONTENT_EXPANSION='${P9K_CONTENT%% *}'
# export POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
# export POWERLEVEL9K_AZURE_CONTENT_EXPANSION='${*}'
# export POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION=''
# export POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION=''
# unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND            ## Always show kubectx

# shellcheck source=/dev/null
HOMEBREW_PREFIX=$( (/usr/local/bin/brew --prefix || /opt/homebrew/bin/brew --prefix) 2>/dev/null)
if [ "$HOMEBREW_PREFIX" ]; then
  PATH="$HOMEBREW_PREFIX"/bin:"$PATH"

  for p in coreutils gnu-tar grep; do
    PATH="$HOMEBREW_PREFIX"/opt/"$p"/libexec/gnubin:"$PATH"
    MANPATH=$(readlink -f "$HOMEBREW_PREFIX"/opt/"$p"/libexec/man):"$MANPATH"
  done

  for p in lsof openssl curl openjdk binutils; do
    PATH="$HOMEBREW_PREFIX"/opt/"$p"/bin:"$PATH"
    MANPATH="$HOMEBREW_PREFIX"/opt/"$p"/share/man:"$MANPATH"
  done

  HOMEBREW_NO_ENV_HINTS=true
fi

# The next line updates PATH for the Google Cloud SDK.
# shellcheck source=/dev/null
if [ -f ~/.local/google-cloud-sdk/path.zsh.inc ]; then
  source ~/.local/google-cloud-sdk/path.zsh.inc
  source ~/.local/google-cloud-sdk/completion.zsh.inc
  export USE_GKE_GCLOUD_AUTH_PLUGIN=true
fi

PATH=~/bin:~/.local/bin:~/.krew/bin:$PATH
typeset -U PATH path ## Only keep first occurance

if command -v exa >/dev/null; then
  alias ls='exa --color=auto --classify'
  alias lltr='ll -snew'
else
  alias ls='ls --color=auto'
  alias lltr='ll -tr'
  ## Assumes Solarized Dark for terminal
  if command -v dircolors >/dev/null; then
    if [ -r ~/.dircolors ]; then
      eval "$(dircolors -b ~/.dircolors)"
    elif [ -r ~/repos/dircolors-solarized ]; then
      eval $(dircolors ~/repos/dircolors-solarized/dircolors.ansi-dark)
    fi
  fi
fi
alias la='ls -a'
alias ll='ls -l'

if command -v bat >/dev/null; then
  alias cat='bat --paging=never'
  alias lessy="bat --language=yaml"
  alias lessj="bat --language=json"
  alias man=batman && compdef batman='man'

  export BAT_THEME="Monokai Extended"
  export BAT_STYLE="plain"
fi

## Stick with less/lesspipe as batpipe doesn't support PDF out of the box
if command -v lesspipe.sh >/dev/null; then
  eval "$(lesspipe.sh)"
fi

# if command -v batpipe >/dev/null; then
#   eval "$(batpipe)"
# fi

alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'
alias k=kubectl && compdef k='kubectl'
alias create-gh-repo="gh repo create --public --clone --add-readme --license unlicense"

## From https://www.freecodecamp.org/news/how-to-get-a-docker-container-ip-address-explained-with-examples/
## See also https://stackoverflow.com/questions/65648918/docker-inspect-format-its-output-as-a-table (`docker inspect` is JSON centric; no tables)
## Also can't pass an argument to an alias so use an anonymous function
alias dnlsip="(){
  if [ \$# -eq 0 ]; then
    echo Usage: dnlsip DOCKER-NETWORK. One of
    docker network ls --format '\t{{.Name}}'    
    return 1
  fi
  docker network inspect --format='{{range .Containers}}{{println .Name .IPv4Address}}{{end}}' \$1 | column -t -s ' '
}"

alias dcl='docker ps --format "{{println .Names .Ports}}" | column -t -s " "'

alias newest="(){
  \ls -tr \$1 | tail -1
}"

if command -v java >/dev/null; then
  export JAVA_HOME=$(dirname "$(command -v java)")
fi

export VISUAL=vi
export PERL_HOMEDIR=0
export GCP_VM_FILTER=andre ## For list-gcp-vm
export HOMEBREW_NO_ENV_HINTS=true
export SSH_AUTH_SOCK=~/.1password/agent.sock
export POETRY_VIRTUALENVS_IN_PROJECT=true
export LESS=-FRX

## XXX Explore this further
autoload -U select-word-style
select-word-style bash
WORDCHARS=$WORDCHARS:s:-: ## Remove'-' from list of word characters

# Generated for envman. Do not edit. Added by pipx
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

##test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh

eval "$(starship init zsh)"
