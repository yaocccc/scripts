#!/bin/bash

~/scripts/dwm-status.sh &
picom -o 0.95 -i 0.90 --detect-rounded-corners --vsync --blur-background-fixed -f -D 5 -c -b
xautolock -time 10 -locker blurlock &
xset -b &
nm-applet &
electron-ssr &
xfce4-power-manager &
bluetoothctl power on &
/usr/lib/gsd-xsettings &
~/scripts/set-screen.sh work &
~/scripts/set-privoxy.sh on &
~/scripts/autostart_wait.sh &
