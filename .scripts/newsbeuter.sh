#!/bin/bash

# reload feeds
newsbeuter -x reload

# notify number of articles
notify-send "newsbeuter: $(newsbeuter -x print-unread)"
