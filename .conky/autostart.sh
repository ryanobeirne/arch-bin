#!/usr/bin/env bash

xhost +local:

killall conky

sleep 10

conky -c ~/.conky/horical.conkyrc --daemonize
conky -c ~/.conky/conkyrc --daemonize
#conky -c ~/.conky/battery.conkyrc --daemonize
