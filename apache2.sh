#!/bin/bash

[[ "$UID" == "" ]] && UID=1000
[[ "$GID" == "" ]] && GID=1000
bindfs -m www-data --create-for-user=$UID --create-for-group=$GID /srv/ /var/www/

if [[ ! -f /etc/ssl/private/apache.key ]] || [[ ! -f /etc/ssl/certs/apache.crt ]] ; then
 rm -f /etc/ssl/private/apache.key
 rm -f /etc/ssl/certs/apache.crt

 openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
 openssl rsa -passin pass:x -in server.pass.key -out /etc/ssl/private/apache.key
 rm server.pass.key
 openssl req -new -key /etc/ssl/private/apache.key -out server.csr -subj "/C=IT/ST=Italia/L=Milano/O=WikiToLearn/OU=IT Department/CN=www.wikitolearn.org"
 openssl x509 -req -days 365000 -in server.csr -signkey /etc/ssl/private/apache.key -out /etc/ssl/certs/apache.crt
 rm server.csr
fi

export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_LOG_DIR=/var/log/apache2
export APACHE_PID_FILE=/var/run/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
/usr/sbin/apache2 -D FOREGROUND
