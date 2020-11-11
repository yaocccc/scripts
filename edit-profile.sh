#! /bin/bash

PROFILE=~/.profile

if [ -s $PROFILE ]; then
    sed -i '/^export '$1'=.*$/d' $PROFILE
fi
echo 'export '$1'='$2'' >> $PROFILE
