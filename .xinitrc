# .xinitrc, run by startx

/home/amytcheng/.scripts/conky.sh &
fbpanel &
/home/amytcheng/.scripts/randombackground.sh &
slimebattery &
sxhkd &
twmnd &
volumeicon &
xcalib -co 70 -a &
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr &

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

