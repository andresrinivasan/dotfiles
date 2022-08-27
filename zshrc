# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/andre/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if hash dircolors 2>/dev/null; then
  if [ -r ~/.dircolors ]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias k=kubectl

export HISTCONTROL=ignoreboth
export LESS=-FRX
export VISUAL=vi
export PERL_HOMEDIR=0

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
  . '/Users/andre/.local/google-cloud-sdk/path.zsh.inc'
  export USE_GKE_GCLOUD_AUTH_PLUGIN=true
fi

PATH=~/bin:~/.krew/bin:$PATH

if hash java 2>/dev/null; then
  export JAVA_HOME=$(dirname "$(which java)")
fi

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

source $(brew --prefix)/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
