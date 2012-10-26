#!/bin/bash

ALIGN="r"
XPOS=400
HEIGHT=11
FONT="-*-termsyn-medium-*-*-*-11-*-*-*-*-*-*-1"
BG="#1F1F1F"
FG="#A5A5A5"

DESKTOP=false
if [[ $HOSTNAME == "ATCHENG-110" ]]; then
    DESKTOP=true
fi

color() {
    case $2 in
    black)
        COLOR="#353535"
        ;;
    red)
        COLOR="#AF7561"
        ;;
    green)
        COLOR="#78956F"
        ;;
    yellow)
        COLOR="#E5CB85"
        ;;
    blue)
        COLOR="#6A8D9B"
        ;;
    magenta)
        COLOR="#94719D"
        ;;
    cyan)
        COLOR="#8DBDC0"
        ;;
    *) # white
        COLOR="#A5A5A5"
        ;;
    esac
    echo "^fg($COLOR)$1^fg()"
}

iconize() {
	echo "^i($1)"
}

ICONS="/usr/share/icons/dzen2"
CPUICON=$(iconize $ICONS/cpu.xbm)
DBOXICON=$(iconize $ICONS/diskette.xbm)
GMAILICON=$(iconize $ICONS/mail.xbm)
MUSICICON=$(iconize $ICONS/note.xbm)
NETWLAN0ICON=$(iconize $ICONS/wifi_02.xbm)
NETETH0ICON=$(iconize $ICONS/net_wired.xbm)
NETDOWNICON=$(iconize $ICONS/net_down_03.xbm)
POWERBATICON=$(iconize $ICONS/bat_full_01.xbm)
POWERLOWICON=$(iconize $ICONS/bat_low_01.xbm)
POWERACICON=$(iconize $ICONS/ac_01.xbm)
SOUNDOFFICON=$(iconize $ICONS/spkr_02.xbm)
SOUNDONICON=$(iconize $ICONS/spkr_01.xbm)

INTERVAL=10
CPUVAL=1
DBOXVAL=1
GMAILVAL=30
MUSICVAL=1
NETVAL=1
POWERVAL=1
SOUNDVAL=1
DATEVAL=3
LITHVAL=300

cpuCounter=$CPUVAL
dboxCounter=$DBOXVAL
gmailCounter=$GMAILVAL
musicCounter=$MUSICVAL
if ! $DESKTOP; then
    netCounter=$NETVAL
    powerCounter=$POWERVAL
else
    netCounter=0
    powerCounter=0
fi
soundCounter=$SOUNDVAL
dateCounter=$DATEVAL
lithCounter=$(( $LITHVAL-10 ))

while true; do

    if [ $cpuCounter -ge $CPUVAL ]; then
        if $DESKTOP; then
            cpu=$(sensors it8721-isa-0290 | grep 'temp1:' | cut -c16-17)
            cpu+="* "
            cpu+=$(sensors | grep 'temp2:' | cut -c16-17)
            cpu+="* "
            cpu+=$(nvidia-settings -query GPUCoreTemp | perl -ne 'print $1 if /GPUCoreTemp.*?: (\d+)./;')
            cpu+="*"
        else
            cpu=$(cat /proc/acpi/ibm/thermal | cut -c15-16)
            cpu+="*"
			#cpu+=$(aticonfig --odgt | grep "Sensor 0" | cut -c43-44)
			#cpu+="*"
        fi
        if [[ "$cpu" > "90*" ]]; then
			notify-send "CPU: $cpu"
            cpuLabel=$(color "$CPUICON" "red")
        else
            cpuLabel=$(color "$CPUICON" "blue")
        fi
        cpu=$(color "$cpu" "green")
        cpuCounter=0
    fi

    if [ $dboxCounter -ge $DBOXVAL ]; then
        dboxLabel=$(color "$DBOXICON" "blue")
        dbox=$(dropbox status | tr -d '\n')
        dbox=$(color "$dbox" "green")
        dboxCounter=0
    fi

    if [ $gmailCounter -ge $GMAILVAL ]; then
        if $(ping -q -W5 -c1 google.com &> /dev/null); then
            gmail=$(/home/amytcheng/.scripts/gmail.py -c)
            gmailCounter=0
        else
            gmail="-"
            gmailCounter=$(( $GMAILVAL-1 ))
        fi
        if [[ "$gmail" != "0" && "$gmail" != "-" ]]; then
            notify-send "GMAIL: $gmail"
			gmailLabel=$(color "$GMAILICON" "red")
        else
            gmailLabel=$(color "$GMAILICON" "blue")
        fi
        gmail=$(color "$gmail" "green")
    fi

    if [ $musicCounter -ge $MUSICVAL ]; then
        if [ "$(pidof mocp)" ]; then
            music=$(mocp -Q "%song by %artist")
        elif [ "$(pidof pianobar)" ]; then 
           music=$(cat /home/amytcheng/.config/pianobar/nowplaying)
        else
            music="-"
        fi
        musicLabel=$(color "$MUSICICON" blue)
        music=$(color "$music" "green")
        musicCounter=0
    fi

    if [ $netCounter -ge $NETVAL ]; then
        if [[ "$(cat /sys/class/net/wlan0/operstate)" == "up" ]]; then
            netLabel=$(color "$NETWLAN0ICON" "blue")
            net=$(iwconfig wlan0 | grep -o [0-9][0-9]/[0-9][0-9])
            net=$(color "$net" "green")
        elif [[ "$(cat /sys/class/net/eth0/operstate)" == "up" ]]; then
            netLabel=$(color "$NETETH0ICON" "blue")
            net=$(color "up" "green")
        else
            netLabel=$(color "$NETDOWNICON" "red")
            net="-"
        fi
        netCounter=0
    fi

    if [ $powerCounter -ge $POWERVAL ]; then
        power=$(acpi | egrep -o '[0-9]%|[0-9][0-9]%|[0-9][0-9][0-9]%' | sed 's/.$//')
        if [[ $(acpi | grep Discharging) =~ "Discharging" ]]; then
            if [ $power -le 10 ]; then
				if [ $gmailCounter -ge $GMAILVAL ]; then
					notify-send "POWER: $power"
				fi
				powerLabel=$(color "$POWERLOWICON" "red")
            else
                powerLabel=$(color "$POWERBATICON" "blue")
            fi
        else
            powerLabel=$(color "$POWERACICON" "blue")
        fi
        power=$(color "$power%" "green")
        powerCounter=0
    fi

    if [ $soundCounter -ge $SOUNDVAL ]; then
        if [ "$(amixer sget 'Master' | egrep -o -m 1 'off|\bon\b' | tr -d '\n')" == "on" ]; then
            soundLabel=$(color "$SOUNDONICON" "red")
        else
            soundLabel=$(color "$SOUNDOFFICON" "blue")
        fi
        sound=$(amixer sget 'Master' | egrep -o -m 1 '[0-9]%|[0-9][0-9]%|[0-9][0-9][0-9]%')
        sound=$(color "$sound" "green")
        soundCounter=0
    fi

    if [ $dateCounter -ge $DATEVAL ]; then
        date=$(date +'%I.%M%P * %a * %m.%d.%g')
        date=$(color "$date")
        dateCounter=0
    fi

    if [ $lithCounter -ge $LITHVAL ]; then
        if $(ping -q -W5 -c1 google.com &> /dev/null); then
            lith=$(/home/amytcheng/.scripts/lith.py)
			get_cfx=$(/home/amytcheng/.scripts/get_cfx.sh)
			lithCounter=0
        else
            lithCounter=$(( $lithCounter-$INTERVAL ))
        fi
    fi

    STATUS="$cpuLabel: $cpu | $dboxLabel: $dbox | $gmailLabel: $gmail | $musicLabel: $music | "
    if ! $DESKTOP; then
        STATUS+="$netLabel: $net | $powerLabel: $power | "
    fi
    STATUS+="$soundLabel: $sound | $date"
    
    echo -e "^tw()$STATUS"

    cpuCounter=$(( $cpuCounter+1 ))
    dboxCounter=$(( $dboxCounter+1 ))
    gmailCounter=$(( $gmailCounter+1 ))
    musicCounter=$(( $musicCounter+1 ))
    if ! $DESKTOP; then
        netCounter=$(( $netCounter+1 ))
        powerCounter=$(( $powerCounter+1 ))
    fi
    soundCounter=$(( $soundCounter+1 ))
    dateCounter=$(( $dateCounter+1 ))
    lithCounter=$(( $lithCounter+1 ))

    sleep $INTERVAL
done | dzen2 -l 5 -ta $ALIGN -sa $ALIGN -x $XPOS -h $HEIGHT -fn $FONT -bg $BG -fg $FG -e '' & 
exit 0

