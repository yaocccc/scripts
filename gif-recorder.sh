#!/bin/bash

gif_file=~/show.gif
let x y w h
source ~/.profile

while getopts "m:e:d:w:f:" opt
do
    case $opt in
        m) mode=$OPTARG ;;
        e) cmd=$OPTARG ;;
        d) record_time=$OPTARG ;;
        w) wait_time=$OPTARG ;;
        f) gif_file=$OPTARG ;;
    esac
done

case $SCREEN_MODE in
    HOME) S1_X=1920 S1_Y=325 S2_X=0 S2_Y=0 ;;
    WORK) S1_X=0 S1_Y=525 S2_X=1440 S2_Y=0 ;;
    ONE) S1_X=0 S1_Y=0 ;;
    *) exit ;;
esac

case $SCREEN_MODE in
    ONE)
        case $mode in
            1) let x=$S1_X y=$S1_Y w=1440 h=900 ;;
            *)
                echo 1: 内置屏幕-全屏
                exit
                ;;
        esac
        ;;
    *)
        case $mode in
            1) let x=$S1_X     y=$S1_Y     w=$S1_W    h=$S1_H ;;
            2) let x=$S2_X     y=$S2_Y     w=$S2_W    h=$S2_H ;;
            3) let x=$S2_X+475 y=$S2_Y+188 w=971      h=785 ;;
            4) let x=$S2_X+976 y=$S2_Y+34  w=937      h=513 ;;
            *)
                echo 1: 内置屏幕-全屏
                echo 2: 外接屏幕-全屏
                echo 3: 外接屏幕-中间区域
                echo 4: 外接屏幕-右上角区域
                exit
                ;;
        esac
        ;;
    esac

showTimer() {
    let i1=$1 
    let i2=$2
    echo Starting record on $i1 seconds
    while [ $i1 -ge 1 ]
    do
        echo $i1
        let i1--
        sleep 1
    done
    while [ $i2 -ge 1 ]
    do
        echo $i2
        let i2--
        sleep 1
    done
}

if [ "$cmd" == ""  ]; then
    showTimer ${wait_time-3} ${record_time-10} &
else
    wait_time=0
    cmd="-e "$cmd
fi

echo $x $y $w $h
byzanz-record -x $x -y $y -w $w -h $h --delay=${wait_time-3} -d ${record_time-10} -v $gif_file $cmd
sleep 1
