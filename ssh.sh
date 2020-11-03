#! /bin/bash

SV=47.103.51.141
TT=101.132.35.191
TT2=47.101.193.136
PG=47.103.91.121
ML=101.132.35.191
YM=47.103.91.121

list() {
    echo
    echo sv=$SV
    echo tt=$TT
    echo tt2=$TT2
    echo pg=$PG
    echo ml=$ML
    echo ym=$YM
    echo
}

case $1 in
    sv) echo connect sitevar; ssh root@$SV ;;
    tt) echo connect tianting1; ssh root@$TT ;;
    tt2) echo connect tianting2; ssh root@$TT2 ;;
    pg) echo connect pangu; ssh root@$PG ;;
    ml) echo connect minglian; ssh root@$ML ;;
    ym) echo connect yimai; ssh root@$YM ;;
    ls) list ;;
    *) ssh $*;;
esac
