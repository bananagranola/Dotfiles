#!/bin/bash

if [ "$(pidof mocp)" ]; then
    case $1 in
    quit)
        mocp --exit
        ;;
    next)
        mocp --next
        ;;
    pause)
        mocp --toggle-pause
        ;;
    previous)
        mocp --previous
        ;;
    *)
        ;;
    esac
fi

if [ "$(pidof pianobar)" ]; then
    case $1 in
    quit)
        echo -n 'q' > ~/.config/pianobar/ctl
        ;;
    next)
        echo -n 'n' > ~/.config/pianobar/ctl
        ;;
    pause)
        echo -n 'p' > ~/.config/pianobar/ctl
        ;;
    *)
        ;;
    esac
fi
