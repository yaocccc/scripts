#! /bin/bash

currentdir=$(cd $(dirname $0);pwd)
source $currentdir/bin/st_geometry

close_music() {
    ncmpcpp_pid=`ps -u $USER -o pid,comm | grep 'ncmpcpp' | awk '{print $1}'`
    mpd_pid=`ps -u $USER -o pid,comm | grep 'mpd' | awk '{print $1}'`
    killed=1
    if [ "$ncmpcpp_pid" ]; then
        kill -9 $ncmpcpp_pid
        killed=0
    fi
    if [ "$mpd_pid" ]; then
        kill -9 $mpd_pid
        killed=0
    fi
    return $killed
}

close_music || (mpd; alphast -g $(st_geometry top_right 50 10) -t music -c music -e 'ncmpcpp')
