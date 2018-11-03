# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

source ~/.git-completion.bash
source ~/.git-prompt.sh

export GOPATH="$HOME/go/"
export PATH=$PATH:/usr/lib/go-1.10/bin:$HOME/.cargo/bin:$GOPATH/bin
export PATH=$PATH:$HOME/.git-radar
export GITHUB=$GOPATH/src/github.com/
export MX=$GOPATH/src/github.com/maxmcd/

POWDER_BLUE=$(tput setaf 153)
WEIRD_BLUE=$(tput setaf 31)
WHITE=$(tput setaf 15)
NPROC=$(nproc)
PS1="\[${WEIRD_BLUE}\]\u $NPROC 👻 :\w\[${POWDER_BLUE}\]\$(git-radar --bash --fetch)\[${WEIRD_BLUE}\] \n$ \[${WHITE}\]"

export EDITOR=vim


export HISTFILESIZE=72000
export HISTSIZE=$HISTFILESIZE
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias ss='live-server'
alias gl='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white)"'
alias gocover='go test  -coverprofile=coverage.out && go tool cover -html=coverage.out && rm coverage.out'
alias pt=papertrail
alias cat=bat
alias ping='prettyping --nolegend'

alias f='cd $(find $GITHUB -maxdepth 2 -type d | fzf || echo ".")'
alias fo='cd $(find $GITHUB -maxdepth 2 -type d | fzf) && hub browse && cd -'

alias gpo="git push origin \$(__git_ps1) --tags"
alias ggo="git push github \$(__git_ps1) --tags"
alias glo="git pull origin \$(__git_ps1)"
alias gs="git status"
alias gst="git stash"
alias gsta="git stash apply"
alias dc="docker-compose"
alias k="kubectl"

# Add git completion to aliases
__git_complete g __git_main
__git_complete gc _git_checkout
__git_complete gm _git_merge
__git_complete gp _git_pull
__git_complete gb _git_branch

# Make sure you actually have those aliases defined, of course.
alias g="git"
alias gc="git checkout"
alias gm="git merge"
alias gp="git pull"
alias gb="git branch"

alias ll="ls -lahp"
alias l="tree --dirsfirst -ChFLa 1"
alias l2="tree --dirsfirst -ChFLa 2"
alias l3="tree --dirsfirst -ChFLa 3"
alias l4="tree --dirsfirst -ChFLa 4"
alias l5="tree --dirsfirst -ChFLa 5"
alias d="du -chd 1 | sort -h"

wgett () {
    aria2c -x 10 -s 10 $1
}
