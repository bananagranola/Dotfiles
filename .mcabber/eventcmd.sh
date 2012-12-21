#!/bin/bash

event=$1
arg1=$2
arg2=$3
filename=$4

if [ $event == "MSG" ]; then
		notify-send "$arg2: $arg3"
fi
