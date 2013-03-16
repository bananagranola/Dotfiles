#!/bin/bash

WINDOWS="/media/windows7/Users/amytcheng"
EXTERNAL="/media/FreeAgent_GoFlex_Drive/Backups"
SERVER="192.168.1.15"
HOME="/home/amytcheng"

# back up Music folder from Windows partition to external hard drive
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Music/" "$EXTERNAL/Music/"

# back up Images folder from Windows partition to external hard drive
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Pictures/" "$EXTERNAL/Images/"

# back up School folder from Windows partition to external hard drive
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/School/" "$EXTERNAL/School/"
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Documents/text.kdb" "$EXTERNAL/home/"
