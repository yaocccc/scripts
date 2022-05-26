#! /bin/bash
:<<!
 gif录制脚本 需要依赖 byzanz-record
 使用 ./gif-recorder.sh $模式 $命令
 若想支持鼠标选中区域录制 需要依赖 xrectsel
!

gif_file=~/show.gif
let x y w h
source ~/.profile

getwin() {
    XWININFO=$(xwininfo)
    read x < <(awk -F: '/Absolute upper-left X/{print $2}' <<< "$XWININFO")
    read y < <(awk -F: '/Absolute upper-left Y/{print $2}' <<< "$XWININFO")
    read w < <(awk -F: '/Width/{print $2}' <<< "$XWININFO")
    read h < <(awk -F: '/Height/{print $2}' <<< "$XWININFO")
}
getregion() {
    xywh=($(xrectsel "%x %y %w %h")) || exit -1
    let x=${xywh[0]} y=${xywh[1]} w=${xywh[2]} h=${xywh[3]}
}

case $SCREEN_MODE in
    ONE) S1_X=0 S1_Y=0 ;;
    TWO) S1_X=1920 S1_Y=325 S2_X=0 S2_Y=0 ;;
    *) exit ;;
esac

case $SCREEN_MODE in
    ONE)
        case $1 in
            1) getwin ;;
            2) getregion ;;
            3) let x=$S1_X y=$S1_Y w=1440 h=900 ;;
            *)
                echo 1: 选择窗口
                echo 2: 选择区域
                echo 3: 内置屏幕-全屏
                exit
                ;;
        esac
        ;;
    *)
        case $1 in
            1) getwin ;;
            2) getregion ;;
            3) let x=$S1_X     y=$S1_Y     w=1440     h=900 ;;
            4) let x=$S2_X     y=$S2_Y     w=1920     h=1080 ;;
            5) let x=$S2_X+478 y=$S2_Y+229 w=964      h=736 ;;
            *)
                echo 1: 选择窗口
                echo 2: 选择区域
                echo 3: 内置屏幕-全屏
                echo 4: 外接屏幕-全屏
                echo 5: 外接屏幕-中间区域
                exit
                ;;
        esac
        ;;
esac

[ "$2" ] \
    && byzanz-record -x $x -y $y -w $w -h $h -v $gif_file --exec="$2 $3 $4 $5 $6 $7 $8 $9" \
    || byzanz-record -x $x -y $y -w $w -h $h -v $gif_file
sleep 1
