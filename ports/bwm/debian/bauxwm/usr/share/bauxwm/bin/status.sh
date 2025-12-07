#!/bin/sh
# Roxanne status — only time, red on black, updates every 10s
while :; do
    xsetroot -name "$(date '+%a %d %b %H:%M')"
    sleep 10
done
