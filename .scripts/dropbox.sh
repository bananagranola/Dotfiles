#!/bin/bash

( until ping -q -W5 -c1 google.com &> /dev/null; do
    sleep 10
done

dropbox start

) &

