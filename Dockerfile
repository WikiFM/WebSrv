FROM debian
MAINTAINER wikitolearn sysadmin@wikitolearn.org
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get update
RUN apt-get -y install zip unzip nano apt-utils curl rsync git && rm -f /var/cache/apt/archives/*deb

ADD ./sources.list /etc/apt/
ADD ./apache2.sh /root/
ADD ./php5-fpm.sh /root/

RUN apt-get update
RUN apt-get -y install ocaml-nox && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install apache2 && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install php5-fpm && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install libapache2-mod-fastcgi && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install supervisor && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install php5-apcu && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install php5-mysql && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install bindfs && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install build-essential && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install ssmtp && rm -f /var/cache/apt/archives/*deb
RUN apt-get -y install imagemagick && rm -f /var/cache/apt/archives/*deb
RUN apt-get clean

RUN a2enmod rewrite ssl actions
RUN rm /var/www/* -Rf
RUN a2dissite 000-default.conf
RUN rm -f /etc/apache2/sites-available/000-default.conf
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN chmod +x /root/apache2.sh
RUN chmod +x /root/php5-fpm.sh

ADD ./apache2/common/WikiToLearn.conf /etc/apache2/common/WikiToLearn.conf
ADD ./apache2/common/www.WikiToLearn.org.conf /etc/apache2/common/www.WikiToLearn.org.conf
ADD ./apache2/common/ssl.conf /etc/apache2/common/ssl.conf
ADD ./apache2/mods-enabled/fastcgi.conf /etc/apache2/mods-enabled/fastcgi.conf
ADD ./apache2/sites-available/fr.wikitolearn.org.conf /etc/apache2/sites-available/fr.wikitolearn.org.conf
ADD ./apache2/sites-available/de.wikitolearn.org.conf /etc/apache2/sites-available/de.wikitolearn.org.conf
ADD ./apache2/sites-available/project.wikitolearn.org.conf /etc/apache2/sites-available/project.wikitolearn.org.conf
ADD ./apache2/sites-available/pool.wikitolearn.org.conf /etc/apache2/sites-available/pool.wikitolearn.org.conf
ADD ./apache2/sites-available/it.wikitolearn.org.conf /etc/apache2/sites-available/it.wikitolearn.org.conf
ADD ./apache2/sites-available/es.wikitolearn.org.conf /etc/apache2/sites-available/es.wikitolearn.org.conf
ADD ./apache2/sites-available/000-wikitolearn.org.conf /etc/apache2/sites-available/000-wikitolearn.org.conf
ADD ./apache2/sites-available/en.wikitolearn.org.conf /etc/apache2/sites-available/en.wikitolearn.org.conf
ADD ./apache2/sites-available/aliases.conf /etc/apache2/sites-available/aliases.conf
ADD ./apache2/sites-available/pt.wikitolearn.org.conf /etc/apache2/sites-available/pt.wikitolearn.org.conf
ADD ./apache2/sites-available/sv.wikitolearn.org.conf /etc/apache2/sites-available/sv.wikitolearn.org.conf

RUN a2ensite 000-wikitolearn.org.conf
RUN a2ensite de.wikitolearn.org.conf
RUN a2ensite en.wikitolearn.org.conf
RUN a2ensite es.wikitolearn.org.conf
RUN a2ensite fr.wikitolearn.org.conf
RUN a2ensite it.wikitolearn.org.conf
RUN a2ensite pool.wikitolearn.org.conf
RUN a2ensite project.wikitolearn.org.conf
RUN a2ensite pt.wikitolearn.org.conf
RUN a2ensite sv.wikitolearn.org.conf
RUN a2ensite aliases.conf

RUN sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf

EXPOSE 80
EXPOSE 443

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
