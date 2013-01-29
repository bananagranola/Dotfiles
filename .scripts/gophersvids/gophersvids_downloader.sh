#!/bin/bash

poll="240m"

# ATCHENG-*
gophersvidsfile="/home/amytcheng/.scripts/gophersvids/gophersvids.txt"
parserscript="/home/amytcheng/.scripts/gophersvids/gophersvids_parser.pl"
youtubedlscript="youtube-dl"

# STCHENG-REMORA
#gophersvidsfile=	"/home/stcheng/.scripts/gophersvids.txt"
#parserscript=		"/home/stcheng/.scripts/gophersvids_parser.pl"
#youtubedlscript=	"/home/stcheng/.scripts/youtube-dl.exe"

while true; do

	# retrieve and parse latest gophersvids uploads
	parsed="$(perl $parserscript)"

	# check if $gophersvidsfile already exists and create it
	if [ ! -e $gophersvidsfile ]; then
		echo "CREATING: $gophersvidsfile"
		touch $gophersvidsfile
		echo "$parsed" > $gophersvidsfile
		echo "$(date). SLEEPING: $poll"
		sleep $poll
	fi

	# compare saved and new gophersvids lists
	diff=$(diff --changed-group-format='%<' --unchanged-group-format='' <(echo "$parsed") "$gophersvidsfile")

	# parse diff for new vids
	if [[ "$diff" != "" ]]; then
		for line in $diff; do
			if [[ "$line" == *http* ]]; then
				# check vid title
				title=$($youtubedlscript --get-title "$line")
				if [[ ! "$title" == *Vampire* ]]; then
					# download non-vampire vids
					echo "DOWNLOADING: $title"
					$youtubedlscript "$line" --output "v:/Youtube TV/%(title)s.%(ext)s"
				fi
			fi
		done
	fi
	
	# update $gophersvidsfile
	if [ $? -eq 0 ]; then	
		echo "$parsed" > $gophersvidsfile
		echo "$(date). SLEEPING: $poll"
		sleep $poll	
	else
		echo "ERROR: restarting!"
	fi

done
