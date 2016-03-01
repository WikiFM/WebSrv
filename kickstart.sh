#!/bin/bash

rm -f /var/run/php5-fpm.*

if [[ "$USER_UID" != "" ]] ; then
 usermod -u $USER_UID www-data
fi
if [[ "$USER_GID" != "" ]] ; then
 groupmod -g $USER_GID www-data
fi

if [ -f /certs/websrv.crt ] ; then
 echo "Copy /certs/websrv.crt"
 cp /certs/websrv.crt /etc/ssl/certs/apache.crt
fi
if [ -f /certs/websrv.key ] ; then
 echo "Copy /certs/websrv.key"
 cp /certs/websrv.key /etc/ssl/private/apache.key
fi

if [[ ! -f /etc/ssl/private/apache.key ]] ; then
 rm -f /etc/ssl/private/apache.key
 rm -f /etc/ssl/certs/apache.crt

 openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
 openssl rsa -passin pass:x -in server.pass.key -out /etc/ssl/private/apache.key
 rm server.pass.key
 openssl req -sha256 -new -key /etc/ssl/private/apache.key -out server.csr -subj "/C=IT/ST=Italia/L=Milano/O=WikiToLearn/OU=IT Department/CN=www.wikitolearn.org"
 openssl x509 -sha256 -req -days 365000 -in server.csr -signkey /etc/ssl/private/apache.key -out /etc/ssl/certs/apache.crt
 rm server.csr
fi

chmod 755 /etc/ssl/certs/apache.crt /etc/ssl/private/apache.key

exec /usr/bin/supervisord
