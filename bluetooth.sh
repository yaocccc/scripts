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
case $1 in
    m1)  bluetoothctl connect $MOUSE1;;
    m2)  bluetoothctl connect $MOUSE2;;
    k1)  bluetoothctl connect $KEYBOARD1;;
    k2)  bluetoothctl connect $KEYBOARD2;;
    hp)  bluetoothctl connect $HEADPHONE;;
    hp2) bluetoothctl connect $HEADPHONE2;;
    vb)  bluetoothctl connect $VOICEBOX;;
    *)   ls ;;
esac
