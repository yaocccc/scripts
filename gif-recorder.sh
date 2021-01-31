#! /bin/bash

gif_file=~/show.gif
let x y w h
source ~/.profile

case $SCREEN_MODE in
    HOME) S1_X=1920 S1_Y=325 S2_X=0 S2_Y=0 ;;
    WORK) S1_X=0 S1_Y=525 S2_X=1440 S2_Y=0 ;;
    ONE) S1_X=0 S1_Y=0 ;;
    *) exit ;;
esac

case $SCREEN_MODE in
    ONE)
        case $1 in
            1) let x=$S1_X y=$S1_Y w=1440 h=900 ;;
            *)
                echo 1: 内置屏幕-全屏
                exit
                ;;
        esac
        ;;
    *)
        case $1 in
            1) let x=$S1_X     y=$S1_Y     w=1440     h=900 ;;
            2) let x=$S2_X     y=$S2_Y     w=1920     h=1080 ;;
            3) let x=$S2_X+478 y=$S2_Y+229 w=964      h=736 ;;
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

if [ "$2" != "" ]; then
    cmd="-e "$2
fi

byzanz-record -x $x -y $y -w $w -h $h -v $gif_file $cmd
sleep 1
