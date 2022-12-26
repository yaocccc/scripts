#! /bin/bash

INNER_PORT=eDP-1
OUTPORT1=DP-1
OUTPORT2=DP-2

sc=$(echo -e "内置显示器\n外置显示器" | fzf --header=选择设备)
light=$(echo -e "1.0\n0.8\n0.6\n0.4\n0.2" | fzf --header=选择亮度)

case $sc in
    内置显示器) out=$INNER_PORT ;;
    外置显示器) out=$(xrandr | grep -v $INNER_PORT | grep -w 'connected' | awk '{print $1}') ;;
esac

xrandr --output $out --brightness $light
