#!/bin/bash

sources=\
"Adele
Angie Johnson
Anthony Evans
Ashley De La Rosa
Beyonce Knowles
Bob Gaudio
Cheesa
Chris Mann
Daniel Levitan
Dia Frampton
Kings of Leon
Jennifer Hudson
Leanne Mitchell
Lindsey Pavao
OneRepublic
Orlando Napier
Pip
The Piano Guys, John Schmidt & Steven Sharp Nelson
The Script
Tony Lucca
Tony Vincent
Trevin Hunt
Various Artists/Dirty Dancing
Various Artists/Moulin Rouge
Xenia"

old_IFS=$IFS
IFS=$'\n'

destination="$1"
if [ ! -d $destination ]; then
	echo "destination not found."
	exit 1
fi

if [ "$destination" == "" ]; then
	echo "no destination." 
	exit 1
fi

parentSource="/home/amytcheng/Music"
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
