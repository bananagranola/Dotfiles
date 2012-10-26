#!/bin/bash

# getCfx.sh
# by bananagranola @ http://forum.xda-developers.com/member.php?u=4733042 

# gets the relevant pages at synergye.codefi.re
# extracts the filenames and finds the newest ones
# compares the current newest files to the previous newest files from a text file
# notifies you with notifymyandroid
# saves the current newest files to a text file

# CUSTOMIZE HERE
# location of notifymyandroid script
nmash="$HOME/.scripts/nma.sh"

# AND CUSTOMIZE HERE
# location of persistent text file containing newest zips
text="$HOME/.scripts/getCfx.txt"

# FINALLY CUSTOMIZE HERE
# add a field to the array for each folder you want to check on synergye.codefi.re
# note: assumes that you use the same folders between executions
# if you change folders or their order, you might get a false positive the first time
# you will need to initialize it once to populate the text file
folders[0]="codefireX-Ace"
folders[1]="KangBang-Ace-Kernels"
folders[2]="Ace-TestBuilds"

# (OPTIONALLY) CUSTOMIZE HERE
poll="" 	# execute once
#poll="30m"	# poll continuously, in date format

# DONE CUSTOMIZING

# creates 2 arrays of the same length of folders
# used to store current and previous newest zips
size=${#folders[@]}
currs[$size]=""
prevs[$size]=""

# store number of previous files in $text
prevsNum=0

# some hardcoded string variables
nma="https://www.notifymyandroid.com/publicapi/notify"
page="synergye.codefi.re"
nmash="$HOME/.scripts/nma.sh"

# retrieves nma.sh script
# asks for apikey
# no arguments
getNma() {
	if [ ! -x $nmash ]; then
		echo "nma.sh not found"
		echo "getting nma.sh"
		# retrieve nma.sh script, save it, make executable
		wget http://storage.locked.io/files/nma.sh
		mv nma.sh $nmash
		chmod 755 $nmash
		
		echo "register notifymyandroid at https://www.notifymyandroid.com/register.jsp"
		echo "then go to my account to get an api key"
		# get apikey
		while true; do
			echo "enter apikey here: "
			read apikey
			if [ ${#apikey} -eq 48 ]; then
				# save apikey in nma.sh script
				sedregex="s/APIkey=.*/APIkey=\"$apikey\"/g"
				sed -i $sedregex $nmash
				break
			else
				echo "apikey must be 48 chars."
			fi
		done
	fi
}

# parses folder page
# outputs name of newest zip on synergye.codefi.re
# used in parseCurrs()
# $1: foldername on synergye.codefi.re; ie: codefireX-Ace
parseCurr () {
	# retrieve folder page
	page="$(wget -q -O - $page/$1)"
	latest=""

	# loop through lines in page
	for line in $page; do
		# find lines with downloadable zips
		if [[ $line == *download=* ]]; then
			# extract zip name
			regex=".*$1.\(.*zip\).*"
			filename=$(expr match "$line" $regex)
			# save newest zip
			if [[ "$filename" > "$latest" ]]; then
				latest=$filename
			fi
		fi
	done

	# output filename: newest zip
	echo "$1: $latest"
}

# parses filenames using parseCurr()
# currs[]: populated 
# no arguments
parseCurrs() {
	i=0
	while [ $i -lt $size ]; do
		currs[$i]=$(parseCurr ${folders[$i]})
		i=$(($i+1))
	done
}

# parses file containing previous newest zips
# prevs[]: populated
# prevsNum: save number of lines/zips in $text file (used to determine first run)
# no arguments
parsePrevs() {
	# create $text file
	if [ ! -f $text ]; then
		touch $text
	fi

	# loops through lines in $text file
	i=0
	while read -r line; do
		# saves them in prevs[]
		prevs[i]="$line"
		i=$(($i+1))
	done < $text

	# print lines (for first run)
	prevsNum=$i
	
	# update $size
	if [ $size -lt $i ]; then
		size=$i
	fi

	# empty $text file
	cat /dev/null > $text
}

# loops through and compares current newest zips with previous newest zips
# notifies using notifymyandroid api
# no arguments
compareAndNotify() {
	# loops through and compares current newest zips with previous newest zips
	i=0
	changes=0
	while [ $i -lt $size ]; do
		if [[ ! "${currs[$i]}" == *${prevs[$i]}* ]]; then
			# notifies using notifymyandroid api
			# application: folders
			# event: currs
			# description: url
    		sh $nmash "${folders[$i]}" "${currs[$i]}" "$page/${folders[$i]}" 0
			# notifies linux on desktop with notify-send
			notify-send "new: ${currs[$i]}"
			# prints updated newest zip
			echo "new: ${currs[$i]}"
			changes=$(($changes+1))
		fi
		i=$(($i+1))
	done
	echo "$changes new zips"
}

# saves current newest zips into saved text file
# no arguments
save() {
	# make sure $text exists
	touch $text

	# prints current newest zips into saved text file
	i=0
	while [ $i -le ${#currs[$i]} ]; do
		echo -e "${currs[$i]}" >> $text
		i=$(($i+1))
	done

	echo "currently saved zips:"
	cat "$text"
}

# actually run stuff
# no arguments
getCfx() {
	getNma
	parseCurrs
	parsePrevs
	# do not notify if first run
	if [ $prevsNum -gt 0 ]; then
		compareAndNotify
	else
		echo "1ST EXECUTION"
	fi
	save
}

# main driver
# no arguments
main() {
	if [[ "$poll" == "" ]]; then
		getCfx
	else
		while true; do
			getCfx
			sleep $poll
		done
	fi
}

main

