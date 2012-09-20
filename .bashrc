# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# bash completion
. /etc/bash_completion.d/git
[ -r /etc/bash_completion.d/netcfg ] && . /etc/bash_completion.d/netcfg
. /etc/bash_completion.d/pacaur

# defaults
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/bin/dwb"
export WINDOWS="/media/windows7/Users/amytcheng/"

# command-line calculator
calc() { awk "BEGIN { print $*}" ;}

# follow vim exit
alias :q='exit'

# convenient image viewer script aliases
alias meh='/home/amytcheng/.scripts/meh.sh'
alias sxiv='/home/amytcheng/.scripts/sxiv.sh'

# prettify
alias grep='grep --color=auto'
alias ls='ls --color=auto --classify --human-readable'

# pacman utilities
alias pacman='pacman-color'
alias reflect='sudo reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias packs='pacman -Q | wc -l'

# git utilities
alias gcom='cd ~/.dotfiles && git commit -v -a && cd -'
alias gdif='cd ~/.dotfiles && git diff && cd -'
alias gpul='cd ~/.dotfiles && git pull -v origin master && cd -'
alias gpus='cd ~/.dotfiles && git push -v -u origin master && cd -'
