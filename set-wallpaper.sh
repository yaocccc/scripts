#! /bin/bash
:<<!
  设置壁纸
!

source ~/.profile

killall mpv >> /dev/null 2>&1
killall xwinwrap >> /dev/null 2>&1

case $WALLPAPER_MODE in
    PIC)
        feh --randomize --bg-fill ~/Pictures/002/*.png
        ;;
    MP4)
        sleep 0.2
        [ "$1" ] && rand=$1 ||  while :; do
            source ~/.profile
            rand=$((RANDOM % 4 + 1))
            [ "$WALLPAPER_RAND" != $rand ] && break
        done

        case $SCREEN_MODE in
            ONE) mp4=~/Pictures/mp4/$rand/wallpaper_one.mp4;;
            *) mp4=~/Pictures/mp4/$rand/wallpaper_two.mp4;;
        esac
        xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --no-stop-screensaver $mp4 >> /dev/null 2>&1 &
        ~/scripts/edit-profile.sh WALLPAPER_RAND $rand
        ;;
esac
