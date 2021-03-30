#! /bin/bash
:<<!
  设置屏幕分辨率的脚本
  home: 外接显示器在左边
  work: 外接显示器在右边
  copy: 复制显示器
  one: 单笔记本显示器
  auto: 根据内网ip自动选择是home还是work
  check: 检测显示器连接状态是否发生变化 -> 调用auto
!

CONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' disconnected ' | awk '{print $1}')

home() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output eDP-1 --mode 1440x900 --pos 1920x325 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 0x0
    ~/scripts/edit-profile.sh SCREEN_MODE HOME
    feh --randomize --bg-fill ~/Pictures/*.png
}
work() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output eDP-1 --mode 1440x900 --pos 0x525 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 1440x0
    ~/scripts/edit-profile.sh SCREEN_MODE WORK
    feh --randomize --bg-fill ~/Pictures/*.png
}
copy() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output eDP-1 --primary --mode 1440x900 --pos 0x0 --output $CONNECT_SCREEN --same-as eDP-1
    ~/scripts/edit-profile.sh SCREEN_MODE COPY
    feh --randomize --bg-fill ~/Pictures/*.png
}
copy2() {
    [ ! "$CONNECT_SCREEN" ] && one && return;
    xrandr --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 0x0 --output eDP-1 --scale 1.335x1.2 --same-as $CONNECT_SCREEN
    ~/scripts/edit-profile.sh SCREEN_MODE COPY
    feh --randomize --bg-fill ~/Pictures/*.png
}
one() {
    xrandr --output eDP-1 --primary --mode 1440x900 --pos 0x0 --output DP-1 --off --output DP-2 --off
    ~/scripts/edit-profile.sh SCREEN_MODE ONE
    feh --randomize --bg-fill ~/Pictures/*.png
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
