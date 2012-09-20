#!/bin/bash

# dotfiler.sh
# latest: https://raw.github.com/bananagranola/dotfiles/master/.scripts/dotfiler.sh
# 
# symlink files in a dotfiles folder to where they belong in the home folder
# preserves folder structure
# 
# very quick and very hacky
# in general, uses utilities' own options
# for example, ln --interactive --verbose
# therefore, output will not look uniform

DOTFILES_DIR="$HOME/.dotfiles/"
DOTFILES_DIR_LENGTH=${#DOTFILES_DIR}

# recurse through $DOTFILES_DIR and get list of dotfiles
dotfiles=$(find "$DOTFILES_DIR" -type f)

# iterate through dotfiles in $DOTFILES_DIR
for src_dotfile in $dotfiles; do

	# strip name of dotfiles folder from source to get destination
	# for example,
	# 	source: ~/.dotfiles/.mydotfile 
	# 	destination: ~/.mydotfile
	dest_dotfile="${src_dotfile:$DOTFILES_DIR_LENGTH}"

	# if symlink to file already exists, do not link
	if [ ! -h "$HOME/$dest_dotfile" ]; then

		# if dotfile is in .git or is the README file, do not link
		if [[ ! "$dest_dotfile" == .git* && ! "$dest_dotfile" == *README ]]; then

			# create parent folders if necessary
			# print if creation is necessary
			mkdir_output="$(mkdir --parents --verbose $(dirname "$dest_dotfile"))"
			# parent folder creation error check
			if [ $? -eq 0 ]; then
				echo "DOTFILER: $mkdir_output FOLDER(S) CREATED"
			else
				echo "DOTFILER: $mkdir_output FOLDER CREATION FAILED"
			fi

			# symlink the file
			# ask to confirm overwrite if file exists
			# print if linking succeeds
			ln_output="$(ln --interactive --symbolic --verbose "$src_dotfile" "$HOME/$dest_dotfile")"
			# symlink error check
			if [ $? -eq 0 ]; then
				echo "DOTFILER: $ln_output LINKED"
			else
				echo "DOTFILER: $dest_dotfile LINKING FAILED"
			fi

		else
			echo "DOTFILER: $dest_dotfile IGNORED"
		fi
	else
		echo "DOTFILER: $dest_dotfile ALREADY LINKED"
	fi
done

# remove dangling symlinks
echo "DOTFILER: REMOVING DANGLING SYMLINKS"
danglers=$(find -L "$HOME" -type l)
for dangler in $danglers; do
	rm $dangler
	# remove danglers error check
	if [ $? -eq 0 ]; then
		echo "DOTFILER: $dangler DANGLER REMOVED"
	else
		echo "DOTFILER: $dangler DANGLER REMOVE FAILED"
	fi
done

