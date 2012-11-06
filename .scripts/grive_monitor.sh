#!/bin/bash

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
	grive
done
