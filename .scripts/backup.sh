#!/bin/bash

WINDOWS="/media/windows7/Users/amytcheng"
EXTERNAL="/media/FreeAgent_GoFlex_Drive__"
HOME="/home/amytcheng"

rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Music/" "$EXTERNAL/Music/"
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Pictures/" "$EXTERNAL/Images/"
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/School/" "$EXTERNAL/School/"
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Documents/text.kdb" "$EXTERNAL/"
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Applications/" "$EXTERNAL/Applications/"
