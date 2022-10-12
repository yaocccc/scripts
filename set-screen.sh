#! /bin/bash
:<<!
  设置屏幕分辨率的脚本
  one: INNER
  two: OUT - INNER
  check: 检测显示器连接状态是否变化 -> 调用two
!

INNER_SCREEN=eDP
OUT1_SCREEN=DisplayPort-0
OUt2_SCREEN=DisplayPort-1

CONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' disconnected ' | awk '{print $1}')

_post() {
    ~/scripts/edit-profile.sh SCREEN_MODE $1
    ~/scripts/set-wallpaper.sh
}
two() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    IS_2K=$(xrandr | grep '2560x1440')
    [ "$IS_2K" ] && \
        xrandr --output $INNER_SCREEN   --mode 2560x1600 --pos 2560x450 --scale 0.5625x0.5625 \
               --output $CONNECT_SCREEN --mode 2560x1440 --pos 0x0      --scale 0.85x0.85 --primary \
               --output $DISCONNECT_SCREEN --off

    [ ! "$IS_2K" ] && \
        xrandr --output $INNER_SCREEN   --mode 1440x900  --pos 1920x320 --scale 1x1 \
               --output $CONNECT_SCREEN --mode 1920x1080 --pos 0x0      --scale 1x1 --primary \
               --output $DISCONNECT_SCREEN --off
    _post TWO
}
one() {
    xrandr --output $INNER_SCREEN --mode 2560x1600 --pos 0x0 --scale 0.5625x0.5625 --primary  \
           --output $OUT1_SCREEN --off \
           --output $OUt2_SCREEN --off
    _post ONE
}
check() {
    source ~/.profile
    [ "$CONNECT_SCREEN" ] && [ "$SCREEN_MODE" == "ONE" ] && two;
    [ ! "$CONNECT_SCREEN" ] && [ "$SCREEN_MODE" != "ONE" ] && two;
}

case $1 in
    one) one ;;
    two) two ;;
    check) check ;;
    *) two ;;
esac
