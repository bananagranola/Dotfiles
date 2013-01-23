# .xinitrc, run by startx

. /etc/X11/xinit/xinitrc.d/* &

conky --config $HOME/.conkyrc.ATC-Linny &
dropboxd &
fbpanel &
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
	exec echinus
	;;

openbox)
	exec openbox
    ;;
*)
	exec echinus
	;;
esac

