# .xinitrc, run by startx

amixer set Master on 1% &
/home/amytcheng/.scripts/conky.sh &
dropboxd &
fbpanel &
/home/amytcheng/.scripts/grive_monitor.sh &
/home/amytcheng/.scripts/randombackground.sh &
slimebattery &
sxhkd &
twmnd &
std -f -o -q &
volumeicon &
xcalib -co 70 -a &
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

