#!/bin/bash
apt-get update
apt-get -y install apt-utils curl
apt-get -y install apache2 php5-fpm libapache2-mod-fastcgi supervisor git php5-apcu php5-mysql
apt-get clean
a2enmod rewrite ssl actions
rm /var/www/* -Rf

a2dissite 000-default.conf
rm -f /etc/apache2/sites-available/000-default.conf

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

chmod +x /root/apache2.sh
chmod +x /root/php5-fpm.sh
