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
export BROWSER="/usr/bin/firefox"
export WINDOWS="/media/windows7/Users/amytcheng/"

# prettify
alias grep='grep --color=auto'
alias ls='ls --color=auto --classify --human-readable'
alias cp='cp -v'
alias mv='mv -v'

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
alias gup='gadd ; gpul ; gcom ; gpus ; dfr'

# extraction utility
alias extract='7z e'

# mount android-mtp
alias mmtp='jmtpfs -o allow_other /media/android-mtp'
alias umtp='fusermount -u /media/android-mtp'

fortune -c

# mount samba
alias msmbp='mount -t cifs //192.168.1.11/public /mnt/public -o username=amytcheng,credentials=/home/amytcheng/.sambacreds,workgroup=WORKGROUP,ip=192.168.1.11'
alias msmbd='mount -t cifs //192.168.1.11/data /mnt/data -o username=amytcheng,credentials=/home/amytcheng/.sambacreds,workgroup=WORKGROUP,ip=192.168.1.11'

