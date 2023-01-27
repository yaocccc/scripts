#! /bin/bash
:<<!
 gif录制脚本 需要依赖 byzanz-record
 使用 ./gif-recorder.sh $模式 $命令
 若想支持鼠标选中区域录制 需要依赖 xrectsel
!

gif_file=~/show.gif
let x y w h
source ~/scripts/lib/menu

getwin() {
    XWININFO=$(xwininfo)
    read x < <(awk -F: '/Absolute upper-left X/{print $2}' <<< "$XWININFO")
    read y < <(awk -F: '/Absolute upper-left Y/{print $2}' <<< "$XWININFO")
    read w < <(awk -F: '/Width/{print $2}' <<< "$XWININFO")
    read h < <(awk -F: '/Height/{print $2}' <<< "$XWININFO")
    read border < <(awk -F: '/Border width/{print $2}' <<< "$XWININFO")
    w=$((w + 2 * border))
    h=$((h + 2 * border))
}
getregion() {
    xywh=($(xrectsel "%x %y %w %h")) || exit -1
    let x=${xywh[0]} y=${xywh[1]} w=${xywh[2]} h=${xywh[3]}
}

menu_items=('选择窗口' '选择区域')
menu
case $item in
    '选择窗口') getwin ;;
    '选择区域') getregion ;;
esac

[ -z "$_cmd" ] && printf "输入命令(gif会在命令结束时停止录制)[回车结束]: " && read _cmd
[ -z "$_cmd" ] && byzanz-record -x $x -y $y -w $w -h $h -v $gif_file || byzanz-record -x $x -y $y -w $w -h $h -v $gif_file --exec="$_cmd"
sleep 1
