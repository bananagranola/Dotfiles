#!/bin/bash

# cfx_nma.sh
# by bananagranola @ http://forum.xda-developers.com/member.php?u=4733042 
# gets the relevant pages at synergye.codefi.re
# extracts the filenames and finds the newest ones
# compares the current newest files to the previous newest files from a text file
# notifies you with notifymyandroid
# saves the current newest files to the text file
# depends: curl, internet connection

# CUSTOMIZE HERE ----- #
# location of notifymyandroid script
nmash="$HOME/.scripts/nma.sh"
# location of persistent text file containing newest zips
text="$HOME/.scripts/cfx_nma.txt"
# add a field to the array for each folder you want to check on synergye.codefi.re
# if you change/add folders or their order, delete $text file and re-execute script to repopulate it
# otherwise, you might get a false positive on first execution
folders[0]="codefireX-Ace"
folders[1]="KangBang-Ace-Kernels"
folders[2]="Ace-TestBuilds"
# optionally set polling interval
poll="" 	# execute once
#poll="30m"	# poll continuously, in date format
# DONE CUSTOMIZING --- #

# variables storing current and previous newest zips
currs[$size]=""
prevs[$size]=""
# variable storing size of folders array
size=${#folders[@]}
# variable storing number of previous files in $text
prevsNum=0

# variables storing hardcoded strings
cfxUrl="http://synergye.codefi.re"

# retrieves nma.sh script
# asks for apikey
# no arguments
getNma() {
	if [ ! -x $nmash ]; then
		echo "NMA.SH NOT FOUND; RETRIEVING NMA.SH"
		# retrieve nma.sh script, save it, make executable
		curl http://storage.locked.io/files/nma.sh > $nmash
		
		chmod 755 $nmash
		
		echo "REGISTER @ https://www.notifymyandroid.com/register.jsp"
		echo "MY ACCOUNT -> API KEY"
		# get apikey
		while true; do
			echo "ENTER APIKEY HERE: "
			read apikey
			if [ ${#apikey} -eq 48 ]; then
				# save apikey in nma.sh script
				sedregex="s/APIkey=.*/APIkey=\"$apikey\"/g"
				sed -i $sedregex $nmash
				sed -i  "s/ping -c.*/ping -w 5 google.com/g" $nmash
				break
			fi
		done
	fi
}

# parses webpages and finds current newest zips
# currs[]: populated
# $1: foldername on synergye.codefi.re; ie: codefireX-Ace
parseCurrs () {
	# loop through webpages
	i=0
	while [ $i -lt $size ]; do
		latest=""
		# retrieve raw page
		echo "RETRIEVING ${folders[$i]}"
		page="$(curl $cfxUrl/${folders[$i]})"
		# loop through lines in page
		for line in $page; do
			# find lines with downloadable zips
			if [[ $line == *download=* ]]; then
				# extract zip name
				regex=".*${folders[$i]}.\(.*zip\).*"
				filename=$(expr match "$line" $regex)
				# save newest zip
				if [[ "$filename" > "$latest" ]]; then
					latest=$filename
				fi
			fi
		done
		currs[$i]="${folders[$i]}: $latest"
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
			# notifies notifymyandroid of updated newest zip
			# application: folders
			# event: currs
			# description: url
    		sh $nmash "${folders[$i]}" "${currs[$i]}" "$cfxUrl/${folders[$i]}" 0
			# notifies linux desktop of updated newest zip
			notify-send "NEW ${currs[$i]}"
			# prints updated newest zip
			echo "NEW ${currs[$i]}"
			changes=$(($changes+1))
		fi
		i=$(($i+1))
	done
	echo "$(date): $changes/$size NEW"
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
}

# actually run stuff
# no arguments
cfx_nma() {
	getNma
	parseCurrs
	parsePrevs
	# do not notify if first run
	if [ $prevsNum -gt 0 ]; then
		compareAndNotify
		save
	else
		echo "$(date): FIRST EXECUTION; NO NOTIFICATIONS"
		save
		cat $text
	fi
}

# main driver
# no arguments
main() {
	if [[ "$poll" == "" ]]; then
		cfx_nma
	else
		while true; do
			cfx_nma
			sleep $poll
		done
	fi
}

main

