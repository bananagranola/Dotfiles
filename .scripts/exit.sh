#!/bin/bash

gxmessage "Exit?" -center -buttons "_1. Logout:101,_2. Shutdown:102,_3. Reboot:103,_4. Cancel:104" -name "Exit"
case $? in
    101)
        # logout
        xdotool key "super+shift+q";;
    102)
        # shutdown
        sudo /sbin/shutdown -h now;;
    103)
        # reboot
        sudo /sbin/reboot;;
    104)
        # cancel
        exit 0;;
esac

exit 0
