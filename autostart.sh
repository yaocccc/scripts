#! /bin/bash

~/scripts/dwm-status.sh &
picom --config ~/scripts/config/compton.conf &
xautolock -time 10 -locker blurlock &
nm-applet &
electron-ssr &
xfce4-power-manager &
bluetoothctl power on &
/usr/lib/gsd-xsettings &
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh work &

sleep 10
xset -b
fcitx &

while true
do
    sleep 600
    feh --randomize --bg-fill ~/Pictures/*
done
