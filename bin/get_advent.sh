#!/usr/bin/env bash

readonly DATE=($(date '+%Y %m %e'))
readonly YEAR="$(printf '%d' ${DATE[0]})"
readonly MONTH="$(printf '%d' ${DATE[1]})"
readonly DAY="$(
	if [[ -z "$AOC_DAY" ]]; then
		printf '%d' ${DATE[2]}
	else
		printf '%d' "$AOC_DAY"
	fi
)"

readonly COOKIE="session=53616c7465645f5f59cb8d0d1061ec2f87c74e09df4e2c7f8f1f0ece46a9972f9230c13030aef27facc4f0e930724947"
readonly REPO="/home/ryanobeirne/repos/rust/adventofcode-2021"
readonly INPUT="$(printf '%s/day%02d/input.1.txt'  "$REPO" "$DAY")"

export DISPLAY=:0

[[ "$MONTH" -ne 12 ]] && { printf '%s\n' "It's not December!" >&2; exit 1; }
[[ "$DAY" -gt 25 ]] && { printf '%s\n' "You're too late!" >&2; exit 1; }

espeak -v en-us "It's time to get your code on, bitches" &>/dev/null
xdg-open "https://adventofcode.com/$YEAR/day/$DAY"
curl -Ls --cookie "$COOKIE" "https://adventofcode.com/$YEAR/day/$DAY/input" > "$INPUT"
