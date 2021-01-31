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
	curl -Ls 'https://v.firebog.net/hosts/csv.txt' |
		sed -E 's/^.*"(.*)","(.*)","(.*)","(.*)","(.*)".*$/\2\t\5/; /^cross/d' |
		cut -f2
}

get_names() {
	local url="$1"
	curl -Ls "$url" |
		sed -E 's/#.*//; s/\s+$//' |
		awk '{print $NF}' |
		sort -u |
		sed -n '/\./p'
}

all_names() {
	local urls=("$@")
	for url in "${urls[@]}"; do
		eprint '%s: ' "$url"
		IFS=$'\n' names=($(get_names "$url"))
		eprint '%s\n' "${#names[@]}"
		[[ -z "$names" ]] && continue
		printf '%s\n' "${names[@]}"
	done | sort -u
}

diff_change() {
	local old="$1"
	local new="$2"
	eprint '%s\n' "Calculating diff..."
	diff  --suppress-common-lines -y "$old" "$new"
}

add_del() {
	local old="$1"
	local new="$2"

	diff_change "$old" "$new" |
		awk '{
			if ($1 == ">") {
				add += 1;
			} else if ($2 == "|") {
				add += 1;
				del += 1;
			} else if ($2 = "<") {
				del += 1;
			}
		}

		END {
			printf "%d\t%d\n", add, del;
		}'
}

touch "$BLOCKLIST" || exit
eprint 'Current blocklist: %s\n' "$(wc -l $BLOCKLIST)"

IFS=$'\n' urls=($(get_urls || cat "$URL_LIST")) || exit
eprint 'Found %s blocklists...\n' "${#urls[@]}"
printf '%s\n' "${urls[@]}" > "$URL_LIST" || exit

IFS=$'\n' names=($(all_names "${urls[@]}")) || exit

add_del="$(add_del "$BLOCKLIST" <(printf '%s\n' "${names[@]}"))"
add="$(cut -f1 <<< "$add_del")"
del="$(cut -f2 <<< "$add_del")"
sum="$(awk -v add="$add" -v del="$del" 'BEGIN {print add - del}')"
eprint 'Found %s names to block [+%s | -%s => %s]...\n' "${#names[@]}" "$add" "$del" "$sum"
printf '%s\n' "${names[@]}" > "$BLOCKLIST" || exit

eprint '%s\n' 'Restarting dnscrypt-proxy...'
systemctl restart dnscrypt-proxy.service
