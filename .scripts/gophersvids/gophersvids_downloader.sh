#!/bin/bash

gophersvidsfolder="/mnt/data/Youtube/GophersVids"

gophersvidsfile="/home/amytcheng/.scripts/gophersvids/gophersvids.txt"
parserscript="/home/amytcheng/.scripts/gophersvids/gophersvids_parser.pl"
youtubedlscript="/usr/bin/youtube-dl"

# retrieve and parse latest gophersvids uploads
parsed="$(perl $parserscript)"

# check if $gophersvidsfile already exists and create it
if [ ! -e $gophersvidsfile ]; then
	echo "GOPHERSVIDS CREATING: $gophersvidsfile"
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
			echo "GOPHERSVIDS DOWNLOADING: $title"
			$youtubedlscript "$line" --output "$gophersvidsfolder/%(stitle)s.%(ext)s" 
		fi
	done
fi

# update $gophersvidsfile
if [ $? -eq 0 ]; then	
	echo "$parsed" > $gophersvidsfile
	echo "GOPHERSVIDS COMPLETED: $(date +'[%Y.%m.%d]@[%I.%M.%S%P]')."
else
	echo "GOPHERSVIDS ERROR: oh noes!"
fi

