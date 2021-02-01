#! /bin/bash
# DWM自启动脚本

:<<!
  设置
    终端无蜂鸣声
    锁屏时间为10分钟
    触控版有键入时不可用
    代理为关
    屏幕分辨率状态
  启动 
    自动锁屏器
    窗口渲染器
    电源管理器
    wine环境依赖
    fcitx
    网络托盘
    截图工具
!
xset -b
xset s 600
syndaemon -i 1 -t -K -R -d
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh &

xss-lock -- ~/scripts/app-starter.sh blurlock &
picom --config ~/scripts/config/compton.conf &
xfce4-power-manager &
/usr/lib/gsd-xsettings &
fcitx &
nm-applet &
flameshot &

:<<!
  每隔5秒   检查显示器链接情况 更新状态栏
  每隔500秒 切换壁纸
!
let check_time=0
while true
do
    ~/scripts/set-screen.sh check &
    ~/scripts/dwm-status.sh &
    test $check_time = 0 && feh --randomize --bg-fill ~/Pictures/* && check_time=100
    check_time=$[$check_time-1]
    sleep 5
done
