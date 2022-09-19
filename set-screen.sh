#! /bin/bash
:<<!
  设置屏幕分辨率的脚本
  one: INNER
  two: OUT - INNER
  check: 检测显示器连接状态是否变化 -> 调用two
  toggle_auto: 开启/关闭自动分辨率调整开关
!

INNER_SCREEN=eDP-1
OUT1_SCREEN=DP-1
OUt2_SCREEN=DP-2
CONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' disconnected ' | awk '{print $1}')

_post() {
    ~/scripts/edit-profile.sh SCREEN_MODE $1
    ~/scripts/set-wallpaper.sh
}
two() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output $INNER_SCREEN   --mode 1440x900  --pos 1920x325 --scale 1x1 \
           --output $CONNECT_SCREEN --mode 1920x1080 --pos 0x0      --scale 1x1 --primary \
           --output $DISCONNECT_SCREEN --off
    _post TWO
}
one() {
    xrandr --output $INNER_SCREEN --mode 1440x900 --pos 0x0 --scale 1x1  --primary  \
           --output $OUT1_SCREEN --off \
           --output $OUt2_SCREEN --off
    _post ONE
}
check() {
    source ~/.profile
    [ "$SCREEN_CHECK" = "off" ] && return;
    [ "$CONNECT_SCREEN" ] && [ "$SCREEN_MODE" == "ONE" ] && two;
    [ ! "$CONNECT_SCREEN" ] && [ "$SCREEN_MODE" != "ONE" ] && two;
}
toggle_auto() {
    source ~/.profile
    [ "$SCREEN_CHECK" = "off" ] && ~/scripts/edit-profile.sh SCREEN_CHECK on || ~/scripts/edit-profile.sh SCREEN_CHECK off
}

case $1 in
    one) one ;;
    two) two ;;
    check) check ;;
    toggle_auto) toggle_auto ;;
    *) two ;;
esac
