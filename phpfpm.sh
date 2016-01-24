#!/bin/bash
rm -f /var/run/php5-fpm.*
/usr/sbin/php5-fpm -c /etc/php5/fpm
