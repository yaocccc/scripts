#! /bin/bash

source ~/.profile

OUTPORT=$SPEAKER
[ "$(pactl list sinks | grep $HEADPHONE_HSP_HFP)" ] && OUTPORT=$HEADPHONE_HSP_HFP
[ "$(pactl list sinks | grep $HEADPHONE_HSP_HFP_SONY)" ] && OUTPORT=$HEADPHONE_HSP_HFP_SONY
pactl list sinks

case $1 in
    up) pactl set-sink-volume $OUTPORT +5% ;;
    down) pactl set-sink-volume $OUTPORT -5% ;;
esac

$DWM/statusbar/statusbar.sh update vol
