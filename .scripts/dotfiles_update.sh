#!/bin/bash

DOTFILES=".dotfiles"
DOTFILES_DIR="$HOME/$DOTFILES/"
DOTFILES_DIR_LENGTH=${#DOTFILES_DIR}
dotfiles=$(find $DOTFILES_DIR -type f)

for src_dotfile in $dotfiles; do
	dest_dotfile=${src_dotfile:$DOTFILES_DIR_LENGTH}
	mkdir -p `dirname $dest_dotfile` # exclude .git/ from here
	if [ ! -h "$HOME/$dest_dotfile" ]; then
		ln -s "$src_dotfile" "$HOME/$dest_dotfile"
	fi
done

find -L $HOME -type l -delete
