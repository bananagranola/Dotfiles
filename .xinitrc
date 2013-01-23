# .xinitrc, run by startx

. /etc/X11/xinit/xinitrc.d/* &

conky &
dropboxd &
/home/amytcheng/.scripts/grive_monitor.sh &
/home/amytcheng/.scripts/randombackground.sh &
twmnd &
urxvtd -f -o -q &
xbindkeys &
xrdb ~/.Xresources.solarized
xsetroot -cursor_name left_ptr &
xscreensaver &

case $1 in
echinus)
	fbpanel &
	exec echinus

openbox)
	fbpanel &
	exec openbox
    ;;
*)
	exec openbox
	;;
esac

