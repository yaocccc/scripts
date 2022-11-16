#! /bin/bash

case $1 in
    up) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

$DWM/statusbar/statusbar.sh update vol
