# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=${ZDOTDIR:-~}/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ${ZDOTDIR:-~}/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall

## Added by terraform
## XXX Explore this further
autoload -U +X bashcompinit
bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

## Copied from https://github.com/mattmc3/antidote
if ! [[ -e ${ZDOTDIR:-~}/.antidote ]]; then
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# shellcheck source=/dev/null
HOMEBREW_PREFIX=$( (/usr/local/bin/brew --prefix || /opt/homebrew/bin/brew --prefix) 2>/dev/null)
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

  HOMEBREW_NO_ENV_HINTS=true
fi

# The next line updates PATH for the Google Cloud SDK.
# shellcheck source=/dev/null
if [ -f ~/.local/google-cloud-sdk/path.zsh.inc ]; then 
  source ~/.local/google-cloud-sdk/path.zsh.inc
  source ~/.local/google-cloud-sdk/completion.zsh.inc
  export USE_GKE_GCLOUD_AUTH_PLUGIN=true
fi

PATH=~/bin:~/.krew/bin:$PATH

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias k=kubectl
alias cat='bat --paging=never'
alias less=bat
alias create-gh-repo="gh repo create --public --clone --add-readme --license unlicense"
alias lessy="less --language=yaml"
alias lessj="less --language=json"
alias man=batman

if command -v dircolors >/dev/null; then
  if [ -r ~/.dircolors ]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
fi

if command -v java >/dev/null; then
  export JAVA_HOME=$(dirname "$(command -v java)")
fi


export VISUAL=vi
export PERL_HOMEDIR=0

export GCP_VM_FILTER=andre                    ## For list-gcp-vm

export BAT_THEME="Monokai Extended"
export BAT_STYLE="changes"
if command -v lesspipe >/dev/null; then
  lesspipe.sh|source /dev/stdin
fi
export LESS=-FRX

export HOMEBREW_NO_ENV_HINTS=true

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)    ## For zsh-syntax-highlighting plugin loaded by antidote

source ${ZDOTDIR:-~}/.p10k.zsh                ## For Powerlevel10k plugin loaded by antidote
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
typeset -g POWERLEVEL9K_VIRTUALENV_CONTENT_EXPANSION='${P9K_CONTENT%% *}'
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_AZURE_CONTENT_EXPANSION='${*}'
typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION=''
typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION=''

test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh

## XXX Explore this further
autoload -U select-word-style 
select-word-style bash
WORDCHARS=$WORDCHARS:s:-:   ## Remove'-' from list of word characters

