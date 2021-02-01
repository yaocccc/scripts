#! /bin/bash

MOUSE1=F3:DF:74:53:B3:E2
MOUSE2=34:88:5D:54:BC:7F
KEYBOARD1=BF:52:04:01:1C:D2
KEYBOARD2=3A:82:04:01:1D:26
HEADPHONE=D8:55:75:12:AF:44

ls() {
    echo m1 bluetoothctl connect MOUSE1
    echo m2 bluetoothctl connect MOUSE2
    echo k1 bluetoothctl connect KEYBOARD1
    echo k2 bluetoothctl connect KEYBOARD2
    echo hp bluetoothctl connect HEADPHONE
}
case $1 in
    m1) bluetoothctl connect $MOUSE1;;
    m2) bluetoothctl connect $MOUSE2;;
    k1) bluetoothctl connect $KEYBOARD1;;
    k2) bluetoothctl connect $KEYBOARD2;;
    hp) bluetoothctl connect $HEADPHONE;;
    *) ls ;;
esac
