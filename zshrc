# Lines configured by zsh-newuser-install
setopt autocd
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

setopt ignore_eof

## History config. See https://postgresqlstan.github.io/cli/zsh-history-options/
SAVEHIST=9000
HISTSIZE=9999                   # set HISTSIZE > SAVEHIST
setopt EXTENDED_HISTORY         # include timestamp
setopt HIST_BEEP                # beep if attempting to access a history entry which isn’t there
setopt HIST_EXPIRE_DUPS_FIRST   # trim dupes first if history is full
setopt HIST_FIND_NO_DUPS        # do not display previously found command
setopt HIST_IGNORE_DUPS         # do not save duplicate of prior command
setopt HIST_IGNORE_SPACE        # do not save if line starts with space
setopt HIST_NO_STORE            # do not save history commands
setopt HIST_REDUCE_BLANKS       # strip superfluous blanks
setopt INC_APPEND_HISTORY       # don’t wait for shell to exit to save history lines
setopt SHARE_HISTORY            # share history

# setopt HIST_ALLOW_CLOBBER       # related to shell clobber setting
# setopt HIST_IGNORE_ALL_DUPS     # remove old event if new one is a duplicate
# setopt HIST_LEX_WORDS           # related to how white space is saved
# setopt HIST_NO_FUNCTIONS        # do not save function commands
# setopt HIST_SAVE_NO_DUPS        # omit older duplicates of newer commands
# setopt HIST_SUBST_PATTERN       # use pattern matching for substitutions
# setopt HIST_VERIFY              # expand command line without executing it

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
setopt COMPLETE_ALIASES

complete -o nospace -C /opt/homebrew/bin/terraform terraform

## Configure zsh plugins loaded by Antidote
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# shellcheck source=/dev/null
##HOMEBREW_PREFIX=$( (/usr/local/bin/brew --prefix || /opt/homebrew/bin/brew --prefix) 2>/dev/null)	## eval brew shellenv?
eval $((/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null) | egrep -v MANPATH) ## Fix MANPATH
if [ -n "$HOMEBREW_PREFIX" ]; then
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

if command -v eza >/dev/null; then
  alias ls='eza --color=auto --classify' && compdef ls=eza
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
alias la="ls -a"
alias ll="ls -l"

if command -v bat >/dev/null; then
  alias cat="bat --paging=never"
  alias lessy="prettybat --language=yaml"
  alias lessj="prettybat --language=json"
  alias lessm="prettybat --language=markdown"
  alias man=batman

  export BAT_THEME=base16
  export BAT_STYLE=plain
fi

## Stick with less/lesspipe as batpipe doesn't support PDF out of the box
if command -v lesspipe.sh >/dev/null; then
  lesspipe.sh|source /dev/stdin  ## Per man lesspipe
fi

# if command -v batpipe >/dev/null; then
#   eval "$(batpipe)"
# fi

alias grep="grep --color=auto"
alias fgrep="grep -F --color=auto"
alias egrep="grep -E --color=auto"
alias k=kubectl && compdef k=kubectl
alias d=docker && compdef d=docker
alias dc="docker compose" && compdef dc=docker
alias venv-create="python3 -m venv venv"
alias venv-activate="source venv/bin/activate"
alias gh-repo-create="gh repo create --public --clone --add-readme --license unlicense"

## Note using tr instead of sed 's/\+/-/g' | sed 's/\//_/g' | sed 's/=//g
if command -v basenc >/dev/null; then
  alias basenc-base64url="basenc --base64url -w0 | tr -d '='"
else
  alias base64url="base64 -w0 | tr '+/' '-_' | tr -d '='" 
fi

## From https://superuser.com/questions/232457/zsh-output-whole-history
## Depends on setup EXTENDED_HISTORY
alias h="fc -l 1" ## history == fc -l
alias hg="(){ fc -lim \"*\$1*\" 1 }" ## Search for pattern in history

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

##alias dcls='docker ps --format "{{println .Names .Ports}}" | column -t -s " "'

## From https://github.com/GammaGames/dz/blob/main/dz
function dls() {
    _print_container_info() {
        local container_ports
        local container_ip
        local container_name

        container_ports=$(docker port "${1}" | perl -n -e'/0.0.0.0:(\d+)/ && print "$1 "' | xargs | tr ' ' ',')
        container_name=$(docker inspect --format "{{ .Name }}" "${1}" | sed 's/\///' | xargs)
        container_ip=$(docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}  {{end}}" "${1}" | xargs)

        printf "%-13s %-20s %-20s\n" "${1}" "${container_name}" "${container_ip}":"${container_ports}"
    }

    printf "%b%-13s %-20s %-20s%b\n" $(tput bold) 'Container Id' 'Container Name' 'Service End Point' $(tput sgr0)
    if [ -z "${1}" ]; then
        local id
        for id in $(docker ps -q); do
            _print_container_info "${id}"
        done
    else
        _print_container_info $(docker ps -q --filter "name=${1}")
    fi
}

alias newest="(){
  \ls -tr \$1 | tail -1
}"

# alias wget="(){
#   if [ \$# -eq 0 ]; then
#     echo Usage: wget FILE-URL
#     return 1
#   fi

#   http -q -d \$1
# }"

if command -v java >/dev/null; then
  export JAVA_HOME=$(dirname "$(command -v java)")
fi

export VISUAL=vi
export PERL_HOMEDIR=0
export GCP_VM_FILTER=andre ## For list-gcp-vm
export HOMEBREW_NO_ENV_HINTS=true
export SSH_AUTH_SOCK=~/.1password/agent.sock
## export POETRY_VIRTUALENVS_IN_PROJECT=true - Switched to venv
export LESS=-FRX
export PIP_DISABLE_PIP_VERSION_CHECK=1


## XXX Explore this further
autoload -U select-word-style
select-word-style bash
WORDCHARS=$WORDCHARS:s:-: ## Remove'-' from list of word characters

# Generated for envman. Do not edit. Added by pipx
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

##test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh

eval "$(starship init zsh)"
