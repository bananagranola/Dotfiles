#!/bin/bash

# cfx_nma.sh
# by bananagranola @ http://forum.xda-developers.com/member.php?u=4733042 
# gets the relevant pages at synergye.codefi.re
# extracts the filenames and finds the newest ones
# compares the current newest files to the previous newest files from a text file
# notifies you with notifymyandroid
# saves the current newest files to the text file
# depends: curl, internet connection

cfxUrl="http://synergye.codefi.re"
cfxUrl42="http://downloads.codefi.re/synergy"

# CUSTOMIZE HERE ----- #
# location of apikey file
apikey="$HOME/.scripts/nma.key"
# location of notifymyandroid perl script
nmash="$HOME/.scripts/nma.pl"
# location of persistent text file containing newest zips
text="$HOME/.scripts/cfx_nma.txt"
# add a field to the array for each folder you want to check, using cfxUrl and cfxUrl42 variables above
# if you change/add folders or their order, delete $text file and re-execute script to repopulate it
# otherwise, you might get a false positive on first execution
folders[0]="$cfxUrl/codefireX-Ace"
folders[1]="$cfxUrl/KangBang-Ace-Kernels"
folders[2]="$cfxUrl42/codefireX-Ace"
# optionally set polling interval
#poll="" 	# execute once
poll="30m"	# poll continuously, in date format
# DONE CUSTOMIZING --- #

# variables storing current and previous newest zips
currs[$size]=""
prevs[$size]=""
# variable storing size of folders array
size=${#folders[@]}
# variable storing number of previous files in $text
prevsNum=0

# retrieves nma.sh script
# asks for apikey
# no arguments
getNma() {
	if [ ! -x $nmash ]; then
		echo "NMA.PL NOT FOUND; RETRIEVING NMA.PL"
		# retrieve nma.pl script, save it, make executable
		curl http://storage.locked.io/files/nma.pl > $nmash
		chmod 755 $nmash
		# change https protocol to http for portability
		sed -i s/https/http/g $nmash
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
		page="$(curl --silent --show-error ${folders[$i]})"
		# loop through lines in page
		for line in $page; do
			# find lines with downloadable zips
			if [[ $line == *[A-Z][a-z][a-z]-[0-9][0-9]-[0-9][0-9]* ]]; then
				# extract rom name
				folder=$(echo ${folders[$i]} | cut -d "/" -f4)
				if [[ $folder == "synergy" ]]; then
					folder=$(echo ${folders[$i]} | cut -d '/' -f5)
				fi
				# extract zip name
				regex=".*$folder.\(.*zip\).*"
				filename=$(expr match "$line" $regex)
				# save newest zip
				if [[ "$filename" > "$latest" ]]; then
					latest="$folder: $filename"
				fi
			fi
		done
		currs[$i]="$latest"
		echo "$latest"
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
    		perl $nmash -apikeyfile="$apikey" \
				-application="${folders[$i]}" \
				-event="${currs[$i]}" \
				-notification="$cfxUrl/${folders[$i]}" \
				-priority=0
			# prints updated newest zip
			echo -e "${currs[$i]} NEWER THAN \n${prevs[$i]}"
			changes=$(($changes+1))
		fi
		i=$(($i+1))
	done
	echo -e "$(date): $changes/$size NEW\n"
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
		echo -e "$(date): FIRST EXECUTION; NO NOTIFICATIONS\n"
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

