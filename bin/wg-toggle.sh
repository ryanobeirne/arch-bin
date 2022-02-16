#!/usr/bin/env bash

trap "exit 130" TERM INT

readonly PIGUARD="piguard-dns"
readonly SPOONFLOWER="tricenter"

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
		start | stop) systemctl  "$action" "wg-quick@$SPOONFLOWER";;
		*) echo "Invalid action: $action" >&2; return 1;;
	esac
}

pick_one() {
	#printf '1: %s\n' "$PIGUARD" >&2
	#printf '2: %s\n' "$SPOONFLOWER" >&2
	#read -rp "Pick one [1|2]: " pick
	#case "$pick" in
		#1) printf '%s' "$PIGUARD";;
		#2) printf '%s' "$SPOONFLOWER";;
		#*) echo "Invalid pick: '$pick'" >&2; pick_one;;
	#esac
	kdialog --menu "Pick a WireGuard tunnel:" \
		"$PIGUARD" "$PIGUARD" \
		"$SPOONFLOWER" "$SPOONFLOWER"
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

# pg_status="$(check_dev "$PIGUARD" &>/dev/null; echo $?)"
sf_status="$(check_dev "$SPOONFLOWER" &>/dev/null; echo $?)"

case "${sf_status}" in
	# 00) echo "Both interfaces are enabled!" >&2; start_one toggle || exit;;
	# 01) piguard stop && spoonflower start;;
	0) spoonflower stop;;
	1) spoonflower start;;
	*) echo "ERROR! - $SPOONFLOWER: ${sf_status}" >&2; exit "$(( sf_status ))"
esac
