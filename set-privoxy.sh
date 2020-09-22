#!/bin/sh

PIDS=`ps -ef | grep privoxy | grep -v grep | grep -v set-privoxy | awk '{print $2}'`
ENV_DIR=~/.config/zsh/cache
ENV_FILE=$ENV_DIR/privoxy.env

sync_file() {
    mkdir -p $ENV_DIR
    touch $ENV_FILE
    rm $ENV_FILE
    echo 'export http_proxy='$http_proxy >> $ENV_FILE
    echo 'export https_proxy='$https_proxy >> $ENV_FILE
}

on() {
    if [ "$PIDS" != "" ]; then echo "privoxy on, ok"; exit 0; fi
    export http_proxy="127.0.0.1:8118"
    export https_proxy="127.0.0.1:8118"
    sync_file
    /usr/bin/privoxy --no-daemon /etc/privoxy/config &
}

off() {
    if [ "$PIDS" == "" ]; then echo "privoxy off, ok"; exit 0; fi
    export http_proxy=''
    export https_proxy=''
    sync_file
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
