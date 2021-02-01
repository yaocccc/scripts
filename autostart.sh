#! /bin/bash

picom --config ~/scripts/config/compton.conf &
xautolock -time 10 -locker blurlock &
nm-applet &
flameshot &
xfce4-power-manager &
bluetoothctl power on &
/usr/lib/gsd-xsettings &
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh &
~/scripts/check-screen.sh &
~/scripts/dwm-status.sh &
# electron-ssr &

sleep 10
xset -b
fcitx &
syndaemon -i 1 -t -K -R -d

while true
do
    sleep 600
    feh --randomize --bg-fill ~/Pictures/*
done
