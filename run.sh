#!/bin/bash
set -e

function init_root_folder() {
  echo "=> Prepare Data Root folder"
  FOLDER=$(dirname $APACHE2_CONFIG_FOLDER)
  mkdir -p $FOLDER
  chmod 755 /data

  echo
}

function init_apache_config_folder() {
    FOLDER="$APACHE2_CONFIG_FOLDER"

    if [[ ! -d $FOLDER ]]; then
        echo "=> No APACHE2 CONFIG folder detected."
        echo "=> Creating APACHE2 Configuration at $FOLDER .."

        mkdir -p $FOLDER;
        cp /etc/apache2_origin/* $FOLDER/ -R
    else
      echo "=> Using an existing APACHE2 Configuration at $FOLDER"
    fi

    echo
}

function init_apache_log_folder() {
    FOLDER="$APACHE2_LOG_FOLDER"

    if [[ ! -d $FOLDER ]]; then
        echo "=> No APACHE2 LOG folder detected."
        echo "=> Creating APACHE2 LOG folder at [$FOLDER] ..."

        mkdir -p $FOLDER
        chown www-data:www-data $FOLDER
    else
      echo "=> Using an existing APACHE2 LOG folder at $FOLDER"
    fi

    echo
}

function init_apache_data_folder() {
    FOLDER="$APACHE2_DATA_FOLDER"

    if [[ ! -d $FOLDER ]]; then
        echo "=> No APACHE2 Data folder detected."
        echo "=> Creating APACHE2 Data folder at [$FOLDER] ..."

        mkdir -p $FOLDER
        cp /var/www_origin/* $FOLDER/ -r
        chown mio:mio $FOLDER
    else
      echo "=> Using an existing APACHE2 WWW folder at $FOLDER"
    fi
    echo
}

function init_php_config_folder() {
    FOLDER="$PHP5_CONFIG_FOLDER"

    if [[ ! -d $FOLDER ]]; then
        echo "=> No PHP CONFIG folder detected."
        echo "=> Creating PHP Configuration at $FOLDER"

        mkdir -p $FOLDER;
        cp /etc/php_origin/* $FOLDER/ -R
    else
      echo "=> Using an existing PHP5 Configuration at $FOLDER"
      echo
    fi
}

function init_php_log_folder() {
    FOLDER="$PHP5_LOG_FOLDER"

    if [[ ! -d $FOLDER ]]; then
        echo "=> No PHP LOG folder detected."
        echo "=> Creating PHP LOG folder at $FOLDER"

        mkdir -p $FOLDER;
    else
      echo "=> Using an existing PHP LOG Folder at $FOLDER"
      echo
    fi
}

echo "***************************************"
echo "* INITIALIZING APACHE2 ...."
echo "***************************************"
echo
init_root_folder

init_apache_config_folder
init_apache_data_folder
init_apache_log_folder
init_php_config_folder
init_php_log_folder

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2.pid
rm -rf /var/run/apache2/*
rm -rf /var/run/lock/apache2/*

source /etc/apache2/envvars
exec /usr/sbin/apache2 -DFOREGROUND