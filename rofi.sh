# https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown
#
# rofi -show 自定义 -modi "自定义:~/rofi.sh"
#   1: 上述命令可调用rofi.sh作为自定义脚本
#   2: 将打印的内容作为rofi的选项
#   3: 每次选中后 会用选中项作为入参再次调用脚本
#   4: 当没有输出时 整个过程结束

source ~/.profile

##### MAIN_MENU ####
    main_menu_items=(' set wallpaper' '艹 update statusbar' ' toggle server' ' set backlight')
    main_menu_cmds=(
        'feh --randomize --bg-fill ~/Pictures/wallpaper/*.png; show_main_menu' # 执行完不退出脚本继续执行show_main_menu
        'coproc ($DWM/statusbar/statusbar.sh updateall > /dev/null 2>&1); show_main_menu'
        'show_toggle_server_menu'
        'show_set_backlight_menu'
    )

##### TOGGLE_SERVER_MENU #####
    toggle_server_menu_items[1]=' open v2raya'
    toggle_server_menu_items[2]=' open picom'
    toggle_server_menu_items[5]=' open GO111MODULE'
    toggle_server_menu_cmds[1]='coproc (sudo docker restart v2raya > /dev/null && $DWM/statusbar/statusbar.sh updateall > /dev/null)'
    toggle_server_menu_cmds[2]='coproc (picom --experimental-backends --config ~/scripts/config/picom.conf > /dev/null 2>&1)'
    toggle_server_menu_cmds[5]='sed -i "s/GO111MODULE=.*/GO111MODULE=on/g" ~/.profile'
    # 根据不同的条件判断单项的值和操作
    [ "$(sudo docker ps | grep v2raya)" ] && toggle_server_menu_items[1]=' close v2raya'
    [ "$(sudo docker ps | grep v2raya)" ] && toggle_server_menu_cmds[1]='coproc (sudo docker stop v2raya > /dev/null && $DWM/statusbar/statusbar.sh updateall > /dev/null)'
    [ "$(ps aux | grep picom | grep -v 'grep\|rofi\|nvim')" ] && toggle_server_menu_items[2]=' close picom' 
    [ "$(ps aux | grep picom | grep -v 'grep\|rofi\|nvim')" ] && toggle_server_menu_cmds[2]='killall picom'
    [ "$GO111MODULE" = 'on' ] && toggle_server_menu_items[5]=' close GO111MODULE'
    [ "$GO111MODULE" = 'on' ] && toggle_server_menu_cmds[5]='sed -i "s/GO111MODULE=.*/GO111MODULE=off/g" ~/.profile'

##### SET BACKLIGHT #####
    set_backlight_menu_items=(' 内置屏幕' ' 外置屏幕')
    set_backlight_menu_cmds=('show_set_backlight_menu2 内置屏幕' 'show_set_backlight_menu2 外置屏幕')
    set_backlight_menu_items2=('1.0' '0.8' '0.6' '0.4' '0.2')

###### SHOW MENU ######
    show_main_menu() {
        echo -en "\0new-selection\x1ftrue\n"
        echo -e "\0prompt\x1fmenu\n"
        echo -en "\0data\x1fMAIN_MENU\n"
        for item in "${main_menu_items[@]}"; do
            echo "$item"
        done
    }
    show_toggle_server_menu() {
        echo -en "\0new-selection\x1ftrue\n"
        echo -e "\0prompt\x1ftoggle\n"
        echo -en "\0data\x1fTOGGLE_SERVER_MENU\n"
        for item in "${toggle_server_menu_items[@]}"; do
            echo "$item"
        done
    }
    show_set_backlight_menu() {
        echo -en "\0new-selection\x1ftrue\n"
        echo -e "\0prompt\x1fselect\n"
        echo -en "\0data\x1fSET_BACKLIGHT_MENU\n"
        for item in "${set_backlight_menu_items[@]}"; do
            echo "$item"
        done
    }
    show_set_backlight_menu2() {
        echo -en "\0new-selection\x1ftrue\n"
        echo -e "\0prompt\x1flight\n"
        echo -en "\0data\x1fSET_BACKLIGHT_$1\n"
        for item in "${set_backlight_menu_items2[@]}"; do
            echo "$item"
        done
    }

##### JUDGE #####
    judge() {
        [ "$ROFI_DATA" ] && MENU=$ROFI_DATA || MENU="MAIN_MENU" # 如果设置了ROFI_DATA（由 echo -en "\0data\x1fDATA值\n" 来传递）则使用ROFI_DATA对应的MENU，若空即MAIN_MENU
        # 根据不同的menu和item值执行相应的命令
        case $MENU in
            MAIN_MENU)
                for i in "${!main_menu_items[@]}"; do
                    [ "$*" = "${main_menu_items[$i]}" ] && eval "${main_menu_cmds[$i]}"
                done
            ;;
            TOGGLE_SERVER_MENU)
                for i in "${!toggle_server_menu_items[@]}"; do
                    [ "$*" = "${toggle_server_menu_items[$i]}" ] && eval "${toggle_server_menu_cmds[$i]}"
                done
            ;;
            SET_BACKLIGHT_MENU)
                for i in "${!set_backlight_menu_items[@]}"; do
                    [ "$*" = "${set_backlight_menu_items[$i]}" ] && eval "${set_backlight_menu_cmds[$i]}"
                done
            ;;
            SET_BACKLIGHT_内置屏幕)
                out=eDP-1; light=$1
                xrandr --output $out --brightness $light
            ;;
            SET_BACKLIGHT_外置屏幕)
                out=$(xrandr | grep -v eDP-1 | grep -w 'connected' | awk '{print $1}'); light=$1
                xrandr --output $out --brightness $light
            ;;
        esac
    }

##### 程序执行入口 #####
    [ ! "$*" ] && show_main_menu || judge $*
