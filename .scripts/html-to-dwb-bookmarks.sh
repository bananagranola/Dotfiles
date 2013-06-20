#!/bin/bash

grep -i http Downloads/bookmarks_6_20_13.html | awk '{print $2}' | sed -e "s/^.*\"\(.*\)\".*$/\1/" > .config/dwb/default/bookmarks
