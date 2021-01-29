#! /bin/bash

~/scripts/dwm-status.sh &
picom --config ~/scripts/config/compton.conf &
xautolock -time 10 -locker blurlock &
nm-applet &
xfce4-power-manager &
bluetoothctl power on &
/usr/lib/gsd-xsettings &
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh &
~/scripts/check-screen.sh &
# electron-ssr &

sleep 10
xset -b
fcitx &

while true
do
    sleep 600
    feh --randomize --bg-fill ~/Pictures/*
done
