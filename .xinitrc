# .xinitrc, run by startx

#conky &
/home/amytcheng/.scripts/dropbox.sh &
/home/amytcheng/.scripts/randombackground.sh &
twmnd &
urxvtd -f -o -q &
xbindkeys &
xrdb ~/.Xresources.solarized
xsetroot -cursor_name left_ptr &
xscreensaver &

case $1 in
monsterwm)
	/home/amytcheng/.scripts/monsterwm-dzen2.sh &
	exec /home/amytcheng/.scripts/monsterwm.sh
	;;
openbox)
	conky &
	fbpanel &
	exec dbus-launch ck-launch-session openbox
    ;;
*)
	exec goomwwm
	;;
esac

