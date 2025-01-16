#! /bin/bash
:<<!
  设置屏幕分辨率的脚本(xrandr命令的封装)
  one: 只展示一个内置屏幕 2560x1600 缩放为 1440x900
  two: 左边展示外接屏幕 - 右边展示内置屏幕 都用匹配1080p屏幕DPI的缩放比
  check: 检测显示器连接状态是否变化 变化则自动调整输出情况
!

INNER_PORT=eDP-1
_MODE=THREE
MODE=$_MODE
# [ "$(xrandr | grep '3840x2160')" ] && MODE=H$_MODE
# [ "$(xrandr | grep '3440x1440')" ] && MODE=L$_MODE

__setbg() {
    feh --randomize --bg-fill ~/Pictures/wallpaper/*.png
}

__get_inner_view() {
    case "$MODE" in
        ONE) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 0x0" ;;
        LR) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 1920x320" ;;
        TB) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 500x1080" ;;
        HLR) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 1920x320" ;;
        HTB) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 500x1080" ;;
        LLR) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 2560x320" ;;
        LTB) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 500x1080" ;;
        THREE) echo "--output $INNER_PORT --mode 2880x1800 --scale 0.5x0.5 --pos 3640x780" ;;
    esac
}

__get_outer_view() {
    outport=$1
    outport2=$2
    case "$MODE" in
        LR) echo "--output $outport --mode 1920x1080 --scale 0.9999x0.9999 --pos 0x0 --primary" ;;
        TB) echo "--output $outport --mode 1920x1080 --scale 0.9999x0.9999 --pos 0x0 --primary" ;;
        HLR) echo "--output $outport --mode 3840x2160 --scale 0.5x0.5 --pos 0x0 --primary" ;;
        HTB) echo "--output $outport --mode 3840x2160 --scale 0.5x0.5 --pos 0x0 --primary" ;;
        LLR) echo "--output $outport --mode 2560x1080 --scale 0.9999x0.9999 --pos 0x0 --primary" ;;
        LTB) echo "--output $outport --mode 2560x1080 --scale 0.9999x0.9999 --pos 0x0 --primary" ;;
        THREE) echo "--output $outport --mode 1920x1080 --scale 0.9999x0.9999 --rotate left --pos 0x0 --output $outport2 --mode 2560x1080 --scale 0.9999x0.9999 --pos 1080x300 --primary" ;;
    esac
}

__get_off_views() {
    for sc in $(xrandr | grep 'connected' | awk '{print $1}'); do echo "--output $sc --off "; done
}

one() {
    MODE=ONE
    xrandr $(__get_off_views) $(__get_inner_view)
    __setbg
}

two() {
    OUTPORT_CONNECTED=$(xrandr | grep -v $INNER_PORT | grep -w 'connected' | awk '{print $1}')
    [ ! "$OUTPORT_CONNECTED" ] && one && return

    xrandr $(__get_off_views) $(__get_inner_view) $(__get_outer_view $OUTPORT_CONNECTED)
    __setbg
}

three() {
    HDMI_OUTPUT=$(xrandr | grep -v $INNER_PORT | grep -w 'connected' | grep HDMI | awk '{print $1}')
    DP_OUTPUT=$(xrandr | grep -v $INNER_PORT | grep -w 'connected' | grep DP | awk '{print $1}')

    [ ! "$HDMI_OUTPUT" ] && one && return

    xrandr $(__get_off_views) $(__get_inner_view) $(__get_outer_view $DP_OUTPUT $HDMI_OUTPUT)
    __setbg
}

check() {
    CONNECTED_PORTS=$(xrandr | grep -w 'connected' | awk '{print $1}' | wc -l)
    CONNECTED_MONITORS=$(xrandr --listmonitors | sed 1d | awk '{print $4}' | wc -l)
    [ $CONNECTED_PORTS -eq $CONNECTED_MONITORS ] && return
    [ $CONNECTED_PORTS -eq 3 ] && three
    [ $CONNECTED_PORTS -eq 2 ] && two
    [ $CONNECTED_PORTS -eq 1 ] && one
}

case $1 in
    one) one ;;
    two) two ;;
    three) three ;;
    *) check ;;
esac
