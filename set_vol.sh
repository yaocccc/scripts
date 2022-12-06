#! /bin/bash

case $1 in
    up) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

notify-send -r 9527 Volume "$($DWM/statusbar/statusbar.sh update vol)" -i audio-volume-medium
