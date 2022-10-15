# rofi -show 自定义 -modi "自定义:~/rofi.sh"
#   1: 上述命令可调用rofi.sh作为自定义脚本
#   2: 将打印的内容作为rofi的选项
#   3: 每次选中后 会用选中项作为入参再次调用脚本
#   4: 当没有输出时 整个过程结束

source ~/.profile

menu_items[1]='set wallpaper'; cmds[1]='feh --randomize --bg-fill ~/Pictures/002/*.png; show_menu'

if [ "$(sudo docker ps | grep v2raya)" ]; then
    menu_items[2]='close v2raya'; cmds[2]='coproc (sudo docker stop v2raya > /dev/null 2>&1)'
else 
    menu_items[2]='open v2raya';  cmds[2]='coproc (sudo docker restart v2raya > /dev/null 2>&1)'
fi

if [ "$(ps aux | grep picom | grep -v 'grep\|rofi')" ]; then
    menu_items[3]='close picom';  cmds[3]='killall picom'
else 
    menu_items[3]='open picom';   cmds[3]='coproc (picom --experimental-backends --config ~/scripts/config/picom.conf > /dev/null 2>&1)'
fi

if [ "$(ps aux | grep easyeffects | grep -v 'grep\|rofi')" ]; then
    menu_items[4]='close easyeffects'; cmds[4]='killall easyeffects'
else 
    menu_items[4]='open easyeffects';  cmds[4]='coproc (easyeffects --gapplication-service > /dev/null 2>&1)'
fi

if [ "$GO111MODULE" = 'on' ]; then
    menu_items[5]='close GO111MODULE'; cmds[5]='sed -i "s/GO111MODULE=.*/GO111MODULE=off/g" ~/.profile'
else 
    menu_items[5]='open GO111MODULE';  cmds[5]='sed -i "s/GO111MODULE=.*/GO111MODULE=on/g" ~/.profile'
fi

show_menu() {
    echo -e "\0prompt\x1fmenu"
    for item in "${menu_items[@]}"; do
        echo "$item"
    done
}

[ ! "$*" ] && show_menu && exit 0
for i in "${!menu_items[@]}"; do
    [ "$*" = "${menu_items[$i]}" ] && eval "${cmds[$i]}"
done
