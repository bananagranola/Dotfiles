# configure history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# prompt setup
autoload -U promptinit
promptinit 
prompt redhat

# completion setup
autoload -U compinit
compinit
setopt completealiases
setopt extendedglob

# completion menu style
setopt auto_menu
setopt correct

# don't kill background processes
setopt no_hup

# disable beep
unsetopt beep

# use vim key bindings
bindkey -v

# alt-. inserts last word
bindkey '\e.' insert-last-word

# home/end goes to beginning/end of line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# page up/down cycles command history
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

# set path to include ~/bin
PATH=~/.bin:/opt/android-sdk/platform-tools:$PATH

# ccache
export USE_CCACHE=1

# default variables
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/bin/firefox -new-window"
export WINDOWS="/media/windows7/Users/amytcheng/"

# command-line calculator
calc() { awk "BEGIN { print $*}" ;}

alias sudo='sudo '

# follow vim exit
alias :q='exit'

# convenient killer
killer() {
	ps -e | grep $1 | cut -c1-5 | xargs kill -9
}

# tar compression
alias uptar='tar -acf'
alias untar='tar -xvf'

# convenient image viewer script aliases
alias sxiv='/home/amytcheng/.scripts/sxiv.sh'

# prettify
alias grep='grep --color=auto'
alias ls='ls --color=auto --classify --human-readable'

# pacman utilities
alias pacman='pacman-color'
alias reflect='sudo reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias packs='pacman -Q | wc -l'

# git utilities
alias gadd='cd ~/.dotfiles && git add --all --verbose && cd -'
alias gcom='cd ~/.dotfiles && git commit --verbose && cd -'
alias gdif='cd ~/.dotfiles && git diff && cd -'
alias gpul='cd ~/.dotfiles && git pull --verbose origin master && cd -'
alias gpus='cd ~/.dotfiles && git push --verbose --set-upstream origin master && cd -'
alias dfr='cd ~/.scripts && ./dotfiler.sh && cd -'
alias gup='gpul ; gadd ; gcom ; gpus ; dfr'

# mount android-mtp
alias mmtp='jmtpfs -o allow_other /media/android-mtp'

# cp and mv utilities with progressbars
alias cp='acp -g'
alias mv='amv -g'
