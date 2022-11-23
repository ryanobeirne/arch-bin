#!/usr/bin/env bash

sleep 10

conky -c ~/.conky/horical.conkyrc --daemonize
conky -c ~/.conky/conkyrc --daemonize
#conky -c ~/.conky/battery.conkyrc --daemonize
