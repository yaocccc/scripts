#!/bin/bash

case $1 in
    up) /usr/bin/amixer -qM set Master 5%+ umute ;;
    down) /usr/bin/amixer -qM set Master 5%- umute ;;
    toggle) /usr/bin/amixer set Master toggle ;;
esac

bash ~/scripts/dwm-status-refresh.sh
