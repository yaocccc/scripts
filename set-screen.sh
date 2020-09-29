#!/bin/sh

CONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' disconnected ' | awk '{print $1}')

EP_MODE='--mode 2560x1600 --scale 0.5x0.5'
PORT_MODE='--mode 1920x1080 --primary'

HOME_POS1='--pos 0x0 --rotate normal'
HOME_POS2='--pos 1920x500 --rotate normal'
WORK_POS1='--pos 0x400 --rotate normal'
WORK_POS2='--pos 1280x0 --rotate normal'
ONE_POS='--pos 0x0 --rotate normal --primary'

home() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP $EP_MODE $HOME_POS1 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN $PORT_MODE $HOME_POS2;
}

work() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP $EP_MODE $WORK_POS1 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN $PORT_MODE $WORK_POS2;
}

one() {
    xrandr --output eDP $EP_MODE $ONE_POS --output DisplayPort-0 --off --output DisplayPort-1 --off;
}

case $1 in
    home) home ;;
    work) work ;;
    one) one ;;
esac

feh --randomize --bg-fill ~/Pictures/壁纸/*
