#! /bin/bash

PIDS=`ps -ef | grep privoxy | grep -v grep | grep -v set-privoxy | awk '{print $2}'`

on() {
    if [ "$PIDS" != "" ]; then echo "privoxy on, ok"; exit 0; fi
    ~/scripts/edit-profile.sh http_proxy 127.0.0.1:8118
    ~/scripts/edit-profile.sh https_proxy 127.0.0.1:8118
    /usr/bin/privoxy --no-daemon ~/scripts/config/privoxy.conf &
}

off() {
    if [ "$PIDS" == "" ]; then echo "privoxy off, ok"; exit 0; fi
    ~/scripts/edit-profile.sh http_proxy ''
    ~/scripts/edit-profile.sh https_proxy ''
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
