#! /bin/bash
# DWM自启动脚本

source ~/.profile

settings() {
    [ $1 ] && sleep $1
    xset s 600
    xset -b
    syndaemon -i 1 -t -K -R -d
    xss-lock -- ~/scripts/blurlock.sh &
    ~/scripts/set_screen.sh two &
    $DWM/statusbar/statusbar.sh cron &
}

daemons() {
    [ $1 ] && sleep $1
    fcitx5 &
    nm-applet &
    flameshot & # 截图要跑一个程序在后台 不然无法将截图保存到剪贴板
    dunst -conf ~/scripts/config/dunst.conf &
    lemonade server &
    picom --experimental-backends --config ~/scripts/config/picom.conf >> /dev/null 2>&1 &
}

every10s() {
    [ $1 ] && sleep $1
    while true
    do
        ~/scripts/set_screen.sh check &
        sleep 10
    done
}

every300s() {
    [ $1 ] && sleep $1
    while true
    do
        # 以下两个有某些情况下会失效 故在定时任务中执行
        # 消除bell声
        # CapsLock to Escape 不过这玩意在启动fcitx或者更换键盘时会失效
        xset -b
        xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
        sleep 300
        feh --randomize --bg-fill ~/Pictures/wallpaper/*.png
    done
}

settings 1 &
daemons 3 &
every10s 5 &
every300s 10 &
