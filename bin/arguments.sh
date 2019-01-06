#!/bin/bash

arguments=("$0" "$@")

for arg in "${!arguments[@]}"; do
	echo "\$$arg: ${arguments[$arg]}"
done
