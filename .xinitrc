# .xinitrc, run by startx

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
wicd-client --tray &
xbindkeys &
xrdb ~/.Xresources.solarized
xsetroot -cursor_name left_ptr &
xscreensaver &

case $1 in
echinus)
	exec dbus-launch echinus
	;;

openbox)
	exec openbox
    ;;
*)
	exec echinus
	;;
esac

