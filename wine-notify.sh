#! /bin/bash

dbus-monitor "interface='org.freedesktop.DBus',member='RequestName'" | while read line
do
    [ "$line grep 'org.freedesktop.ReserveDevice1.Audio1'" ] && notify-send "💬 NEW MESSAGE" -u low
done
