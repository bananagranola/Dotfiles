# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set path to include ~/bin
PATH=~/.bin:$PATH

alias sudo='sudo '

# default variables
export EDITOR="/usr/bin/vim"
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

# miscellaneous utilities
alias unofficialdeb="aptitude search '~S ~i !~ODebian !~o'"
alias compresspdf='gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -sOutputFile="$2" "$1"'
alias html2dwb='grep -i http "$1" | awk '{print $2}' | sed -e "s/^.*\"\(.*\)\".*$/\1/" > "$2"'

fortune -c
