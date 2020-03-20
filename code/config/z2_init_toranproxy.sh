#!/bin/bash
VHOST_FILE=/etc/apache2/sites-available/${APP_TORAN_HOST}.conf
APP_FOLDER="$VOLUME_DATA/toran"
TORANPROXY_WEB=$VOLUME_DATA/toran/web
APP_FOLDER_INIT="$APP_FOLDER/toran"
if [[ ! -d $APP_FOLDER_INIT ]]; then
    echo "=> ToranProxy at [$APP_FOLDER_INIT] not found. Installing toran proxy..."
    
    mkdir $VOLUME_DATA/toran/app/toran/ -p
    mkdir $VOLUME_DATA/toran/web/repo/packagist -p
    cp /opt/parameters.yml $VOLUME_DATA/toran/app/config/
    cp /opt/config.yml $VOLUME_DATA/toran/app/toran/
    chown apache2:apache2 $VOLUME_DATA/toran -R
    chmod 775 $VOLUME_DATA/toran -R
else
    echo "=> Using existed ToranProxy Application at [$CONFIG_FOLDER] ..."
fi

cat > $VHOST_FILE <<FILECONTENT
<VirtualHost *:80>
        ServerName ${APP_TORAN_HOST}
        DocumentRoot $TORANPROXY_WEB
                <Directory $TORANPROXY_WEB>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride all
                Require all granted
        </Directory>
</VirtualHost>
FILECONTENT


chown apache2:apache2 $TORANPROXY_WEB -R
a2ensite ${APP_TORAN_HOST}

supervisorctl restart apache2
sudo -u apache2 php -d allow_url_fopen=1 $VOLUME_DATA/toran/bin/cron -v
EXISTED=$(grep "$VOLUME_DATA/toran" /etc/crontab)
if [[ $EXISTED == "" ]]; then
        echo "*  *    * * *   apache2 cd $VOLUME_DATA/toran && php bin/cron" >> /etc/crontab
fi
