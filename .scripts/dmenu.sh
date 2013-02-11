#!/bin/sh
FONT="-*-termsyn-medium-*-*-*-11-*-*-*-*-*-*-1"
NB="#002b36"
NF="#268bd2"
SB="#93a1a1"
SF="#859900"

ARGS="-b -f -i -fn $FONT -nb $NB -nf $NF -sb $SB -sf $SF"

cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
if [ -d "$cachedir" ]; then
	cache=$cachedir/dmenu_run
else
	cache=$HOME/.dmenu_cache
fi
APP=$(
	IFS=:
	if stest -dqr -n "$cache" $PATH; then
		stest -flx $PATH | sort -u | tee "$cache" | dmenu -b -f -i -fn $FONT -b $NB -nf $NF -sb $SB -sf $SF
	else
		dmenu -b -f -i -fn $FONT -nb $NB -nf $NF -sb $SB -sf $SF < "$cache"
	fi
)

grep -q -w "$APP" ~/.scripts/dmenu_term.txt && urxvtc -e $APP || echo $APP | ${SHELL:-"/bin/sh"} &
