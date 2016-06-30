FROM debian:8
ADD ./docker-apt-get-install.sh /docker-apt-get-install.sh
ADD ./sources.list /etc/apt/sources.list

MAINTAINER wikitolearn sysadmin@wikitolearn.org
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN /docker-apt-get-install.sh zip
RUN /docker-apt-get-install.sh unzip
RUN /docker-apt-get-install.sh nano
RUN /docker-apt-get-install.sh apt-utils
RUN /docker-apt-get-install.sh curl
RUN /docker-apt-get-install.sh rsync
RUN /docker-apt-get-install.sh git

RUN /docker-apt-get-install.sh lsb-release

RUN echo mysql-apt-config mysql-apt-config/enable-repo select mysql-5.7-dmr | debconf-set-selections ; \
 curl -O http://repo.mysql.com/mysql-apt-config_0.3.5-1debian8_all.deb && \
 dpkg -i mysql-apt-config* && \
 rm -v mysql-apt-config* && \
 apt-get update && \
 /docker-apt-get-install.sh mysql-apt-config && \
 apt-get update && \
 /docker-apt-get-install.sh mysql-community-client

RUN /docker-apt-get-install.sh imagemagick
RUN /docker-apt-get-install.sh inkscape

RUN /docker-apt-get-install.sh nginx
RUN curl -sSL http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
RUN /docker-apt-get-install.sh hhvm

RUN /docker-apt-get-install.sh supervisor

RUN /docker-apt-get-install.sh ssmtp && \
 sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf && sed -i '/hostname=/d' /etc/ssmtp/ssmtp.conf
RUN /docker-apt-get-install.sh cron
RUN /docker-apt-get-install.sh libcurl4-openssl-dev

RUN /docker-apt-get-install.sh logrotate

RUN rm /var/www/* -Rf

EXPOSE 80 443

ADD ./kickstart.sh /
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /kickstart.sh

ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/snippets/wikitolearn-certs.conf /etc/nginx/snippets/wikitolearn-certs.conf
ADD ./nginx/sites-available/default /etc/nginx/sites-available/default
ADD ./nginx/sites-available/mediawiki /etc/nginx/sites-available/mediawiki
RUN sed -i 's/server_name/host/g' /etc/nginx/fastcgi_params # fix the hostname in nginx

ADD ./hhvm/server.ini /etc/hhvm/server.ini
ADD ./hhvm/php.ini    /etc/hhvm/php.ini

RUN ln -s /etc/nginx/sites-available/mediawiki /etc/nginx/sites-enabled/

RUN mkdir /var/log/webserver/

ADD ./logrotate/websrv  /etc/logrotate.d/
ADD ./logrotate/websrv-post-script.sh /websrv-post-script.sh
RUN chmod +x /websrv-post-script.sh

CMD ["/kickstart.sh"]

RUN mkdir /var/www/WikiToLearn
WORKDIR /var/www/WikiToLearn
