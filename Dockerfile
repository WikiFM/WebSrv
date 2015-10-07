FROM debian
MAINTAINER wikitolearn sysadmin@wikitolearn.org
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get update
RUN apt-get -y install zip unzip nano apt-utils curl rsync git && rm -f /var/cache/apt/archives/*deb

ADD ./sources.list /etc/apt/

RUN apt-get update
RUN apt-get -y install ocaml-nox && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install apache2 && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install php5-fpm && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install libapache2-mod-fastcgi && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install supervisor && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install php5-apcu && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install php5-mysql && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install build-essential && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install ssmtp && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install imagemagick && rm -f /var/cache/apt/archives/*deb
RUN apt-get clean

RUN rm /var/www/* -Rf
RUN a2dissite 000-default.conf
RUN rm -f /etc/apache2/sites-available/000-default.conf
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

ADD ./apache2/common/WikiToLearn.conf /etc/apache2/common/WikiToLearn.conf
ADD ./apache2/common/www.WikiToLearn.org.conf /etc/apache2/common/www.WikiToLearn.org.conf
ADD ./apache2/common/ssl.conf /etc/apache2/common/ssl.conf
ADD ./apache2/mods-enabled/fastcgi.conf /etc/apache2/mods-enabled/fastcgi.conf
ADD ./apache2/sites-available/000-wikitolearn.org.conf /etc/apache2/sites-available/000-wikitolearn.org.conf
ADD ./apache2/sites-available/wikitolearn.org.conf /etc/apache2/sites-available/wikitolearn.org.conf
ADD ./apache2/sites-available/zzz-aliases.conf /etc/apache2/sites-available/zzz-aliases.conf

RUN a2ensite 000-wikitolearn.org.conf
RUN a2ensite wikitolearn.org.conf
RUN a2ensite zzz-aliases.conf
RUN a2enmod deflate rewrite ssl actions

RUN sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf

EXPOSE 80 443

ADD ./kickstart.sh /
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /kickstart.sh

RUN sed -i -e '/pm.max_children =/ s/= .*/= 500/' /etc/php5/fpm/pool.d/www.conf

CMD ["/kickstart.sh"]
