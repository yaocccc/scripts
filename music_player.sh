#! /bin/bash

currentdir=$(cd $(dirname $0);pwd)

st_geometry() {
    # 单位x = 9, 单位y = 18
    uw=8; uh=17
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    position=$1; c=$2; l=$3
    if [ "$mx" -lt 1920 ]; then
        wx=0; wy=0; ww=1920; wh=1080
        if [ $(xrandr --listmonitors | sed 1d | wc -l) -eq 1 ]; then # 如果是单屏
            ww=1440; wh=900
        fi
    else
        wx=1920; wy=325; ww=1440; wh=900
    fi

    case $position in
        top_left)
            x=$(( $wx + 12 ))
            y=$(( $wy + 38 ))
            ;;
        top_right)
            x=$(( $wx + $ww - 12 - $c * $uw ))
            y=$(( $wy + 38 ))
            ;;
        center)
            x=$(( $wx + $ww / 2 - $c * $uw / 2 ))
            y=$(( $wy + $wh / 2 - $l * $uh / 2 + 12 ))
            ;;
    esac
    echo $c\x$l+$x+$y
}

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

close_music || (mpd; st -g $(st_geometry top_right 50 10) -A 0.7 -t music -c music -e 'ncmpcpp')
