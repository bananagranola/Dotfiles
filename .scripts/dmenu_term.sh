#!/bin/sh
cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
if [ -d "$cachedir" ]; then
	cache=$cachedir/dmenu_run
else
	cache=$HOME/.dmenu_cache
fi
APP=$(
	IFS=:
	if stest -dqr -n "$cache" $PATH; then
		stest -flx $PATH | sort -u | tee "$cache" | dmenu "$@"
	else
		dmenu "$@" < "$cache"
	fi
)

grep -q -w "$APP" ~/.scripts/dmenu_term.txt && urxvtc -e $APP || echo $APP | ${SHELL:-"/bin/sh"} &
