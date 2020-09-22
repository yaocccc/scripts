#! /bin/bash

backup() {
    local from_dir=/
    local to_dir=/home/chenyc/backups/linux
    mkdir -p $to_dir
    sudo rsync -Pa $from_dir $to_dir --exclude=/media/* --exclude=/sys/* --exclude=/proc/* --exclude=/mnt/* --exclude=/tmp/* --exclude=*/node_modules/* --exclude=/home/chenyc/backups/linux/*
    echo -e '\033[43;30mbackup completed :) \033[0m'
}

recovery() {
    local from_dir=/home/chenyc/backups/linux/
    local to_dir=/
    sudo rsync -Pa $from_dir $to_dir
    echo -e '\033[43;30mrecovery completed:) \033[0m'
}

case $1 in
    backup) backup ;;
    recovery) recovery ;;
esac
