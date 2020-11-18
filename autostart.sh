#! /bin/bash

sc=work
test "`ip addr show | ag '192.168.2'`" != "" && sc=home
test "`ip addr show | ag '192.168.1'`" != "" && sc=work

~/scripts/dwm-status.sh &
picom --config ~/scripts/config/compton.conf &
xautolock -time 10 -locker blurlock &
nm-applet &
electron-ssr &
xfce4-power-manager &
bluetoothctl power on &
/usr/lib/gsd-xsettings &
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh $sc &
~/scripts/autostart_wait.sh &

sleep 10
xset -b
fcitx &
