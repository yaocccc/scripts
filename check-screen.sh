#! /bin/bash

S=$(xrandr | grep DisplayPort | grep ' disconnected ')
PRE=$S

while true
do
    sleep 5
    S=$(xrandr | grep DisplayPort | grep ' disconnected ')
    if [ "$PRE" != "$S" ]; then
        PRE=$S
        ~/scripts/set-screen.sh &
    fi
done
