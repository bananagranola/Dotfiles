# configure history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# prompt setup
autoload -U promptinit
promptinit 
prompt redhat

# use vim key bindings
bindkey -v

# disable beep
unsetopt beep

# completion setup
autoload -U compinit
compinit
setopt completealiases
setopt extendedglob

# completion menu style
setopt auto_menu
setopt correct

# page up/down for command history
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

# home/end keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# default variables
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/bin/firefox"
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
alias gcom='git commit -v -a -m $(hostname)'
alias gdif='git diff'
alias gpul='git pull -v origin master'
alias gpus='git push -v -u origin master'

