#!/bin/sh

CONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' disconnected ' | awk '{print $1}')

home() { xrandr --output eDP --mode 1440x900 --pos 1920x325 --rotate normal --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 0x0 --rotate normal; }
work() { xrandr --output eDP --mode 1440x900 --pos 0x525 --rotate normal --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 1440x0 --rotate normal; }
one() { xrandr --output eDP --primary --mode 1440x900 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off; }

case $1 in
    home) 
        if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
        home
        ;;
    work)
        if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
        work
        ;;
    one) one ;;
    *) one ;;
esac

feh --randomize --bg-fill ~/Pictures/壁纸/*
