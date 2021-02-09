#! /bin/bash
# DWM自启动脚本

# 设置终端静音
# 设置自动锁屏
# 设置触控版
# 设置代理关闭
# 设置屏幕分辨率
# 设置状态栏
xset -b
xset s 600
syndaemon -i 1 -t -K -R -d
~/scripts/set-privoxy.sh off &
~/scripts/set-screen.sh &

# 启动自动锁屏
# 启动窗口渲染
# 启动通知管理
# 启动电源管理
# 启动wine依赖
# 启动网络托盘
# 启动截图工具
# 启动fcitx
xss-lock -- ~/scripts/app-starter.sh blurlock &
picom --config ~/scripts/config/compton.conf &
dunst -conf ~/scripts/config/dunst.conf &
xfce4-power-manager &
/usr/lib/gsd-xsettings &
nm-applet &
flameshot &
fcitx &

# 每隔10秒   检查显示器链接情况 更新状态栏
# 每隔1000秒 切换壁纸
let check_time=0
while true
do
    ~/scripts/set-screen.sh check &
    ~/scripts/dwm-status.sh &
    test $check_time = 0 && feh --randomize --bg-fill ~/Pictures/* && check_time=100
    check_time=$[$check_time-1]
    sleep 10
done
