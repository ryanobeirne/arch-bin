#!/bin/bash
[ $UID -eq 0 ] || exit 126
for i in /sys/class/backlight/*; do
	[ "$1" ] && echo "0" > "$i/brightness" ||	cat "$i/max_brightness" > "$i/brightness"
done
