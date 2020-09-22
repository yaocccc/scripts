#!/bin/bash

print_privoxy(){
    PIDS=`ps -ef | grep privoxy | grep -v grep | grep -v set-privoxy | awk '{print $2}'`;
    if [ "$PIDS" != "" ]; then echo "privoxy : on |"; fi
}

print_cpu(){
    cpuusage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}');
    echo "$cpuusage";
}

print_mem(){
	memavailable=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 10000));
	memtotal=$(($(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}') / 1000000));
    memavailablepercent=$(expr $memavailable / $memtotal);
    memusedpercent=$(expr 100 - $memavailablepercent);
	echo "$memusedpercent%";
}

print_alsa(){
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/");
    echo "$VOL%"
}

print_bat(){
	echo "$(expr $(acpi -b | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | bc))%";
}

print_date(){
	date '+%m/%d %H:%M'
}

xsetroot -name "$(print_privoxy) $(print_cpu) | $(print_mem) | $(print_alsa) | $(print_bat) | $(print_date)"
exit 0
