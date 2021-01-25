#! /bin/bash

source ~/.profile

case $1 in
    pcmanfm) pcmanfm ;;
    rofi) rofi -show run ;;
    blurlock) blurlock ;;
    chrome) google-chrome-stable ;;
    music) kill -9 $(ps -u $USER -o pid,comm | grep 'netease-cloud-m' | awk '{print $1}') || netease-cloud-music ;;
    pavucontrol) pavucontrol ;;
    postman) postman ;;
    tim) /opt/deepinwine/apps/Deepin-TIM/run.sh ;;
    wechat) wechat-uos ;;
    wxwork) /opt/apps/com.qq.weixin.work.deepin/files/run.sh ;;
    lark) cd ~/workspace/electron-lark && electron . ;;
    st) st ;;
    flameshot) flameshot gui ;;
    screenkey)
        case $SCREEN_MODE in
            ONE) killall screenkey || screenkey -p fixed -g 66%x8%+17%-5% & ;;
            HOME) killall screenkey || screenkey -p fixed -g 50%x8%+25%-11% & ;;
            WORK) killall screenkey || screenkey -p fixed -g 50%x8%+100%-11% & ;;
        esac
        ;;
esac
