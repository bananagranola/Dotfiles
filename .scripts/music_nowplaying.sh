#!/bin/bash

if [ "$(pidof mocp)" ]; then
	echo $(mocp -Q "%song by %artist") | cut -c1-35
elif [ "$(pidof pianobar)" ]; then
	echo $(cat /home/amytcheng/.config/pianobar/nowplaying) | cut -c1-35
fi
