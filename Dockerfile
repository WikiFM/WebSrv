FROM debian:8
ADD ./sources.list /etc/apt/sources.list

MAINTAINER wikitolearn sysadmin@wikitolearn.org
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && apt-get -y install zip unzip nano apt-utils curl rsync git && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN curl -O http://repo.mysql.com/mysql-apt-config_0.1.5-1debian7_all.deb && dpkg -i mysql-apt-config_0.1.5-1debian7_all.deb && rm -v mysql-apt-config_0.1.5-1debian7_all.deb && apt-get update && apt-get -y install mysql-client && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install imagemagick && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install inkscape && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install nginx && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN curl -sSL http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
RUN apt-get update && apt-get -y install hhvm && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
# RUN apt-get update && apt-get -y install php5-mysqlnd php5-fpm php5-apcu php5-curl libcurl4-openssl-dev && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install supervisor && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install ssmtp && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install cron && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install libcurl4-openssl-dev && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install logrotate && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN rm /var/www/* -Rf

RUN sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf
RUN sed -i '/hostname=/d' /etc/ssmtp/ssmtp.conf

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

CMD ["/kickstart.sh"]

RUN mkdir /var/www/WikiToLearn
WORKDIR /var/www/WikiToLearn
