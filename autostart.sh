#! /bin/bash
# DWM自启动脚本

settings() {
    [ $1 ] && sleep $1

    xset s 600
    xset -b
    syndaemon -i 1 -t -K -R -d
    xss-lock -- ~/scripts/app-starter.sh blurlock &
    ~/scripts/app-starter.sh off_privoxy &
    ~/scripts/set-screen.sh &
}

daemons() {
    [ $1 ] && sleep $1

    fcitx &
    pactl info &
    nm-applet &
    flameshot &
    xfce4-power-manager &
    /usr/lib/gsd-xsettings &
    ~/scripts/wine-notify.sh &
    dunst -conf ~/scripts/config/dunst.conf &
    sleep 1 && picom --config ~/scripts/config/compton.conf &
}

every10s() {
    [ $1 ] && sleep $1

    while true
    do
        ~/scripts/set-screen.sh check &
        ~/scripts/dwm-status.sh &
        sleep 10
    done
}

every1000s() {
    [ $1 ] && sleep $1

    while true
    do
        xmodmap ~/scripts/config/xmodmap.conf
        weather=`curl -sf 'wttr.in/ShangHai?format=1' | sed 's/ \|+//g'`
        [ ! $weather ] || [ ${#weather} -ge 20 ] && weather="🌈"
        ~/scripts/edit-profile.sh weather "$weather"

        sleep 1000

        xset -b
        feh --randomize --bg-fill ~/Pictures/*.png &
    done
}

settings 1 &
daemons 3 &
every10s 5 &
every1000s 30 &
