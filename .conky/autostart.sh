#!/usr/bin/env bash

conky -c ~/.conky/horical.conkyrc --daemonize
conky -c ~/.conky/conkyrc --daemonize --pause=5
conky -c ~/.conky/battery.conkyrc --daemonize
