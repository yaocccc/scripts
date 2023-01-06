case "$1" in
    run) rofi -show run -theme ~/scripts/config/rofi.rasi ;;
    drun) rofi -show drun -show-icons -theme ~/scripts/config/rofi_2c.rasi ;;
    custom) rofi -show menu -modi 'menu:~/scripts/rofi.sh' -theme ~/scripts/config/rofi.rasi ;;
    window) rofi -show window -show-icons -theme ~/scripts/config/rofi_2c.rasi ;;
esac
