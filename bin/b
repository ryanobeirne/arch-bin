#!/bin/zsh
#[ $UID -eq 0 ] || exit 126
# udev rules allow non-root to edit /sys/class/backlight

for i in /sys/class/backlight/*; do
	file_brightness="$i/brightness"
	file_max="$i/max_brightness"
	setting="${1:-100}"

	if [[ -f "$file_brightness" && "$file_max" && "$setting" -ge 0 && "$setting" -le 100 ]]; then
		set_max=$(cat "$file_max")
		set_new=$(awk -v s=$setting -v m=$set_max 'BEGIN {printf "%d\n", s / 100 * m}')
		echo "$set_new" > "$file_brightness"
	else
		let this_status+=1
	fi
	
done

exit $this_status
