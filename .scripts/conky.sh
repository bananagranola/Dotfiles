#!/bin/bash

if [[ $HOSTNAME == "ATCHENG-l10" ]]; then
	conky -c $HOME/.conkyrc.ATC-l10
else
	conky -c $HOME/.conkyrc.ATC-Linny
fi
