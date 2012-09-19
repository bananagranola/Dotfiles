#!/bin/bash

target="$(realpath -s "$1")"
[ "$1" == '--' ] && shift

function listfiles {
	find "$(dirname "$target")" -maxdepth 1 -type f -regex '.*\(jpe?g\|png\|gif\)$' -print0 | sort -z
}

count="$(listfiles | grep -m 1 -zbx "$target" | cut -d: -f1)"
if [ -n "$count" ]; then
	files=$(listfiles | tr '\0' '\n')
	mehinput=${files:$count}
	mehinput+=${files:0:$count}
	meh $mehinput
else
	meh -- "$@"
	echo "fallback"
fi
