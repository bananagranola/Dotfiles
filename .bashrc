# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set path to include ~/bin
PATH=~/.bin:$PATH

# ccache
export USE_CCACHE=1
export CCACHE_DIR=/home/amytcheng/.ccache

alias sudo='sudo '

# default variables
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/bin/firefox"
export WINDOWS="/media/windows7/Users/amytcheng/"

# prettify
alias grep='grep --color=auto'
alias ls='ls --color=auto --classify --human-readable'

# pacman utilities
alias reflect='sudo reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias packs='pacman -Q | wc -l'

# git dotfiles utilities
alias gadd='cd ~/.dotfiles && git add --all --verbose && cd -'
alias gcom='cd ~/.dotfiles && git commit --verbose && cd -'
alias gdif='cd ~/.dotfiles && git diff && cd -'
alias gpul='cd ~/.dotfiles && git pull --verbose origin master && cd -'
alias gpus='cd ~/.dotfiles && git push --verbose --set-upstream origin master && cd -'
alias dfr='cd ~/.scripts && ./dotfiler.sh && cd -'
alias gup='gpul ; gadd ; gcom ; gpus ; dfr'

# mount android-mtp
alias mmtp='jmtpfs -o allow_other /media/android-mtp'

# cp, mv, and rsync utilities with progressbars
alias cp='acp -g'
alias mv='amv -g'
alias rsync='rsync --archive --compress --human-readable --progress --verbose'
