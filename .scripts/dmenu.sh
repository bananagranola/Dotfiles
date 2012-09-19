#!/bin/bash

FONT="-*-termsyn-medium-*-*-*-11-*-*-*-*-*-*-1"
NB="#1F1F1F"
NF="#78956F"
SB="#3F3F3F"
SF="#6A8D9B"

/home/amytcheng/.scripts/dmenu_term.sh -b -f -i -fn $FONT -nb $NB -nf $NF -sb $SB -sf $SF &
exit 0
