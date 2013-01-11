#!/bin/bash

# run once on start
( until ping -q -W5 -c1 google.com &> /dev/null; do
	cd $HOME/Drive && grive && cd -
done ) &

# watch for file changes and run grive if changes detected
while inotifywait --recursive \
	--event modify \
	--event move \
	--event create \
	--event delete  \
	$HOME/Drive/ \
	@$HOME/Drive/.grive \
	@$HOME/Drive/.grive_state \
	--exclude .~lock.*
do
	cd $HOME/Drive
	grive > ~/.grive.log
done
