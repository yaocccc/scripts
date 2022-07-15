#! /bin/bash
# 蓝牙连接脚本

MOUSE1=F3:DF:74:53:B3:E2
MOUSE2=34:88:5D:54:BC:7F
KEYBOARD1=BF:52:04:01:1C:D2
KEYBOARD2=3A:82:04:01:1D:26
HEADPHONE=64:03:7F:7C:81:15
HEADPHONE2=88:C9:E8:14:2A:72
VOICEBOX=8C:DE:F9:E6:E5:6B

ls() {
    echo m1  bluetoothctl connect MOUSE1
    echo m2  bluetoothctl connect MOUSE2
    echo k1  bluetoothctl connect KEYBOARD1
    echo k2  bluetoothctl connect KEYBOARD2
    echo hp  bluetoothctl connect HEADPHONE
    echo hp2 bluetoothctl connect HEADPHONE-SONY
    echo vb  bluetoothctl connect VOICEBOX
}
blconnect() {
    bluetoothctl connect $1
    notify-send 蓝牙设备 "$1已连接"
    ~/scripts/dwm-status.sh
}
bldisconnect() {
    bluetoothctl disconnect $1
    notify-send 蓝牙设备 "$1已断开"
    ~/scripts/dwm-status.sh
}
case $1 in
    m1)   blconnect $MOUSE1;;
    m2)   blconnect $MOUSE2;;
    k1)   blconnect $KEYBOARD1;;
    k2)   blconnect $KEYBOARD2;;
    hp)   blconnect $HEADPHONE;;
    hp2)  blconnect $HEADPHONE2;;
    vb)   blconnect $VOICEBOX;;
    dm1)  bldisconnect $MOUSE1;;
    dm2)  bldisconnect $MOUSE2;;
    dk1)  bldisconnect $KEYBOARD1;;
    dk2)  bldisconnect $KEYBOARD2;;
    dhp)  bldisconnect $HEADPHONE;;
    dhp2) bldisconnect $HEADPHONE2;;
    dvb)  bldisconnect $VOICEBOX;;
    *)    ls ;;
esac
