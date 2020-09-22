#!/bin/sh

case $1 in
    home) xrandr --output eDP --mode 1440x900 --pos 1920x325 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal ;;
    work) xrandr --output eDP --mode 1440x900 --pos 0x525 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --primary --mode 1920x1080 --pos 1440x0 --rotate normal ;;
    one) xrandr --output eDP --primary --mode 1440x900 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off ;;
esac

feh --randomize --bg-fill ~/Pictures/壁纸/*
