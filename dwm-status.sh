#! /bin/bash
# dwm状态栏刷新脚本

source ~/.profile

print_privoxy(){
    if [ "$http_proxy" != "" ]; then echo "💡|"; fi
}

print_date(){
    echo "🗓$(date '+%m-%d')"
}

print_time(){
    clock_icons=("🕛" "🕧" "🕐" "🕜" "🕑" "🕝" "🕒" "🕞" "🕓" "🕟" "🕔" "🕠" "🕕" "🕡" "🕖" "🕢" "🕗" "🕣" "🕘" "🕤" "🕙" "🕥" "🕚" "🕦" "🕛" "🕧")
    hour=`date '+%l'`
    minute=`date '+%M' | awk '{print int($0)}'`
    if [ "$minute" -ge 30 ]; then hour=$((hour=2*hour+1)); else hour=$((hour=2*hour)); fi
    echo "${clock_icons[$hour]}$(date '+%R')"
}

print_cpu(){
    cpuusage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}');
    echo "🖥$cpuusage%";
}

print_mem(){
	memavailable=$(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}');
	memtotal=$(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}');
    memusedpercent=$[ ($memtotal - $memavailable) * 100 / $memtotal ];
	echo "🚀$memusedpercent%";
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
    batpercent=$(expr $(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+"))
    batsign="🔋";
    if [ "$(acpi -b | grep 'Battery 0' | grep Discharging)" == "" ] && [ "$batpercent" -le 95 ]; then chargesign="🔌"; fi
    echo "$chargesign$batsign$batpercent%"
}

xsetroot -name "$(print_privoxy)$(print_date)|$(print_time)|$(print_cpu)|$(print_mem)|$(print_alsa)|$(print_bat)"
