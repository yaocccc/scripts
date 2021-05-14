#! /bin/bash
# 命令调用脚本

source ~/.profile

sk() {
    case $SCREEN_MODE in
        ONE) killall screenkey || screenkey -p fixed -g 66%x8%+17%-5% & ;;
        COPY) killall screenkey || screenkey -p fixed -g 66%x8%+17%-5% & ;;
        HOME) killall screenkey || screenkey -p fixed -g 50%x8%+25%-11% & ;;
        WORK) killall screenkey || screenkey -p fixed -g 50%x8%+100%-11% & ;;
    esac
}

blurlock() {
    import -window root /tmp/screenshot.png
    convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
    rm /tmp/screenshot.png
    i3lock -i /tmp/screenshotblur.png
}

on_privoxy() {
    ~/scripts/edit-profile.sh http_proxy 127.0.0.1:8118
    ~/scripts/edit-profile.sh https_proxy 127.0.0.1:8118
    /usr/bin/privoxy --no-daemon ~/scripts/config/privoxy.conf >> /dev/null 2>&1 &
    electron-ssr >> /dev/null 2>&1 &
    ~/scripts/dwm-status.sh
    echo privoxy on
}

off_privoxy() {
    ~/scripts/edit-profile.sh http_proxy ''
    ~/scripts/edit-profile.sh https_proxy ''
    killall privoxy &
    kill -9 $(ps -u $USER -o pid,cmd | grep 'electron-ssr' | grep -v 'grep' | awk '{print $1}') &
    ~/scripts/dwm-status.sh
    echo privoxy off
}

toogle_privoxy() {
    [ ! "$http_proxy" ] && on_privoxy || off_privoxy;
}

set_vol() {
    [ "$(bluetoothctl info 64:03:7F:7C:81:15 | grep 'Connected: yes')" ] && OUTPORT=$HEADPHONE || OUTPORT=$SPEAKER
    case $1 in
        up) pactl set-sink-volume $OUTPORT +5% ;;
        down) pactl set-sink-volume $OUTPORT -5% ;;
    esac
    ~/scripts/dwm-status.sh
}

case $1 in
    pcmanfm) pcmanfm ;;
    rofi) rofi -show run ;;
    blurlock) blurlock ;;
    chrome) google-chrome-stable ;;
    music) kill -9 $(ps -u $USER -o pid,comm | grep 'netease-cloud-m' | awk '{print $1}') || netease-cloud-music ;;
    pavucontrol) pavucontrol ;;
    postman) postman ;;
    tim) /opt/apps/com.qq.tim.spark/files/run.sh ;;
    wechat) /opt/apps/com.qq.weixin.spark/files/run.sh ;;
    wxwork) /opt/apps/com.qq.weixin.work.deepin/files/run.sh ;;
    st) st ;;
    flameshot) flameshot gui ;;
    vpn) sudo openfortivpn -c ~/scripts/config/vpn.conf -p $2 ;;
    screenkey) sk ;;
    toogle_privoxy) toogle_privoxy ;;
    on_privoxy) on_privoxy ;;
    off_privoxy) off_privoxy ;;
    ssr) electron-ssr ;;
    set_vol) set_vol $2 ;;
    clock) ~/scripts/lib/st -e tty-clock -csDC 7 & ;;
    surf) /usr/local/bin/surf $2 & ;;
esac
