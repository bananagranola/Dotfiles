#!/bin/bash

parentSource="/home/amytcheng/Music"
destination="$1"

sources=\
"Adele
Amanda Brown
Bob Gaudio
Carrie Underwood
Cheesa
Chris Mann
Daniel Levitan
Kings of Leon
Josh Groban
Leanne Mitchell
OneRepublic
The Piano Guys, John Schmidt & Steven Sharp Nelson
The Script
Tony Vincent
Trevin Hunt
Xenia"

old_IFS=$IFS
IFS=$'\n'

if [ ! -d $destination ]; then
	echo "destination not found."
	exit 1
fi

if [ "$destination" == "" ]; then
	echo "no destination." 
	exit 1
fi

if [ ! -d $parentSource ]; then
	echo "source not found."
	exit 1
fi

for source in $sources; do
	if [ -d "$parentSource/$source" ]; then
		rsync --archive --compress --delete --human-readable --progress --verbose "$parentSource/$source" "$destination"
	else
		echo "$parentSource/$source not found."
	fi
done

IFS=$old_IFS
exit 0
