#!/usr/bin/env bash
# Returns percentage rounded to nearest integer
bat_percent() {
	cat /sys/class/power_supply/BAT0/capacity
}

#                0 1 2 3 4 5 6 7 8 9 10 11)
readonly ICONS=(              )

get_icon() {
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

icon=$(get_icon "$bp")

printf '%s %s%%' "$icon" "$bp"

