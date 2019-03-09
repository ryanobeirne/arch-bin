#!/usr/bin/env bash

# Returns percentage rounded to nearest integer
bat_percent() {
	local full="$1" now="$2"
	awk -v F=$full -v N=$now 'BEGIN {
		printf "%0.0f\n", N/F*100
	}'
}

# Returns a TUI bar of a given width ███████░░░░░
print_bar() {
	local p=$1 width=${2:-$(tput cols 2>/dev/null || 80)} s=0
	local bar_width=$width

	local hash_width=$(awk -v P=$p -v BW=$bar_width 'BEGIN {
		printf "%0.0f", P / 100 * BW
	}')

	while [[ $s -lt $bar_width ]]; do
		[[ $s -lt $hash_width ]] && printf '█' || printf '░'
		let s+=1
	done

	printf '\n'
}

# Returns a fat battery bar:
# ███████░░░░░
# ███████░░░░░░
# ███████░░░░░
big_bar() {
	local bar="$1"
	local p="$2"

	if [[ "$p" -eq 100 ]]; then
		local tip=█
	else
		local tip=░
	fi

	for line in {1..5}; do
		printf '%s' "$bar"
		[[ "$line" -eq 3 ]] && printf '%s %d%%\n' "$tip" "$p" || printf '\n'
	done
}

# Pretty prints battery name, percentage, and status
# BAT0: 29% Charging
print_batt() {
	local name="$1" percent="$2" status="$3"
	printf '%s: %d%% %s\n' "$name" "$percent" "$status"
}

# Main function for a given battery at /sys/class/power_supply/
main() {
	local battery="$1" big="$2"
	source "$battery/uevent"
	local percent=$(bat_percent "$POWER_SUPPLY_CHARGE_FULL" "$POWER_SUPPLY_CHARGE_NOW")

	if [[ -n "$big" ]]; then
		bar=$(print_bar "$percent" 20)
		big_bar "$bar" "$percent"
	else
		print_batt "$POWER_SUPPLY_NAME" "$percent" "$POWER_SUPPLY_STATUS"
		print_bar "$percent" #80
	fi
}

for battery in /sys/class/power_supply/BAT*; do
	main "$battery" "$1"
done
