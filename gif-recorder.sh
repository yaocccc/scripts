#! /bin/bash
:<<!
 gif录制脚本 需要依赖 byzanz-record
 使用 ./gif-recorder.sh $模式 $命令
 若想支持鼠标选中区域录制 需要依赖 xrectsel
!

gif_file=~/show.gif
let x y w h
source ~/scripts/lib/menu
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
        menu_items=('选择窗口' '选择区域' '内置屏幕-全屏')
        menu
        case $item in
            '选择窗口') getwin ;;
            '选择区域') getregion ;;
            '内置屏幕-全屏') let x=$S1_X y=$S1_Y w=1440 h=900 ;;
        esac
        ;;
    *)
        menu_items=('选择窗口' '选择区域' '内置屏幕-全屏' '外接屏幕-全屏' '外接屏幕-中间区域')
        menu
        case $item in
            '选择窗口') getwin ;;
            '选择区域') getregion ;;
            '内置屏幕-全屏') let x=$S1_X     y=$S1_Y     w=1440     h=900 ;;
            '外接屏幕-全屏') let x=$S2_X     y=$S2_Y     w=1920     h=1080 ;;
            '外接屏幕-中间区域') let x=$S2_X+478 y=$S2_Y+229 w=964      h=736 ;;
        esac
        ;;
esac

[ "$*" ] && _cmd="$*"
[ -z "$_cmd" ] && printf "输入附加命令[回车结束]: " && read _cmd
[ -z "$_cmd" ] && byzanz-record -x $x -y $y -w $w -h $h -v $gif_file || byzanz-record -x $x -y $y -w $w -h $h -v $gif_file --exec="$_cmd"
sleep 1
