#!/bin/bash

print_privoxy(){
    PIDS=`ps -ef | grep privoxy | grep -v grep | grep -v set-privoxy | awk '{print $2}'`;
    if [ "$PIDS" != "" ]; then echo "👓|"; fi
}

print_cpu(){
    cpuusage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}');
    echo "👽$cpuusage%";
}

print_mem(){
	memavailable=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 10000));
	memtotal=$(($(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}') / 1000000));
    memavailablepercent=$(expr $memavailable / $memtotal);
    memusedpercent=$(expr 100 - $memavailablepercent);
	echo "$memusedpercent%";
}

print_alsa(){
    vol=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/");
    volstatus=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)\]$/\1/");
    if [ "$vol" -eq 0 ] || [ "$volstatus" == "off" ]; then vol="--"; volsign="🔇";
    elif [ "$vol" -gt 0 ] && [ "$vol" -le 33 ]; then volsign="🔈";
    elif [ "$vol" -gt 33 ] && [ "$vol" -le 66 ]; then volsign="🔉";
    else volsign="🔊"; fi
    echo "$volsign$vol%"
}

print_bat(){
    batpercent=$(expr $(acpi -b | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | bc))
    if [ "$(acpi -b | grep discharging)" == "" ]; then chargesign=""; fi
    if [ "$batpercent" -le 10 ]; then batsign="";
    elif [ "$batpercent" -le 25 ]; then batsign="";
    elif [ "$batpercent" -le 50 ]; then batsign="";
    elif [ "$batpercent" -le 95 ]; then batsign="";
    else chargesign=""; batsign="☻"; fi
    echo "$chargestatus$batsign$batpercent%"
}

print_date(){
    date=$(date '+%m月%d日 %H点%M分')
    echo "$date"
}

xsetroot -name "$(print_privoxy)$(print_date)|$(print_cpu)|$(print_mem)|$(print_alsa)|$(print_bat)"
exit 0
