#! /bin/bash

currentdir=$(cd $(dirname $0);pwd)
source $currentdir/bin/st_geometry

close_music() {
    ncmpcpp_pid=`ps -u $USER -o pid,comm | grep 'ncmpcpp' | awk '{print $1}'`
    mpd_pid=`ps -u $USER -o pid,comm | grep 'mpd' | awk '{print $1}'`
    cava_pid=`ps -u $USER -o pid,comm | grep 'cava' | awk '{print $1}'`
    killed=1
    if [ "$ncmpcpp_pid" ]; then
        kill -9 $ncmpcpp_pid
        killed=0
    fi
    if [ "$mpd_pid" ]; then
        kill -9 $mpd_pid
        killed=0
    fi
    if [ "$cava_pid" ]; then
        kill -9 $cava_pid
        killed=0
    fi
    return $killed
}

open_music() {
    mpd
    st -g $(st_geometry top_right 50 10) -A 0.7 -t music -c FN -e 'ncmpcpp' &
    st -A 0.7 -c FN -g $(st_geometry top_right 25 10 -50 0 -1) -e cava &
}

close_music || open_music
