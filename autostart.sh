#! /bin/bash
# DWM自启动脚本

settings() {
    xset s 600
    syndaemon -i 1 -t -K -R -d
    xss-lock -- ~/scripts/app-starter.sh blurlock &
    ~/scripts/app-starter.sh off_privoxy &
    sleep 1 && ~/scripts/set-screen.sh &
}

daemons() {
    fcitx &
    pactl info &
    nm-applet &
    flameshot &
    xfce4-power-manager &
    /usr/lib/gsd-xsettings &
    ~/scripts/wine-notify.sh &
    dunst -conf ~/scripts/config/dunst.conf &

    sleep 1
    picom --config ~/scripts/config/compton.conf &
}

every10s() {
    while true
    do
        ~/scripts/set-screen.sh check &
        ~/scripts/dwm-status.sh &
        sleep 10
    done
}

every1000s() {
    while true
    do
        xset -b
        xmodmap ~/scripts/config/xmodmap.conf
        feh --randomize --bg-fill ~/Pictures/* &
        weather=`curl -sf 'wttr.in/ShangHai?format=1' | sed 's/ \|+//g'`
        [ ${#weather} -ge 10 ] && weather="🌈" && ~/scripts/edit-profile.sh weather "$weather"
        sleep 1000
    done
}

settings &
daemons &
every10s &
every1000s &
