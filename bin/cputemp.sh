#!/usr/bin/env bash

temp="$(awk '{sum+=$1;if ($1==0){zeros+=1;}} END {printf "%0.1f", sum / (NR-zeros) / 1000}' /sys/class/hwmon/hwmon*/temp*_input)"

printf '%s°C\n' "$temp"
