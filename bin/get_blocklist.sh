#!/usr/bin/env bash

readonly URL_LIST="/etc/dnscrypt-proxy/firebog-urls.txt"
readonly BLOCKLIST="/etc/dnscrypt-proxy/firebog.txt"

eprint() {
	local fmt="${1:-'%s\n'}"
	shift
	local msg=("$@")
	printf "$fmt" "${msg[@]}" >&2
}

[[ "$UID" -eq 0 ]] || { eprint 'User must be root!\n'; exit 1; }

get_urls() {
	curl -Ls https://firebog.net | grep 'class="bdTick".*https:' | sed -E 's/^.*"(https:.*)".*/\1/'
}

get_names() {
	local urls=($@)
	curl -Ls ${urls[@]} |
		sed -E 's/#.*//; s/\s+$//' |
		awk '{print $NF}' |
		sort -u |
		sed '/^localhost$/d'
}

IFS=$'\n' urls=($(get_urls)) || exit
eprint 'Found %s blocklists...\n' "${#urls[@]}"
printf '%s\n' "${urls[@]}" > "$URL_LIST" || exit

IFS=$'\n' names=($(get_names "${urls[@]}")) || exit
eprint 'Found %s names to block...\n' "${#names[@]}"
printf '%s\n' "${names[@]}" > "$BLOCKLIST" || exit

eprint '%s\n' 'Restarting dnscrypt-proxy...'
systemctl restart dnscrypt-proxy.service
