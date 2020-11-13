#! /bin/bash

~/scripts/dwm-status.sh &
picom -o 0.95 -i 0.90 -b
xautolock -time 10 -locker blurlock &
nm-applet &
electron-ssr &
xfce4-power-manager &
bluetoothctl power on &
/usr/lib/gsd-xsettings &
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh work &
~/scripts/autostart_wait.sh &
