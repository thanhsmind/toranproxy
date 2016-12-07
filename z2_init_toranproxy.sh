#!/bin/bash
VHOST_FILE=/etc/apache2/sites-available/toranproxy.anphabe.net.conf
APP_FOLDER="$VOLUME_DATA/toran"
TORANPROXY_WEB=/data/toran/web

if [[ ! -d $APP_FOLDER ]]; then
    echo "=> ToranProxy at [$APP_FOLDER] not found. Installing toran proxy..."
    wget $APP_TORAN_SOURCE
    tar -zxvf toran-proxy-v1.1.2.tgz
    mv toran /data/
    rm toran-proxy-v1.1.2.tgz
    mkdir /data/toran/app/toran/ -p
    cp /opt/parameters.yml /data/toran/app/config/
    cp /opt/config.yml /data/toran/app/toran/
    chown www-data:www-data /data/toran -R
    chmod 775 /data/toran -R
else
    echo "=> Using existed ToranProxy Application at [$CONFIG_FOLDER] ..."
fi

sudo cat > $VHOST_FILE <<FILECONTENT
<VirtualHost *:80>
        ServerName toranproxy.anphabe.net
        DocumentRoot $TORANPROXY_WEB
                <Directory $TORANPROXY_WEB>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride all
                Require all granted
        </Directory>
</VirtualHost>
FILECONTENT

chown www-data:www-data $TORANPROXY_WEB -R
a2ensite toranproxy.anphabe.net
supervisorctl restart apache2
sudo -u www-data php /data/toran/bin/cron -v
EXISTED=$(grep "/data/toran" /etc/crontab)
if [[ $EXISTED == "" ]]; then
        echo "*  *    * * *   www-data cd /data/toran && php bin/cron" >> /etc/crontab
fi