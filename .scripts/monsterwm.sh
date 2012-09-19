#!/bin/bash

ALIGN="l"
XPOS=0
WIDTH=400
HEIGHT=11
FONT="-*-termsyn-medium-*-*-*-11-*-*-*-*-*-*-1"
BG="#1F1F1F"
FG="#A5A5A5"

REGULAR="#78956F"
CURRENT="#6A8D9B"
URGENT="#AF7561"

: "${wm:=monsterwm}"
: "${ff:="/tmp/${wm}.fifo"}"

[[ -p $ff ]] || mkfifo -m 600 "$ff"
ds=("one" "two" "three" "four")
ms=("T" "M" "B" "G" "F") # tile monocle bottomstack grid floating
while read -r; do
        [[ $REPLY =~ ^(([[:digit:]]+:)+[[:digit:]]+ ?)+$ ]] && read -ra desktops <<< "$REPLY" || continue
        for desktop in "${desktops[@]}"; do
            IFS=':' read -r d w m c u <<< "$desktop"
            # d - the desktop id
			# w - number of windows in that desktop
			# m - tiling layout/mode for that desktop
			# c - whether that desktop is the current (1) or not (0)
			# u - whether a window in that desktop has an urgent hint set (1) or not (0)
			((c)) && fg="$CURRENT" i="${ms[$m]}" || fg="$REGULAR"
            ((u)) && w+='^fg($URGENT)!'
			r+="^fg()[^fg($fg)${ds[$d]}^fg():^fg($fg)${w/#0/^fg($fg)0}^fg()]"
        done
        printf "[%s] %s\n" "$i" "$r" && unset r
done < "$ff" | dzen2 -ta $ALIGN -x $XPOS -w $WIDTH -h $HEIGHT -fn $FONT -bg $BG -fg $FG &

monsterwm > "$ff"
