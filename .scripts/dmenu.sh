#!/bin/sh
FONT="Envy Code R-9"
NB="#002b36"
NF="#93a1a1"
SB="#586e75"
SF="#fdf6e3"

cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
if [ -d "$cachedir" ]; then
	cache=$cachedir/dmenu_run
else
	cache=$HOME/.dmenu_cache
fi
APP=$(
	IFS=:
	if stest -dqr -n "$cache" $PATH; then
		stest -flx $PATH | sort -u | tee "$cache" | dmenu -b -f -i -fn $FONT -nb $NB -nf $NF -sb $SB -sf $SF
	else
		dmenu -b -f -i -fn $FONT -nb $NB -nf $NF -sb $SB -sf $SF < "$cache"
	fi
)
grep -q -w "$APP" ~/.scripts/dmenu.txt && st -t $APP -e $APP || echo $APP | ${SHELL:-"/bin/zsh"} &
