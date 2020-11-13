#! /bin/bash

if [ -s ~/.profile ]; then
    sed -i '/^export '$1'=.*$/d' ~/.profile
fi
echo 'export '$1'='$2'' >> ~/.profile
