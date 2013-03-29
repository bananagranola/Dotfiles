#!/bin/bash

if [ "$(pidof mocp)" ]; then
	echo $(mocp -Q "%song by %artist") | cut -c1-40
elif [ "$(pidof pianobar)" ]; then
	echo $(cat /home/amytcheng/.config/pianobar/nowplaying) | cut -c1-40
fi
