#!/bin/bash

if [[ "$USER_UID" != "" ]] ; then
 usermod -u $USER_UID www-data
fi
if [[ "$USER_GID" != "" ]] ; then
 groupmod -g $USER_GID www-data
fi

if [ -f /certs/websrv.crt ] ; then
 echo "Copy /certs/websrv.crt"
 cp /certs/websrv.crt /etc/ssl/certs/websrv.crt
fi
if [ -f /certs/websrv.key ] ; then
 echo "Copy /certs/websrv.key"
 cp /certs/websrv.key /etc/ssl/private/websrv.key
fi

if [[ ! -f /etc/ssl/private/websrv.key ]] ; then
 rm -f /etc/ssl/private/websrv.key
 rm -f /etc/ssl/certs/websrv.crt

 openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/ssl/private/websrv.key -out /etc/ssl/certs/websrv.crt -subj "/CN=www.wikitolearn.org"
fi

chmod 750 /etc/ssl/certs/websrv.crt /etc/ssl/private/websrv.key

chown www-data: /var/log/nginx -R
chown www-data: /var/www/
chown www-data: /var/log/mediawiki/
chown www-data: /run/php/

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
