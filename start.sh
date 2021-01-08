#!/bin/bash

if [ ! -e packages ];then
    mkdir -p packages
    if [ $UID -eq "0" ];then
        chown -R 999:999 packages
    fi
fi
if [ ! -e datadir ];then
    mkdir -p datadir
    if [ $UID -eq "0" ];then
        chown -R 1000:1000 datadir
    fi
fi

docker-compose up -d
docker-compose logs -f
