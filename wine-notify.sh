#! /bin/bash

a=0
dbus-monitor "interface='org.freedesktop.DBus',member='RequestName'" | while read
do
    a=$(($a+1))
    a=$(($a%3))
    test $a = 0 && notify-send "💬 $(date)" "有未读消息"
done
