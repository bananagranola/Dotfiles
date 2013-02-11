# .xinitrc, run by startx

. /etc/X11/xinit/xinitrc.d/* &

# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

amixer set Master on 1% &
/home/amytcheng/.scripts/conky.sh &
dropboxd &
fbpanel &
/home/amytcheng/.scripts/grive_monitor.sh &
/home/amytcheng/.scripts/randombackground.sh &
slimebattery &
twmnd &
urxvtd -f -o -q &
volumeicon &
xbindkeys &
xrdb ~/.Xresources.solarized
xsetroot -cursor_name left_ptr &
xscreensaver &

case $1 in
echinus)
	exec echinus
	;;

openbox)
	exec openbox
    ;;
*)
	exec echinus
	;;
esac

