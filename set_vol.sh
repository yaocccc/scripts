#! /bin/bash

sink=$(pactl info | grep 'Default Sink' | awk '{print $3}')
vol=$(pactl list sinks | grep $sink -A 7 | sed -n '8p' | awk '{printf int($5)}')
mod=$((vol % 5))

case $1 in
    up) pactl set-sink-volume @DEFAULT_SINK@ +$((5 - mod))% ;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -$((5 - mod))% ;;
esac

notify-send -r 9527 Volume "$($DWM/statusbar/statusbar.sh update vol)" -i audio-volume-medium
