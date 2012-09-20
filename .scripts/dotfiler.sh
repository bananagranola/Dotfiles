#!/bin/bash

DOTFILES=".dotfiles"
DOTFILES_DIR="$HOME/$DOTFILES/"
DOTFILES_DIR_LENGTH=${#DOTFILES_DIR}
dotfiles=$(find $DOTFILES_DIR -type f)

for src_dotfile in $dotfiles; do
	dest_dotfile=${src_dotfile:$DOTFILES_DIR_LENGTH}
	mkdir -p `dirname $dest_dotfile` # exclude .git/ from here
	if [ ! -h "$HOME/$dest_dotfile" ]; then
		if [[ ! $dest_dotfile == .git* ]]; then 
			ln -s "$src_dotfile" "$HOME/$dest_dotfile"
		fi
	fi
done

find -L $HOME -type l -delete

#copy/remove
#dotfiles=$(git ls-files)
#dotfiles=$(git ls-files)
#for dotfile in $dotfiles; do
#	cp --parents $dotfile /home/amytcheng/.dotfiles
#	rm $dotfile
#done
