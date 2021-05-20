#! /bin/bash
:<<!
  设置屏幕分辨率的脚本
  home: OUT - INNER
  work: INNER - OUT
  copy: INNER - INNER
  copy2: OUT - OUT
  one: INNER
  auto: 根据内网ip -> home 还是 work
  check: 检测显示器连接状态是否变化 -> 调用auto
!

INNER_SCREEN=eDP-1
OUT1_SCREEN=DP-1
OUt2_SCREEN=DP-2
CONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' disconnected ' | awk '{print $1}')

_post() {
    ~/scripts/edit-profile.sh SCREEN_MODE $1
    feh --randomize --bg-fill ~/Pictures/*.png
}
home() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output $INNER_SCREEN   --mode 1440x900  --pos 1920x325 --scale 1x1 \
           --output $CONNECT_SCREEN --mode 1920x1080 --pos 0x0      --scale 1x1 --primary \
           --output $DISCONNECT_SCREEN --off
    ~/scripts/edit-profile.sh SCREEN_MODE HOME
    feh --randomize --bg-fill ~/Pictures/*.png
    _post HOME
}
work() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output $INNER_SCREEN   --mode 1440x900  --pos 0x525  --scale 1x1 \
           --output $CONNECT_SCREEN --mode 1920x1080 --pos 1440x0 --scale 1x1 --primary\
           --output $DISCONNECT_SCREEN --off
    _post WORK
}
copy() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output $INNER_SCREEN   --mode 1440x900 --pos 0x0 --scale 1x1 --primary \
           --output $CONNECT_SCREEN --same-as $INNER_SCREEN   --scale 0.75x0.8333
    _post COPY
}
copy2() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output $CONNECT_SCREEN --mode 1920x1080 --pos 0x0 --scale 1x1 --primary \
           --output $INNER_SCREEN   --same-as $CONNECT_SCREEN  --scale 1.3333x1.2111
    _post COPY
}
one() {
    xrandr --output $INNER_SCREEN --mode 1440x900 --pos 0x0 --scale 1x1  --primary  \
           --output $OUT1_SCREEN --off \
           --output $OUt2_SCREEN --off
    _post ONE
}
auto() {
    # [ "$(ip addr show | grep '192.168.2')" ] && home || work;
    # 公司和家里电脑方式暂时是一样的 先保留
    home;
}
check() {
    source ~/.profile
    [ "$CONNECT_SCREEN" ] && [ "$SCREEN_MODE" == "ONE" ] && auto;
    [ ! "$CONNECT_SCREEN" ] && [ "$SCREEN_MODE" != "ONE" ] && auto;
}

case $1 in
    home) home ;;
    work) work ;;
    copy) copy ;;
    copy2) copy2 ;;
    one) one ;;
    check) check ;;
    *) auto ;;
esac
