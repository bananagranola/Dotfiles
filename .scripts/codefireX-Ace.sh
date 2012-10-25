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

i=0
while read -r line; do
	prevs[i]="$line"
	i=$(($i+1))
done < $text

if [ -f $text ]; then
   cat /dev/null > $text
else
   touch $text
fi


cfxLatest=$(parse $cfx)
if [[ "$cfxLatest" != ${prevs[0]} ]]; then
    ./nma.sh $cfx $cfxLatest $page/$cfx 0
	echo "$cfx: $cfxLatest"
fi
kbLatest=$(parse $kb)
if [[ "$kbLatest" != ${prevs[1]} ]]; then
    ./nma.sh $kb $kbLatest $page/$kb 0
	echo "$kb: $kbLatest"
fi
atbLatest=$(parse $atb)
if [[ "$atbLatest" != ${prevs[2]} ]]; then
    ./nma.sh $atb $atbLatest $page/$atb 0
	echo "$atb: $atbLatest"
fi

echo -e "$cfxLatest
$kbLatest
$atbLatest" > $text
