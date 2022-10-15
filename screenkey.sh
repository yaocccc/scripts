#! /bin/bash

source ~/.profile
case $SCREEN_MODE in
    ONE) killall screenkey || screenkey -p fixed -g 66%x8%+17%-5% & ;;
    TWO) killall screenkey || screenkey -p fixed -g 50%x8%+25%-11% & ;;
esac
