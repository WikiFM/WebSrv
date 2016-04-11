FROM debian:8
ADD ./sources.list /etc/apt/sources.list

MAINTAINER wikitolearn sysadmin@wikitolearn.org
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && apt-get -y install zip unzip nano apt-utils curl rsync git && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install imagemagick && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install inkscape && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install apache2 libapache2-mod-fastcgi && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install php5-mysql php5-fpm php5-apcu php5-curl libcurl4-openssl-dev && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install supervisor && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install ssmtp && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install cron && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete
RUN apt-get update && apt-get -y install libcurl4-openssl-dev && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN apt-get update && apt-get -y install logrotate && rm -f /var/cache/apt/archives/*deb && find /var/lib/apt/lists/ -type f -delete

RUN rm /var/www/* -Rf
RUN a2dissite 000-default.conf
RUN rm -f /etc/apache2/sites-available/000-default.conf

ADD ./apache2/common/WikiToLearn.conf /etc/apache2/common/WikiToLearn.conf
ADD ./apache2/common/www.WikiToLearn.org.conf /etc/apache2/common/www.WikiToLearn.org.conf
ADD ./apache2/common/ssl.conf /etc/apache2/common/ssl.conf
ADD ./apache2/common/cachedeflate.conf /etc/apache2/common/cachedeflate.conf
ADD ./apache2/mods-enabled/fastcgi.conf /etc/apache2/mods-enabled/fastcgi.conf
ADD ./apache2/sites-available/000-wikitolearn.org.conf /etc/apache2/sites-available/000-wikitolearn.org.conf
ADD ./apache2/sites-available/wikitolearn.org.conf /etc/apache2/sites-available/wikitolearn.org.conf

RUN a2ensite 000-wikitolearn.org.conf
RUN a2ensite wikitolearn.org.conf
RUN a2enmod deflate rewrite ssl actions remoteip headers

RUN sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf

EXPOSE 80 443

ADD ./kickstart.sh /
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./phpfpm.sh /phpfpm.sh

RUN chmod +x /kickstart.sh
RUN chmod +x /phpfpm.sh

RUN sed -i -e '/pm.max_children =/ s/= .*/= 500/' /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e '/upload_max_filesize =/ s/= .*/= 10M/' /etc/php5/fpm/php.ini
RUN sed -i -e '/post_max_size =/ s/= .*/= 32M/' /etc/php5/fpm/php.ini
RUN sed -i 's/^variables_order//g' /etc/php5/fpm/php.ini

ADD ./apache2.conf /etc/apache2/apache2.conf

CMD ["/kickstart.sh"]

WORKDIR /var/www/WikiToLearn
