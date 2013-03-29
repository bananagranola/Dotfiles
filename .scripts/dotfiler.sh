#!/bin/bash

# dotfiler.sh
# latest: https://raw.github.com/bananagranola/dotfiles/master/.scripts/dotfiler.sh
# author: rainermoerlinghartheim@yahoo.com

# symlink files from a dotfiles folder to $HOME folder, preserving folder structure

# CUSTOMIZE HERE
DOTFILES_DIR="$HOME/.dotfiles/"
# END CUSTOMIZATION

# log error in red
log_error() {
	echo -e "\033[31m$@\033[0m"
}

# log normal in blue
log() {
	echo -e "\033[34m$@\033[0m"
}

DOTFILES_DIR_LENGTH=${#DOTFILES_DIR}

# recurse through $DOTFILES_DIR and get list of all files, including those in folders
dotfiles=$(find "$DOTFILES_DIR" -type f)

# iterate through dotfiles in $DOTFILES_DIR
for src_dotfile in $dotfiles; do
	dest_dotfile="${src_dotfile:$DOTFILES_DIR_LENGTH}"

	# find actual dotfiles that are not already symlinked 
	if [ ! -h "$HOME/$dest_dotfile" ]; then
		if [[ ! "$dest_dotfile" == .git* && ! "$dest_dotfile" == *README ]]; then

			# create parent folders if necessary
			parent=$(dirname "$dest_dotfile")
			parent="$HOME/$parent"
			if [ ! -d "$parent" ]; then
				mkdir_output=$(mkdir --parents --verbose "$parent")
			fi
			if [ $? -eq 0 ]; then
				if [[ $mkdir_output != " " && $mkdir_output != "" ]]; then
					log "DOTFILER CREATED FOLDERS: $mkdir_output"
				fi
			else
				log_error "DOTFILER FAILED CREATING FOLDERS: $mkdir_output"
			fi

			# symlink the file
			ln_output="$(ln --interactive --symbolic --verbose "$src_dotfile" "$HOME/$dest_dotfile")"
			if [ $? -eq 0 ]; then
				log "DOTFILER LINKED: $ln_output"
			else
				log_error "DOTFILER FAILED LINKING: $dest_dotfile"
			fi
		fi
	fi
done



# remove dangling symlinks
danglers=$(find -L "$HOME" -type l)
for dangler in $danglers; do
	rm $dangler
	if [ $? -eq 0 ]; then
		log "DOTFILER REMOVED DANGLER: $dangler"
	else
		log_error "DOTFILER FAILED REMOVING DANGLER: $dangler"
	fi
done

