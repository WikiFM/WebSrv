#!/bin/bash

export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data

if [[ "$UID" != "" ]] ; then
 if [[ "$GID" != "" ]] ; then
  export APACHE_RUN_USER=www-data-dummy
  export APACHE_RUN_GROUP=www-data-dummy
  groupadd  -g $GID $APACHE_RUN_GROUP
  useradd -g $GID -u $UID $APACHE_RUN_USER
 fi
fi

if [ -f /certs/websrv.crt ] ; then
 echo "Copy /certs/websrv.crt"
 cp /certs/websrv.crt /etc/ssl/certs/apache.crt
fi
if [ -f /certs/websrv.key ] ; then
 echo "Copy /certs/websrv.key"
 cp /certs/websrv.key /etc/ssl/private/apache.key
fi
chmod 755 /etc/ssl/certs/apache.crt /etc/ssl/private/apache.key

if [[ ! -f /etc/ssl/private/apache.key ]] ; then
 rm -f /etc/ssl/private/apache.key
 rm -f /etc/ssl/certs/apache.crt

 openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
 openssl rsa -passin pass:x -in server.pass.key -out /etc/ssl/private/apache.key
 rm server.pass.key
 openssl req -new -key /etc/ssl/private/apache.key -out server.csr -subj "/C=IT/ST=Italia/L=Milano/O=WikiToLearn/OU=IT Department/CN=www.wikitolearn.org"
 openssl x509 -req -days 365000 -in server.csr -signkey /etc/ssl/private/apache.key -out /etc/ssl/certs/apache.crt
 rm server.csr
fi

# export APACHE_RUN_USER=www-data
# export APACHE_RUN_GROUP=www-data
export APACHE_LOG_DIR=/var/log/apache2
export APACHE_PID_FILE=/var/run/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
/usr/sbin/apache2 -D FOREGROUND
