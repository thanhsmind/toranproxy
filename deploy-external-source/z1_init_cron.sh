#!/bin/bash

function expose_config() {
    mkdir -p $VOLUME_CONFIG
    chmod 755 $VOLUME_CONFIG
    CONFIG_FOLDER="$VOLUME_CONFIG/cron"

    if [[ ! -d $CONFIG_FOLDER ]]; then
        echo "=> Creating default Cron Configuration at $CONFIG_FOLDER ..."
        mkdir -p $CONFIG_FOLDER;
        cp /etc/crontab_origin $CONFIG_FOLDER/crontab
    else
        echo "=> Using existing Cron Configuration at $CONFIG_FOLDER" 
    fi
}

echo "***************************************"
echo "* INITIALIZING CRON ...."
echo "***************************************"
echo 
expose_config
echo
