#!/bin/sh

EDIT_PRIFILE=~/scripts/edit-profile.sh
PIDS=`ps -ef | grep privoxy | grep -v grep | grep -v set-privoxy | awk '{print $2}'`

on() {
    if [ "$PIDS" != "" ]; then echo "privoxy on, ok"; exit 0; fi
    $EDIT_PRIFILE http_proxy 127.0.0.1:8118
    $EDIT_PRIFILE https_proxy 127.0.0.1:8118
    /usr/bin/privoxy --no-daemon /etc/privoxy/config &
}

off() {
    if [ "$PIDS" == "" ]; then echo "privoxy off, ok"; exit 0; fi
    $EDIT_PRIFILE http_proxy ''
    $EDIT_PRIFILE https_proxy ''
    killall privoxy &
}

toggle() {
    if [ "$PIDS" != "" ]; then off; else on; fi
}

case $1 in
    on) on ;;
    off) off ;;
    toggle) toggle ;;
    *) toggle ;;
esac

~/scripts/dwm-status-refresh.sh
