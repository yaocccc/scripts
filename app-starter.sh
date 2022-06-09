#! /bin/bash
# 命令调用脚本

source ~/.profile

sk() {
    case $SCREEN_MODE in
        ONE) killall screenkey || screenkey -p fixed -g 66%x8%+17%-5% & ;;
        TWO) killall screenkey || screenkey -p fixed -g 50%x8%+25%-11% & ;;
    esac
}

blurlock() {
    import -window root /tmp/screenshot.png
    convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
    rm /tmp/screenshot.png
    i3lock -i /tmp/screenshotblur.png
}

set_vol() {
    OUTPORT=$SPEAKER
    [ "$(pactl list sinks | grep $HEADPHONE_A2DP)" ] && OUTPORT=$HEADPHONE_A2DP
    [ "$(pactl list sinks | grep $HEADPHONE_HSP_HFP)" ] && OUTPORT=$HEADPHONE_HSP_HFP
    [ "$(pactl list sinks | grep $HEADPHONE_A2DP_SONY)" ] && OUTPORT=$HEADPHONE_A2DP_SONY
    [ "$(pactl list sinks | grep $HEADPHONE_HSP_HFP_SONY)" ] && OUTPORT=$HEADPHONE_HSP_HFP_SONY
    [ "$(pactl list sinks | grep $VOICEBOX)" ] && OUTPORT=$VOICEBOX

    case $1 in
        up) pactl set-sink-volume $OUTPORT +5% ;;
        down) pactl set-sink-volume $OUTPORT -5% ;;
    esac
    ~/scripts/dwm-status.sh
}

toggle_hp_sink() {
    a2dp=`pactl list | grep Active | grep a2dp`
    card=`pactl list | grep "Name: bluez_card." | cut -d ' ' -f 2`
    [ ! "$card" ] && exit 0
    [ -n "$a2dp" ] && pactl set-card-profile $card headset-head-unit-msbc || pactl set-card-profile $card a2dp-sink
    [ -n "$a2dp" ] && notify-send "$card to headset-head-unit-msbc" || notify-send "$card to a2dp-sink"
}

close_music() {
    ncmpcpp_pid=`ps -u $USER -o pid,comm | grep 'ncmpcpp' | awk '{print $1}'`
    mpd_pid=`ps -u $USER -o pid,comm | grep 'mpd' | awk '{print $1}'`
    killed=1
    if [ "$ncmpcpp_pid" ]; then
        kill -9 $ncmpcpp_pid
        killed=0
    fi
    if [ "$mpd_pid" ]; then
        kill -9 $mpd_pid
        killed=0
    fi
    return $killed
}

st_geometry() {
    # 单位x = 8, 单位y = 16
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    position=$1; c=$2; l=$3
    if [ "$mx" -lt 1920 ]; then
        wx=0; wy=0; ww=1920; wh=1080
    else
        wx=1920; wy=325; ww=1440; wh=900
    fi

    case $position in
        top_left)
            x=$(( $wx + 5 ))
            y=$(( $wy + 30 ))
            ;;
        top_right)
            x=$(( $wx + $ww - 5 - $c * 8 ))
            y=$(( $wy + 30 ))
            ;;
        center)
            x=$(( $wx + $ww / 2 - $c * 4 ))
            y=$(( $wy + $wh / 2 - $l * 8 ))
            ;;
    esac
    echo $c\x$l+$x+$y
}

case $1 in
    filemanager) pcmanfm ;;
    rofi) rofi -show run ;;
    blurlock) blurlock ;;
    chrome) google-chrome-stable ;;
    qqmusic) kill -9 $(ps -u $USER -o pid,comm | grep 'qqmusic' | awk '{print $1}') || qqmusic ;;
    music) close_music || (mpd; ~/scripts/lib/st -g $(st_geometry top_right 50 10) -t music -c music -e 'ncmpcpp') ;;
    pavucontrol) pavucontrol ;;
    postman) postman ;;
    tim)
        sudo -S sysctl -w net.ipv6.conf.all.disable_ipv6=1
        /opt/apps/com.qq.tim.spark/files/run.sh
        ;;
    wechat) /opt/apps/com.qq.weixin.deepin/files/run.sh ;;
    wxwork) /opt/apps/com.qq.weixin.work.deepin/files/run.sh ;;
    st) st ;;
    flameshot) flameshot gui ;;
    vpn) sudo openfortivpn -c ~/.ssh/vpn.conf -p $2 ;;
    vpn2) sudo openfortivpn -c ~/.ssh/vpn2.conf -p Yumc\#3122$2 ;;
    screenkey) sk ;;
    ssr) electron-ssr ;;
    set_vol) set_vol $2 ;;
    toggle_hp_sink) toggle_hp_sink ;;
    surf) /usr/local/bin/surf $2 >> /dev/null 2>&1 & ;;
    fst) /usr/local/bin/st -c float -g $(st_geometry center 100 30) ;;
    telegram) telegram-desktop ;;
    allb)
        sleep 0 && google-chrome-stable >> /dev/null 2>&1 &
        sleep 1 && chromium >> /dev/null 2>&1 &
        sleep 2 && firefox >> /dev/null 2>&1 &
        sleep 3 && microsoft-edge-stable >> /dev/null 2>&1 &
        ;;
    robot) kill -9 $(ps -u $USER -o pid,comm | grep 'robot' | awk '{print $1}') || ~/workspace/robotjs/bin/robot > ~/log ;;
    gologin) ~/scripts/lib/gologin $2 >> /dev/null 2>&1 & ;;
    weather) notify-send "$(date '+%Y-%m-%d')" "$(curl 'wttr.in/ShangHai?format=3')\n$(curl 'wttr.in/WenZhou?format=3')" >> /dev/null 2>&1 & ;;
    picom) picom --config ~/scripts/config/compton.conf $2 >> /dev/null 2>&1 & ;;
esac
