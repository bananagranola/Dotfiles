#!/bin/bash

# $1: location of html
# $2: location of dwb bookmarks

grep -i http "$1" | awk '{print $2}' | sed -e "s/^.*\"\(.*\)\".*$/\1/" > "$2"
