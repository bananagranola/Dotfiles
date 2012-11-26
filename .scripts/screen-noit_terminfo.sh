#!/bin/bash

# forces screen/tmux multiplexer to use standout instead of italics
# from http://sourceforge.net/mailarchive/message.php?msg_id=27366130
mkdir -p $HOME/.terminfo/
infocmp screen-256color | sed \
	-e 's/^screen[^|]*|[^,]*,/screen-noit|screen with proper standout,/' \
	-e 's/smso=[^,]*,/smso=\\E[7m,/' \
	-e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
	-e 's/ \?sitm=[^,]*,//' \
	-e 's/ \?ritm=[^,]*,//' > /tmp/terminfo
tic /tmp/terminfo
sed 's/default-terminal \".*\"/default-terminal \"screen-noit\"/g' .tmux.conf
