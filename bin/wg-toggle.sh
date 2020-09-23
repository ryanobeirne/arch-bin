#!/usr/bin/env bash

readonly PIGUARD="piguard-dns"
readonly SPOONFLOWER="spoonflower-dns"

check_dev() {
	local dev="$1"
	ip address show "$dev"
}

piguard() {
	local action="$1"
	case "$action" in
		start|stop) systemctl "$action" "wg-quick@$PIGUARD";;
		*) echo "Invalid action: $action" >&2; return 1;;
	esac
}

spoonflower() {
	local action="$1"
	case "$action" in
		start) nmcli con up "$SPOONFLOWER";;
		stop) nmcli con down "$SPOONFLOWER";;
		*) echo "Invalid action: $action" >&2; return 1;;
	esac
}

pick_one() {
	printf '1: %s\n' "$PIGUARD" >&2
	printf '2: %s\n' "$SPOONFLOWER" >&2
	read -rp "Pick one [1|2]: " pick
	case "$pick" in
		1) printf '%s' "$PIGUARD";;
		2) printf '%s' "$SPOONFLOWER";;
		*) echo "Invalid pick: '$pick'" >&2; pick_one;;
	esac
}

start_one() {
	local toggle="$1"
	case "$(pick_one)" in
		"$PIGUARD")
			{ [[ -z "$toggle" ]] || spoonflower stop; } && piguard start;;
		"$SPOONFLOWER")
			{ [[ -z "$toggle" ]] || piguard stop; } && spoonflower start;;
		*) echo "Invalid pick" >&2; return 1;;
	esac
}

pg_status="$(check_dev "$PIGUARD" &>/dev/null; echo $?)"
sf_status="$(check_dev "$SPOONFLOWER" &>/dev/null; echo $?)"

case "${pg_status}${sf_status}" in
	00) echo "Both interfaces are enabled!" >&2; start_one toggle || exit;;
	01) piguard stop && spoonflower start;;
	10) spoonflower stop && piguard start;;
	11) echo "Neither interface is enabled!" >&2; start_one || exit;;
	*) echo "ERROR! $PIGUARD: ${pg_status} - $SPOONFLOWER: ${sf_status}" >&2; exit "$(( pg_status + sf_status ))"
esac
