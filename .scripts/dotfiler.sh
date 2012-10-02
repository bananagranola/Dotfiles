#!/bin/bash

# dotfiler.sh
# latest: https://raw.github.com/bananagranola/dotfiles/master/.scripts/dotfiler.sh
# author: rainermoerlinghartheim@yahoo.com

# symlink files in a dotfiles folder to where they belong in the home folder
# preserves folder structure
# very quick and very hacky

DOTFILES_DIR="$HOME/.dotfiles/"
DOTFILES_DIR_LENGTH=${#DOTFILES_DIR}

VERBOSE=0

log() {
	echo -e "\033[34m$@\033[0m"
}

log_verbose() {
	if [ $VERBOSE -eq 1 ]; then
		echo -e "\033[32m$@\033[0m"
	fi
}

log_error() {
	echo -e "\033[31m$@\033[0m"
}

# recurse through $DOTFILES_DIR and get list of dotfiles, including those in folders
dotfiles=$(find "$DOTFILES_DIR" -type f)

# iterate through dotfiles in $DOTFILES_DIR
for src_dotfile in $dotfiles; do

	# strip name of dotfiles folder from source to get destination
	# for example,
	# 	source: ~/.dotfiles/.mydotfile 
	# 	destination: .mydotfile
	#	source: ~/.dotfiles/.mydotfolder/mydotfile
	#	destination: .mydotfolder/mydotfile
	dest_dotfile="${src_dotfile:$DOTFILES_DIR_LENGTH}"

	# if symlink to file already exists, do not link
	if [ ! -h "$HOME/$dest_dotfile" ]; then

		# if dotfile is in .git or is the README file, do not link
		if [[ ! "$dest_dotfile" == .git* && ! "$dest_dotfile" == *README ]]; then

			# create parent folders if necessary
			# print if creation is necessary
			parent=$(dirname "$dest_dotfile")
			parent="$HOME/$parent"
			if [ ! -d "$parent" ]; then
				mkdir_output=$(mkdir --parents --verbose "$parent")
			fi
			# parent folder creation error check
			if [ $? -eq 0 ]; then
				if [[ $mkdir_output != " " && $mkdir_output != "" ]]; then
				log "DOTFILER: $mkdir_output FOLDER(S) CREATED"
			fi
			else
				log_error "DOTFILER: $mkdir_output FOLDER CREATION FAILED"
			fi

			# symlink the file
			# ask to confirm overwrite if file exists
			# print if linking succeeds
			ln_output="$(ln --interactive --symbolic --verbose "$src_dotfile" "$HOME/$dest_dotfile")"
			# symlink error check
			if [ $? -eq 0 ]; then
				log "DOTFILER: $ln_output LINKED"
			else
				log_error "DOTFILER: $dest_dotfile LINKING FAILED"
			fi

		else
			log_verbose "DOTFILER: $dest_dotfile IGNORED"
		fi
	else
		log_verbose "DOTFILER: $dest_dotfile ALREADY LINKED"
	fi
done

# remove dangling symlinks
log_verbose "DOTFILER: CHECKING DANGLING SYMLINKS"
danglers=$(find -L "$HOME" -type l)
for dangler in $danglers; do
	rm $dangler
	# remove danglers error check
	if [ $? -eq 0 ]; then
		log "DOTFILER: $dangler DANGLER REMOVED"
	else
		log_error "DOTFILER: $dangler DANGLER REMOVE FAILED"
	fi
done
log_verbose "DOTFILER: DONE CHECKING DANGLING SYMLINKS"

