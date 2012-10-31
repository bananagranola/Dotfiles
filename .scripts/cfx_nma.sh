#!/bin/bash

# cfx_nma.sh
# by bananagranola @ http://forum.xda-developers.com/member.php?u=4733042 
# gets the relevant pages at synergye.codefi.re
# extracts the filenames and finds the newest ones
# compares the current newest files to the previous newest files from a text file
# notifies you with notifymyandroid
# saves the current newest files to the text file
# depends: curl, internet connection

# --- CUSTOMIZE HERE --- #
# location of apikey text file
apikey="$HOME/.scripts/nma.key"
# location of notifymyandroid perl script
nmapl="$HOME/.scripts/nma.pl"
# location of persistent text file
text="$HOME/.scripts/cfx_nma.sav"
# add a field to the array for each folder you want to check on synergye.codefi.re
# if you change/add folders or their order, delete $text file and re-execute script to repopulate it
# otherwise, you might get a false positive on first execution
folders[0]="codefireX-Ace"
folders[1]="KangBang-Ace-Kernels"
#folders[2]="Ace-TestBuilds"
# set polling interval in date format; if blank, executes once
#poll=""
poll="30m"
# -- DONE CUSTOMIZING -- #

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
	if [ ! -x $nmapl ]; then
		echo "NMA.PL NOT FOUND; RETRIEVING NMA.PL"
		# retrieve nma.pl script, save it, make executable
		curl http://storage.locked.io/files/nma.pl > $nmapl
		chmod 755 $nmapl
		# change https protocol to http for portability
		sed -i s/https/http/g $nmapl
	fi

	if [ ! -f $apikey ]; then
		echo "REGISTER AT http://www.notifymyandroid.com/"
		echo "GET APIKEY FROM MY ACCOUNT -> GENERATE KEY"
		read line
		touch $apikey
		echo $line > $apikey
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
    		perl $nmapl -apikeyfile="$apikey" \
				-application="${folders[$i]}" \
				-event="${currs[$i]}" \
				-notification="$cfxUrl/${folders[$i]}" \
				-priority=0
			# notifies linux desktop of updated newest zip
			if [[ "$(uname -o)" == "*GNU/Linux*" ]]; then
				notify-send "NEW ${currs[$i]}"
			fi
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

