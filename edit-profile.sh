#! /bin/bash
# 更改环境变量脚本

if [ -s ~/.profile ]; then
    sed -i '/^export '$1'=.*$/d' ~/.profile
fi
echo 'export '$1'='$2'' >> ~/.profile

source ~/.profile
