#! /bin/bash

CONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' connected ' | awk '{print $1}')
DISCONNECT_SCREEN=$(xrandr | grep DisplayPort | grep ' disconnected ' | awk '{print $1}')

home() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP --mode 1440x900 --pos 1920x325 --rotate normal --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 0x0 --rotate normal
    ~/scripts/edit-profile.sh SCREEN_MODE HOME
}
work() {
    if [ "$CONNECT_SCREEN" == "" ]; then one; return; fi
    xrandr --output eDP --mode 1440x900 --pos 0x525 --rotate normal --output $DISCONNECT_SCREEN --off --output $CONNECT_SCREEN --primary --mode 1920x1080 --pos 1440x0 --rotate normal
    ~/scripts/edit-profile.sh SCREEN_MODE WORK
}
one() {
    xrandr --output eDP --primary --mode 1440x900 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off
    ~/scripts/edit-profile.sh SCREEN_MODE ONE
}

case $1 in
    home) home ;;
    work) work ;;
    one) one ;;
    *) 
        test "`ip addr show | ag '192.168.2'`" != "" && home
        test "`ip addr show | ag '192.168.1'`" != "" && work
        ;;
esac

feh --randomize --bg-fill ~/Pictures/*.png
