#! /bin/bash
# DWM自启动脚本

settings() {
    [ $1 ] && sleep $1
    xset s 600
    xset -b
    syndaemon -i 1 -t -K -R -d
    xss-lock -- ~/scripts/app-starter.sh blurlock &
    ~/scripts/set-screen.sh &
}

daemons() {
    [ $1 ] && sleep $1
    fcitx5 &
    pactl info &
    nm-applet &
    flameshot &
    xfce4-power-manager &
    /usr/lib/gsd-xsettings &
    ~/scripts/wine-notify.sh &
    dunst -conf ~/scripts/config/dunst.conf &
    lemonade server &
    sleep 1 && picom --config ~/scripts/config/compton.conf &
    # sleep 10 && docker restart v2raya # 自启动v2raya翻墙
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

every300s() {
    [ $1 ] && sleep $1
    while true
    do
        BTC=`curl -g 'https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT' | jq -r '.price' | awk '{printf "%d", $1 }'`
        ETH=`curl -g 'https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT' | jq -r '.price' | awk '{printf "%d", $1 }'`
        BNB=`curl -g 'https://api.binance.com/api/v3/ticker/price?symbol=BNBUSDT' | jq -r '.price' | awk '{printf "%d", $1 }'`
        [ "$BTC" -gt 0 ] && ~/scripts/edit-profile.sh BTC $BTC
        [ "$ETH" -gt 0 ] && ~/scripts/edit-profile.sh ETH $ETH
        [ "$BNB" -gt 0 ] && ~/scripts/edit-profile.sh BNB $BNB
        ~/scripts/dwm-status.sh &
        sleep 300
    done
}

every1000s() {
    [ $1 ] && sleep $1
    while true
    do
        source ~/.profile
        xset -b
        xmodmap ~/scripts/config/xmodmap.conf
        fetchmail -k
        notify-send "$(date '+%Y-%m-%d')" "$(curl 'wttr.in/ShangHai?format=3')\n$(curl 'wttr.in/WenZhou?format=3')" &
        mailcount=`ls ~/Mail/inbox/new | wc -w`
        [ "$mailcount" -gt 0 ] && notify-send "📧 NEW MAIL: ${mailcount}" -u low
        sleep 1000
        [ "$WALLPAPER_MODE" = "PIC" ] && ~/scripts/set-wallpaper.sh &
    done
}

settings 1 &
daemons 3 &
every10s 5 &
every300s 30 &
every1000s 30 &
