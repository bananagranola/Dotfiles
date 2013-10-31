#!/bin/bash

# $1: input
# $2: output

gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -sOutputFile="$2" "$1"
