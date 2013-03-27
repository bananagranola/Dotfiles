# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set path to include ~/bin
PATH=~/.bin:$PATH

# ccache
export USE_CCACHE=1
export CCACHE_DIR=/home/amytcheng/.ccache

alias sudo='sudo '

