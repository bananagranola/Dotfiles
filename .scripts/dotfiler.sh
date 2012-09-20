#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles/"
DOTFILES_DIR_LENGTH=${#DOTFILES_DIR}

# recurse through $DOTFILES_DIR and get list of dotfiles
dotfiles=$(find $DOTFILES_DIR -type f)

# iterate through dotfiles in $DOTFILES_DIR
for src_dotfile in $dotfiles; do

	# strip name of dotfiles folder from source to get destination
	# example.
	# 	source: ~/.dotfiles/.mydotfile 
	# 	destination: ~/.mydotfile
	dest_dotfile=${src_dotfile:$DOTFILES_DIR_LENGTH}

	# create parent folders if necessary
	mkdir -p `dirname $dest_dotfile`

	# check if symlink to file already exists
	if [ ! -h "$HOME/$dest_dotfile" ]; then
		# check if file is in .git
		if [[ ! $dest_dotfile == .git* ]]; then
			# symlink the file
			ln --symbolic --force "$src_dotfile" "$HOME/$dest_dotfile"
			# notify if link succeeded
			if [$? -eq 0 ]; then
				echo "$src_dotfile -> $HOME/$dest_dotfile"
			else
				echo "DOTFILER ERROR: $src_dotfile -!> $HOME/$dest_dotfile"
			fi
		fi
	fi
done

# cleanup dangling symlinks
find -L $HOME -type l -delete

