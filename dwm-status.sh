#! /bin/bash
# dwm状态栏刷新脚本

source ~/.profile

print_others() {
    [ "$(bluetoothctl info 64:03:7F:7C:81:15 | grep 'Connected: yes')" ] && headphone_status="🎧"
    [ "$http_proxy" ] && privoxy_status="💡"
    others="$privoxy_status$headphone_status"
    [ "$others" ] && echo "$others|"
}

print_mail() {
    mailcount=`ls ~/Mail/inbox/new | wc -w`
    [ "$mailcount" -gt 0 ] && echo "💬$mailcount|"
}

print_date() {
    echo "🗓$(date '+%m-%d')|"
}

print_time() {
    clock_icons=("🕛" "🕧" "🕐" "🕜" "🕑" "🕝" "🕒" "🕞" "🕓" "🕟" "🕔" "🕠" "🕕" "🕡" "🕖" "🕢" "🕗" "🕣" "🕘" "🕤" "🕙" "🕥" "🕚" "🕦" "🕛" "🕧")
    hour=`date '+%l'`
    minute=`date '+%M' | awk '{print int($0)}'`
    [ "$minute" -ge 30 ] && hour=$((hour=2*hour+1)) || hour=$((hour=2*hour))
    echo "${clock_icons[$hour]}$(date '+%R')|"
}

print_weather() {
    [ "$weather" ] && echo "$weather|"
}

print_cpu() {
    cpuusage=$(cat /proc/stat | sed -n '1p' | awk '{printf "%02d", $2 / $5 * 100}')
    echo "🖥$cpuusage%|"
}

print_mem() {
	memavailable=$(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}')
	memtotal=$(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}')
    memusedpercent=$(echo $[ ($memtotal - $memavailable) * 100 / $memtotal ] | awk '{printf "%02d", $1}')
	echo "🚀$memusedpercent%|"
}

print_alsa() {
    [ "$(bluetoothctl info 64:03:7F:7C:81:15 | grep 'Connected: yes')" ] && OUTPORT=$HEADPHONE || OUTPORT=$SPEAKER
    vol=$(pacmd list-sinks | grep $OUTPORT -A 7 | sed -n '7p' | awk '{printf int($5)}')
    volunmuted=$(pacmd list-sinks | grep $OUTPORT -A 10 | grep 'muted: no')
    if [ "$vol" -eq 0 ] || [ ! "$volunmuted" ]; then vol="--"; volsign="🔇";
    elif [ "$vol" -gt 0 ] && [ "$vol" -le 33 ]; then volsign="🔈";
    elif [ "$vol" -gt 33 ] && [ "$vol" -le 66 ]; then volsign="🔉";
    else volsign="🔊"; fi
    echo "$volsign$vol%|"
}

print_bat() {
    batpercent=$(expr $(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+"))
    batsign="🔋"
    [ "$batpercent" -le 95 ] && [ ! "$(acpi -b | grep 'Battery 0' | grep Discharging)" ] && chargesign="🔌"
    echo "$chargesign$batsign$batpercent%"
}

xsetroot -name "$(print_others)$(print_date)$(print_time)$(print_weather)$(print_mail)$(print_cpu)$(print_mem)$(print_alsa)$(print_bat)"
