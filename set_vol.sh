#! /bin/bash

OUTPORT=$(pactl info | grep 'Default Sink' | awk '{print $3}')

case $1 in
    up) pactl set-sink-volume $OUTPORT +5% ;;
    down) pactl set-sink-volume $OUTPORT -5% ;;
esac

$DWM/statusbar/statusbar.sh update vol
