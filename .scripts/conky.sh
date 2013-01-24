#!/bin/bash

if [[ $HOSTNAME == "ATCHENG-l10" ]]; then
	conky -c $HOME/.conkyrc.ATCHENG-l10
else
	conky -c $HOME/.conkyrc.ATCHENG-Linny
fi
