#!/bin/bash

if [ "$(pidof mocp)" ]; then
	echo $(mocp -Q "%song by %artist")
elif [ "$(pidof pianobar)" ]; then
	echo $(cat /home/amytcheng/.config/pianobar/nowplaying)
fi
