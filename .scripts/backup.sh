#!/bin/bash

WINDOWS="/media/windows7/Users/amytcheng"
EXTERNAL="/media/FreeAgent_GoFlex_Drive/Backups"
HOME="/home/amytcheng"

# back up Music folder from Windows partition to external hard drive
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Music/" "$EXTERNAL/Music/"

# move Music folder from external hard drive to Windows partition
rsync --archive --compress --delete --human-readable --progress --verbose "$EXTERNAL/Music/" "$WINDOWS/Music/"

# back up Images folder from Windows partition to external hard drive
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/Pictures/" "$EXTERNAL/Images/"

# back up School folder from Windows partition to external hard drive
rsync --archive --compress --delete --human-readable --progress --verbose "$WINDOWS/School/" "$EXTERNAL/School/"

# back up latest Dotfiles git from home to external hard drive
git archive -o "$EXTERNAL/home/Dotfiles.tar.gz" HEAD

# back up entire hard drive image to external hard drive
#dd if=/dev/sda conv=sync,noerror bs=64K | gzip -c > "$EXTERNAL/$HOSTNAME.gz"

# monitor dd backup
#pgrep -l '^dd$'
#watch -n 10 kill -USR1 $ddpid

# restore dd backup
#gunzip -c /"$EXTERNAL/$HOSTNAME.gz" | dd of=/dev/hda conv=sync,noerror bs=64K
