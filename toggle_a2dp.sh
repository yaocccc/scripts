#!/bin/bash

a2dp=`pactl list | grep Active | grep a2dp`
card=`pactl list | grep "Name: bluez_card." | cut -d ' ' -f 2`

if [ -n "$a2dp" ]; then
    echo "Switching $card to msbc..."
    pactl set-card-profile $card headset-head-unit-msbc
    echo "...done"
else
    echo "Switching $card to a2dp..."
    pactl set-card-profile $card a2dp-sink
    echo "...done"
fi
