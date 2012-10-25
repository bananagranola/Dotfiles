#!/bin/bash

page="synergye.codefi.re"
cfx="codefireX-Ace"
kb="KangBang-Ace-Kernels"
atb="Ace-TestBuilds"
text="codefireX.txt"

apikey="e0e5d265dee9dc4c872900c531c62583bac7e9816f951202"
nma="https://www.notifymyandroid.com/publicapi/notify"

# $1: url
parse () {
	page="$(wget -q -O - $page/$1)"
	latest=""

	for line in $page; do
		if [[ $line == *download=* ]]; then
			regex=".*$1.\(.*zip\).*"
			filename=$(expr match "$line" $regex)
			if [[ "$filename" > "$latest" ]]; then
				latest=$filename
			fi
		fi
	done

	echo $latest
}

# $1: application
# $2: event
# #3: description
request() {
	curl --data \
		apikey=$apikey&\
		application=$1&\
		event=$2&\
		description=$3&\
		url=$page/$1\
		$nma
}

i=0
while read -r line; do
	prevs[i]="$line"
	i=$(($i+1))
done < codefireX.txt

cfxLatest=$cfx:$(parse $cfx)
if [[ "$cfxLatest" != ${prevs[0]} ]]; then
    request $cfx $cfxLatest $cfxLatest
fi
kbLatest=$kb:$(parse $kb)
if [[ "$kbLatest" != ${prevs[1]} ]]; then
    request $kb $kbLatest $kbLatest
fi
atbLatest=$atb:$(parse $atb)
if [[ "$atbLatest" != ${prevs[2]} ]]; then
    request $atb $atbLatest $atbLatest
fi

