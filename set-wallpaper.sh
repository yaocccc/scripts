#! /bin/bash
:<<!
  设置壁纸
!

source ~/.profile

case $WALLPAPER_MODE in
    PIC)
        feh --randomize --bg-fill ~/Pictures/002/*.png
        ;;
    MP4)
        killall mpv >> /dev/null 2>&1
        killall xwinwrap >> /dev/null 2>&1
        sleep 0.2
        case $SCREEN_MODE in
            ONE) mp4=~/Pictures/mp4/1/wallpaper_one.mp4;;
            *) mp4=~/Pictures/mp4/1/wallpaper_two.mp4;;
        esac
        xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --no-stop-screensaver $mp4 >> /dev/null 2>&1 &
        ;;
esac
