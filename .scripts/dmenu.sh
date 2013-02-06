#!/bin/bash

FONT="-*-termsyn-medium-*-*-*-11-*-*-*-*-*-*-1"
NB="#002b36"
NF="#268bd2"
SB="#93a1a1"
SF="#859900"

/home/amytcheng/.scripts/dmenu_term.sh -b -f -i -fn $FONT -nb $NB -nf $NF -sb $SB -sf $SF &
exit 0
