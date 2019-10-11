#!/usr/bin/env bash

# tail a the pihole log and colorize the output
# blocked DNS queries are highligted in red

readonly LOGFILE="/run/log/pihole/pihole.log"
readonly BLOCKED='is 0.0.0.0$'
readonly QUERY='query\[.*\]'
readonly FORWARDED=' forwarded '
readonly REPLY=' reply '
readonly CACHED_CNAME='cached.* <CNAME>$'
readonly REPLY_CNAME='reply.* <CNAME>$'
readonly CACHED=' cached '

# Check if a line contains a term
grep_test() {
	local term="$1" line="$2"
	echo "$line" | grep "$term" >/dev/null
}

# Print ANSI escape sequences
colorize() {
	local color="$1"
	local face="$2"

	# Reset
	printf '\e[0m'

	case "$face" in
		bold      ) printf '\e[1m';;
		dim       ) printf '\e[2m';;
		italic    ) printf '\e[3m';;
		underline ) printf '\e[4m';;
		reset     ) printf '\e[0m';;
	esac

	case "$color" in
		red    ) printf '\e[31m';;
		green  ) printf '\e[32m';;
		yellow ) printf '\e[33m';;
		blue   ) printf '\e[34m';;
		magenta) printf '\e[35m';;
		cyan   ) printf '\e[36m';;
		white  ) printf '\e[37m';;
		black  ) printf '\e[38m';;
		reset  ) printf '\e[0m';;
		*      ) printf '\e[0m';;
	esac
}

# Reset the color to normal mode
uncolorize() {
	colorize reset
}

# Format the line
print_log_line() {
	local line="$1"
	## Additional formatting
	#echo "$line" | while read month day time pid type url prep ip tail; do
		#printf '%3s %2s %8s %s ' "$month" "$day" "$time" "$pid"
		#printf '%s %s %s %s\n' "$type" "$url" "$prep" "$ip"
	#done
	printf '%s\n' "$line"
}

# Colirze the line based on its contents
color_line() {
	local line="$1"

	if grep_test "$BLOCKED" "$line"; then
		colorize red bold
	elif grep_test "$QUERY" "$line"; then
		colorize yellow italic
	elif grep_test "$CACHED_CNAME" "$line"; then
		colorize green italic
	elif grep_test "$REPLY_CNAME" "$line"; then
		colorize bold italic
	elif grep_test "$REPLY" "$line"; then
		colorize green bold
	elif grep_test "$CACHED" "$line"; then
		colorize green
	elif grep_test "$FORWARDED" "$line"; then
		colorize blue
	else
		uncolorize
	fi
}

# Tail the log and format the output
main() {
	tail -f "$LOGFILE" | while read -r line; do
		color_line "$line"
		print_log_line "$line"
	done
}

# Do the thing
main
