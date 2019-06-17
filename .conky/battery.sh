#!/usr/bin/env bash

#charge_now=$(cat /sys/class/power_supply/BAT0/charge_now)
#charge_full=$(cat /sys/class/power_supply/BAT0/charge_full)

#charge_percent=$(awk -v n=$charge_now -v f=$charge_full 'BEGIN {printf "%0.0f", n / f * 100}')

#printf '%s\n' "$charge_percent"

cat /sys/class/power_supply/BAT0/capacity
