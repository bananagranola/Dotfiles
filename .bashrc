# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set path to include ~/bin
PATH=~/.bin:$PATH

# ccache
#export USE_CCACHE=1
#export CCACHE_DIR=/home/amytcheng/.ccache

alias sudo='sudo '

# default variables
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/bin/exo-open --launch WebBrowser"
export WINDOWS="/mnt/windows/Users/amytcheng/"

# prettify
alias grep='grep --color=auto'
alias ls='ls --color=auto --classify --human-readable'
alias cp='cp --verbose'
alias mv='mv --verbose'

# git dotfiles utilities
alias gadd='cd ~/.dotfiles && git add --all --verbose && cd -'
alias gcom='cd ~/.dotfiles && git commit --verbose && cd -'
alias gdif='cd ~/.dotfiles && git diff && cd -'
alias gpul='cd ~/.dotfiles && git pull --verbose origin master && cd -'
alias gpus='cd ~/.dotfiles && git push --verbose --set-upstream origin master && cd -'
alias dfr='cd ~/.scripts && ./dotfiler.sh && cd -'
alias gup='gadd ; gpul ; gcom ; gpus ; dfr'

# extraction utility
alias unpack='7z x'

# mount android-mtp
alias mmtp='jmtpfs -o allow_other /media/android-mtp'
alias umtp='fusermount -u /media/android-mtp'

fortune -c


