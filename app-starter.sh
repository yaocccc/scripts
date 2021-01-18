#! /bin/bash

source ~/.profile

case $1 in
    pcmanfm) pcmanfm ;;
    rofi) rofi -show run ;;
    screenkey) killall screenkey || screenkey -p fixed -g 50%x8%+100%-11% & ;;
    blurlock) blurlock ;;
    chrome) google-chrome-stable ;;
    music) kill -9 $(ps -u $USER -o pid,comm | grep 'netease-cloud-m' | awk '{print $1}') || netease-cloud-music ;;
    pavucontrol) pavucontrol ;;
    postman) postman ;;
    tim) /opt/deepinwine/apps/Deepin-TIM/run.sh ;;
    wechat) wechat-uos ;;
    lark) cd ~/workspace/electron-lark && electron . ;;
esac
