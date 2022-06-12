# rofi -show 自定义 -modi "自定义:~/rofi.sh"
#   1: 上述命令可调用rofi.sh作为自定义脚本
#   2: 将打印的内容作为rofi的选项
#   3: 每次选中后 会用选中项作为入参再次调用脚本
#   4: 当没有输出时 整个过程结束

echo -e "\0prompt\x1fmenu"

menu() {
    echo "set wallpaper"
    echo "toggle v2raya"
    echo "toggle picom"
    echo "toggle easyeffects"
    echo "bluetooth hp1"
    echo "bluetooth hp2"
}

case "$*" in
    "set wallpaper")
        ~/scripts/set-screen.sh
        menu
        ;;
    "toggle v2raya")
        [ "$(docker ps | grep v2raya)" ] && docker stop v2raya >> /dev/null || docker restart v2raya >> /dev/null
        ~/scripts/dwm-status.sh
        ;;
    "toggle picom") killall picom || ~/scripts/app-starter.sh picom;;
    "toggle easyeffects") killall easyeffects || ~/scripts/app-starter.sh easyeffects ;;
    "bluetooth hp1") ~/scripts/bluetooth.sh hp $2 >> /dev/null 2>&1 & ;;
    "bluetooth hp2") ~/scripts/bluetooth.sh hp2 $2 >> /dev/null 2>&1 & ;;
    *) menu ;;
esac
