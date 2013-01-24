#!/bin/bash

if [[ $HOSTNAME == "ATCHENG-l10" ]]; then
	conky $HOME/.conkyrc.ATCHENG-l10
else
	conky $HOME/.conkyrc.ATCHENG-Linny
fi
