## Copied from https://github.com/mattmc3/antidote. This can be verbose so put ahead of P10k instant prompt.
if ! [[ -e ${ZDOTDIR:-~}/.antidote ]]; then
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

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
  export USE_GKE_GCLOUD_AUTH_PLUGIN=true
fi

PATH=~/bin:~/.krew/bin:$PATH

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias k=kubectl

if command -v dircolors >/dev/null; then
  if [ -r ~/.dircolors ]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
fi

if command -v lesspipe >/dev/null; then
  lesspipe.sh|source /dev/stdin
fi

if command -v java >/dev/null; then
  export JAVA_HOME=$(dirname "$(command -v java)")
fi

export LESS=-FRX
export VISUAL=vi
export PERL_HOMEDIR=0

export GCP_VM_FILTER=andre                    ## For list-gcp-vm

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)    ## For zsh-syntax-highlighting plugin loaded by antidote
source ${ZDOTDIR:-~}/.p10k.zsh                ## For Powerlevel10k plugin loaded by antidote

test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh

## XXX Explore this further
autoload -U select-word-style 
select-word-style bash
WORDCHARS=$WORDCHARS:s:-:   ## Remove'-' from list of word characters
