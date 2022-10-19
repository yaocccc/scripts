#! /bin/bash

CONNECTED_MONITORS=$(xrandr --listmonitors | sed 1d | awk '{print $4}' | wc -l)
case $CONNECTED_MONITORS in
    1) killall screenkey || screenkey -p fixed -g 66%x8%+17%-5% & ;;
    2) killall screenkey || screenkey -p fixed -g 50%x8%+25%-11% & ;;
esac
