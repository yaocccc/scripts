#! /bin/bash

CONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DP | grep -v eDP | grep ' disconnected ' | awk '{print $1}')

home() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP-1 --mode 1440x900 --pos 1920x325 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 0x0 
    ~/scripts/edit-profile.sh SCREEN_MODE HOME
}
work() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP-1 --mode 1440x900 --pos 0x525 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 1440x0 
    ~/scripts/edit-profile.sh SCREEN_MODE WORK
}
copy() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP-1 --primary --mode 1440x900 --pos 0x0 --output $CONNECT_SCREEN --same-as eDP-1
    ~/scripts/edit-profile.sh SCREEN_MODE ONE
}
one() {
    xrandr --output eDP-1 --primary --mode 1440x900 --pos 0x0 --output DP-1 --off --output DP-2 --off
    ~/scripts/edit-profile.sh SCREEN_MODE ONE
}

case $1 in
    home) home ;;
    work) work ;;
    copy) copy ;;
    one) one ;;
    *) 
        test "`ip addr show | ag '192.168.2'`" != "" && home || work
        ;;
esac

feh --randomize --bg-fill ~/Pictures/*.png
