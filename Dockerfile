FROM debian:9
ADD ./docker-apt-get-install.sh /docker-apt-get-install.sh
ADD ./etc/apt/sources.list /etc/apt/sources.list

MAINTAINER wikitolearn sysadmin@wikitolearn.org
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN /docker-apt-get-install.sh zip
RUN /docker-apt-get-install.sh unzip
RUN /docker-apt-get-install.sh nano
RUN /docker-apt-get-install.sh curl
RUN /docker-apt-get-install.sh rsync
RUN /docker-apt-get-install.sh git

RUN /docker-apt-get-install.sh lsb-release

RUN /docker-apt-get-install.sh mariadb-client

RUN /docker-apt-get-install.sh imagemagick
RUN /docker-apt-get-install.sh inkscape
RUN /docker-apt-get-install.sh libicu-dev
RUN /docker-apt-get-install.sh python

RUN /docker-apt-get-install.sh supervisor

RUN /docker-apt-get-install.sh ssmtp && \
 sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf && sed -i '/hostname=/d' /etc/ssmtp/ssmtp.conf

RUN /docker-apt-get-install.sh logrotate
RUN /docker-apt-get-install.sh cron
RUN /docker-apt-get-install.sh anacron

RUN /docker-apt-get-install.sh nginx

RUN /docker-apt-get-install.sh binutils
RUN /docker-apt-get-install.sh lsof
RUN /docker-apt-get-install.sh mlock
RUN /docker-apt-get-install.sh libcurl4-openssl-dev
RUN /docker-apt-get-install.sh libzip4
RUN /docker-apt-get-install.sh libsnappy1v5
RUN /docker-apt-get-install.sh libtbb2
RUN /docker-apt-get-install.sh libmcrypt4
RUN /docker-apt-get-install.sh php-fpm
RUN /docker-apt-get-install.sh php-mysqlnd
RUN /docker-apt-get-install.sh php-mbstring
RUN /docker-apt-get-install.sh php-opcache
RUN /docker-apt-get-install.sh php-intl
RUN /docker-apt-get-install.sh php-apcu
RUN /docker-apt-get-install.sh php-xml

RUN rm /var/www/* -Rf

EXPOSE 80 443

ADD ./kickstart.sh /
ADD ./etc/ /etc/
ADD ./opt/ /opt/

RUN chmod +x /kickstart.sh

RUN ln -s /etc/nginx/sites-available/mediawiki /etc/nginx/sites-enabled/

RUN sed -i 's#;clear_env = no#clear_env = no#g' /etc/php/7.0/fpm/pool.d/www.conf

RUN mkdir /var/log/webserver/
RUN mkdir /var/log/mediawiki/
RUN chmod +x /opt/websrv-post-script.sh

RUN touch /var/log/php7.0-fpm.log
RUN chmod 777 /var/log/php7.0-fpm.log
RUN mkdir /run/php/

CMD ["/kickstart.sh"]

RUN mkdir /var/www/WikiToLearn
WORKDIR /var/www/WikiToLearn
