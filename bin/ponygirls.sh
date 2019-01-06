#!/usr/bin/env bash

names=(Lily Lilah Olivia Mommy Daddy Gramzi Poppy Stephanie)

pony() {
	while :; do
		name="${1:-${names[$(( $RANDOM % ${#names[@]} ))]}}"
		quote="I love $name."
		ponysay "$quote"
		espeak -v english-us "$quote" 2>/dev/null
		sleep 2
	done
}

pony "$@"
