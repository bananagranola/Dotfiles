#!/bin/bash

gophersvidsfile="/home/stcheng/.scripts/gophersvids.txt"
poll="240m"

while true; do

	# retrieve and parse latest gophersvids uploads
	parsed="$(perl /home/stcheng/.scripts/gophersvids_parser.pl)"
	
	# make sure saved $gophersvidsfile file exists
	touch $gophersvidsfile

	# compare saved and new gophersvids lists
	diff=$(diff --changed-group-format='%<' --unchanged-group-format='' <(echo "$parsed") "$gophersvidsfile")

	if [[ "$diff" != "" ]]; then
		for line in $diff; do
			if [[ "$line" == *http* ]]; then
				# check vid title
				title=$(/home/stcheng/.scripts/youtube-dl.exe --get-title "$line")
				if [[ ! "$title" == *Vampire* ]]; then
					# download non-vampire vids
					echo "DOWNLOADING: $title"
					/home/stcheng/.scripts/youtube-dl.exe "$line" --output "v:/Youtube TV/%(title)s.%(ext)s"
				fi
			fi
		done
	fi
	
	if [ $? -eq 0 ]; then	
		# update $gophersvidsfile
		echo "$parsed" > $gophersvidsfile
		echo "$(date). SLEEPING: $poll"
		sleep $poll	
	else
		echo "ERROR: latest gophersvidsfile not saved! restarting!"
	fi

done
