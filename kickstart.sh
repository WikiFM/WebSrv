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

 openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
 openssl rsa -passin pass:x -in server.pass.key -out /etc/ssl/private/websrv.key
 rm server.pass.key
 openssl req -sha256 -new -key /etc/ssl/private/websrv.key -out server.csr -subj "/C=IT/ST=Italia/L=Milano/O=WikiToLearn/OU=IT Department/CN=www.wikitolearn.org"
 openssl x509 -sha256 -req -days 365000 -in server.csr -signkey /etc/ssl/private/websrv.key -out /etc/ssl/certs/websrv.crt
 rm server.csr
fi

chmod 750 /etc/ssl/certs/websrv.crt /etc/ssl/private/websrv.key

chown www-data: /var/log/nginx -R
chown www-data: /var/www/
chown www-data: /var/log/mediawiki/
chown www-data: /run/php/

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
