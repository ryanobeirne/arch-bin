#!/usr/bin/env bash

# Gets all the battery variables
source /sys/class/power_supply/BAT0/uevent

# Returns percentage rounded to nearest integer
bat_percent() {
	printf '%d' "$POWER_SUPPLY_CAPACITY"
}

# Decides which charging icon to use
charge_icon() {
	case "$POWER_SUPPLY_STATUS" in
		"Charging") printf '🔌' ;;
		"Discharging") printf ' ' ;;
		*) printf '?' ;;
	esac
}

#                0 1 2 3 4 5 6 7 8 9 10 11)
readonly ICONS=(              )

bat_icon() {
    local bp="$1"
    case "$bp" in
        [0-9] ) printf '%s' "${ICONS[0]}";;
        1[0-9]) printf '%s' "${ICONS[1]}";;
        2[0-9]) printf '%s' "${ICONS[2]}";;
        3[0-9]) printf '%s' "${ICONS[3]}";;
        4[0-9]) printf '%s' "${ICONS[4]}";;
        5[0-9]) printf '%s' "${ICONS[5]}";;
        6[0-9]) printf '%s' "${ICONS[6]}";;
        7[0-9]) printf '%s' "${ICONS[7]}";;
        8[0-9]) printf '%s' "${ICONS[8]}";;
        9[0-9]) printf '%s' "${ICONS[9]}";;
        100   ) printf '%s' "${ICONS[10]}";;
        *     ) printf '%s' "${ICONS[11]}";;
    esac
}

bp=$(bat_percent)
icon=$(bat_icon "$bp")

printf '%s%s%s%%' "$icon" "$(charge_icon)" "$bp"

