#!/bin/bash

while read L; do
    k="`echo "$L" | cut -d '=' -f 1`"
    v="`echo "$L" | cut -d '=' -f 2`"
    export "$k=$v"
    done < <(grep -e '^\(title\|artist\|album\|stationName\|pRet\|pRetStr\|wRet\|wRetStr\|songDuration\|songPlayed\|rating\|coverArt\)=' /dev/stdin) # don't overwrite $1...

case "$1" in
    
    songstart)
        #echo "$title by $artist" > $HOME/.config/pianobar/nowplaying
	notify-send "pianobar: $title by $artist"
    ;;

    songfinish)
    ;;

    *)
        if [ "$pRet" -ne 1 ]; then
            notify-send "Pianobar - ERROR" "$1 failed: $pRetStr"
        elif [ "$wRet" -ne 1 ]; then
            notify-send "Pianobar - ERROR" "$1 failed: $wRetStr"
        fi
    ;;
esac
