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
    i3lock \
    --blur 5 \
    --bar-indicator \
    --bar-pos y+h \
    --bar-direction 1 \
    --bar-max-height 50 \
    --bar-base-width 50 \
    --bar-color 00000022 \
    --keyhl-color ffffffcc \
    --bar-periodic-step 50 \
    --bar-step 20 \
    --redraw-thread \
    --clock \
    --force-clock \
    --time-pos x+5:y+h-80 \
    --time-color ffffffff \
    --date-pos tx:ty+15 \
    --date-color ffffffff \
    --date-align 1 \
    --time-align 1 \
    --ringver-color ffffff00 \
    --ringwrong-color ffffff88 \
    --status-pos x+5:y+h-16 \
    --verif-align 1 \
    --wrong-align 1 \
    --verif-color ffffffff \
    --wrong-color ffffffff \
    --modif-pos -50:-50
    xdotool mousemove_relative 1 1 # 该命令用于解决自动锁屏后未展示锁屏界面的问题(移动一下鼠标)
}

set_vol() {
    OUTPORT=$SPEAKER
    [ "$(pactl list sinks | grep $HEADPHONE_A2DP)" ] && OUTPORT=$HEADPHONE_A2DP
    [ "$(pactl list sinks | grep $HEADPHONE_HSP_HFP)" ] && OUTPORT=$HEADPHONE_HSP_HFP
    [ "$(pactl list sinks | grep $HEADPHONE_A2DP_SONY)" ] && OUTPORT=$HEADPHONE_A2DP_SONY
    [ "$(pactl list sinks | grep $HEADPHONE_HSP_HFP_SONY)" ] && OUTPORT=$HEADPHONE_HSP_HFP_SONY
    [ "$(pactl list sinks | grep $VOICEBOX)" ] && OUTPORT=$VOICEBOX
    pactl list sinks

    echo $VOICEBOX
    echo $OUTPORT

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
    # 单位x = 9, 单位y = 18
    uw=8; uh=17
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    position=$1; c=$2; l=$3
    if [ "$mx" -lt 1920 ]; then
        wx=0; wy=0; ww=1920; wh=1080
        if [ "$SCREEN_MODE" = "ONE" ]; then
            ww=1440; wh=900
        fi
    else
        wx=1920; wy=325; ww=1440; wh=900
    fi

    case $position in
        top_left)
            x=$(( $wx + 12 ))
            y=$(( $wy + 38 ))
            ;;
        top_right)
            x=$(( $wx + $ww - 12 - $c * $uw ))
            y=$(( $wy + 38 ))
            ;;
        center)
            x=$(( $wx + $ww / 2 - $c * $uw / 2 ))
            y=$(( $wy + $wh / 2 - $l * $uh / 2 + 12 ))
            ;;
    esac
    echo $c\x$l+$x+$y
}

case $1 in
    killw) kill -9 $(xprop | grep "_NET_WM_PID(CARDINAL)" | awk '{print $3}') ;;
    filemanager) pcmanfm ;;
    rofi) rofi -show run ;;
    rofi_window) rofi -show window -show-icons ;;
    rofi_p) rofi -show menu -modi "menu:~/scripts/rofi.sh" && sleep 1 && ~/scripts/dwm-status.sh ;;
    blurlock) blurlock ;;
    chrome) google-chrome-stable ;;
    qqmusic) kill -9 $(ps -u $USER -o pid,comm | grep 'qqmusic' | awk '{print $1}') || qqmusic ;;
    music)
        close_music || (mpd; ~/scripts/lib/st -g $(st_geometry top_right 50 10) -t music -c music -e 'ncmpcpp')
        # lx-music-desktop -dt >> /dev/null 2>&1 &
        ;;
    bili)
        ~/scripts/lib/bili_tui -c ~/.config/bili.toml
        ;;
    pavucontrol) pavucontrol ;;
    postman) postman ;;
    tim)
        # sudo -S sysctl -w net.ipv6.conf.all.disable_ipv6=1
        # /opt/apps/com.qq.tim.spark/files/run.sh
        ~/workspace/Icalingua-plus-plus/icalingua/build/linux-unpacked/icalingua
        ;;
    wechat) /opt/apps/com.qq.weixin.deepin/files/run.sh ;;
    wxwork) /opt/apps/com.qq.weixin.work.deepin/files/run.sh ;;
    st) st ;;
    flameshot) flameshot gui -c -p ~/Pictures/screenshots ;;
    open_last_screenshot) eog ~/Pictures/screenshots/$(ls -t ~/Pictures/screenshots | sed '2,9999d') >> /dev/null 2>&1 & ;;
    screenkey) sk ;;
    ssr) electron-ssr ;;
    set_vol) set_vol $2 ;;
    toggle_hp_sink) toggle_hp_sink ;;
    surf) /usr/local/bin/surf $2 >> /dev/null 2>&1 & ;;
    fst) /usr/local/bin/st -c float -g $(st_geometry center 100 30) ;;
    telegram) telegram-desktop ;;
    robot) kill -9 $(ps -u $USER -o pid,comm | grep 'robot' | awk '{print $1}') || ~/workspace/robotjs/bin/robot $2 > ~/log ;;
    gologin) ~/scripts/lib/gologin >> /dev/null 2>&1 & ;;
    picom) picom --experimental-backends --config ~/scripts/config/picom.conf >> /dev/null 2>&1 & ;;
    easyeffects) easyeffects --gapplication-service >> /dev/null 2>&1 & ;;
    aria2c) aria2c >> /dev/null 2>&1 & ;;
    # vmwave)
    #     sudo systemctl start vmware-networks.service vmware-usbarbitrator.service
    #     sudo modprobe -a vmw_vmci vmmon
    #     sudo vmware >> /dev/null 2>&1 & 
    #     ;;
esac
