#! /bin/bash

CONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' disconnected ' | awk '{print $1}')

home() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP --mode 1440x900 --pos 1920x325 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 0x0 
    ~/scripts/edit-profile.sh SCREEN_MODE HOME
}
work() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP --mode 1440x900 --pos 0x525 --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 1440x0 
    ~/scripts/edit-profile.sh SCREEN_MODE WORK
}
copy() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP --primary --mode 1440x900 --pos 0x0 --output $CONNECT_SCREEN --same-as eDP
    ~/scripts/edit-profile.sh SCREEN_MODE ONE
}
one() {
    xrandr --output eDP --primary --mode 1440x900 --pos 0x0 --output DisplayPort-0 --off --output DisplayPort-1 --off
    ~/scripts/edit-profile.sh SCREEN_MODE ONE
}

case $1 in
    home) home ;;
    work) work ;;
    copy) copy ;;
    one) one ;;
    *) 
        test "`ip addr show | ag '192.168.2'`" != "" && home
        test "`ip addr show | ag '192.168.1'`" != "" && work
        ;;
esac

feh --randomize --bg-fill ~/Pictures/*.png
