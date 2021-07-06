#! /bin/bash
:<<!
  设置动态壁纸
  one: INNER
  two: OUT - INNER
  check: 检测显示器连接状态是否变化 -> 调用two
!

source ~/.profile

set_wallpaper() {
    killall mpv
    killall xwinwrap
    sleep 0.2
    xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --no-stop-screensaver $1 >> /dev/null 2>&1 &
}

rand=$((RANDOM % 9 + 1))
[ "$1" ] && rand=$1
case $SCREEN_MODE in
    ONE) set_wallpaper ~/Pictures/mp4/$rand/wallpaper_one.mp4;;
    *) set_wallpaper ~/Pictures/mp4/$rand/wallpaper_two.mp4;;
esac
