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

chown www-data: /var/log/hhvm -R
chown www-data: /var/run/hhvm/ -R
chown www-data: /var/log/nginx -R
chown www-data: /var/www/
chown www-data: /var/log/mediawiki/

#if [[ "$WTL_PRODUCTION" == "1" ]] # segmentation fault whit this code
#then
#    echo "Building hhvm hhbc file"
#    su -s /bin/bash -c "hhvm --hphp -t hhbc --output-dir /var/run/hhvm/ --input-dir /var/www/" www-data
#fi

if [[ "$HHVM_NUM_WORKERS" == "" ]]
then
    HHVM_NUM_WORKERS=1
fi
HHVM_BASE_PORT=9000
HHVM_PORT=$HHVM_BASE_PORT

while [[ $HHVM_PORT -lt $(($HHVM_BASE_PORT+$HHVM_NUM_WORKERS)) ]]
do
    cat <<EOF > /etc/hhvm/server-$HHVM_PORT.ini
pid = /var/run/hhvm/pid-$HHVM_PORT
hhvm.server.port = $HHVM_PORT
hhvm.log.file = /var/log/hhvm/error-$HHVM_PORT.log
hhvm.pid_file = /var/run/hhvm/pid-hhvm-$HHVM_PORT
hhvm.repo.central.path = /var/run/hhvm/hhvm-$HHVM_PORT.hhbc
EOF

    cat <<EOF > /etc/supervisor/conf.d/hhvm-$HHVM_PORT.conf
[program:hhvm-$HHVM_PORT]
environment=WTL_PRODUCTION=%(ENV_WTL_PRODUCTION)s
user=www-data
group=www-data
command=hhvm --mode server --config /etc/hhvm/php.ini --config /etc/hhvm/shared.ini --config /etc/hhvm/server-$HHVM_PORT.ini
EOF
    HHVM_PORT=$(($HHVM_PORT+1))
done

HHVM_PORT=$HHVM_BASE_PORT
{
echo 'upstream upstream-hhvm {'
while [[ $HHVM_PORT -lt $(($HHVM_BASE_PORT+$HHVM_NUM_WORKERS)) ]]
do
echo ' server 127.0.0.1:'$HHVM_PORT';'
      HHVM_PORT=$(($HHVM_PORT+1))
done
echo '}'
} > /etc/nginx/upstream-hhvm.conf

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
