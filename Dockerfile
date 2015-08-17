FROM        debian

MAINTAINER wikitolearn sysadmin@wikitolearn.org

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ADD ./sources.list /etc/apt/
ADD ./apt.conf /etc/apt/

ADD ./initDocker.sh /root/

ADD ./abilita_sites.sh /root/
ADD ./apache2.sh /root/
ADD ./php5-fpm.sh /root/

RUN /bin/chmod +x /root/initDocker.sh
RUN /root/initDocker.sh
RUN rm /root/initDocker.sh

ADD ./apache2/common/wikitolearn.conf /etc/apache2/common/wikitolearn.conf
ADD ./apache2/common/www.wikitolearn.org.conf /etc/apache2/common/www.wikitolearn.org.conf
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

RUN /bin/chmod +x /root/abilita_sites.sh
RUN /root/abilita_sites.sh
RUN rm /root/abilita_sites.sh

EXPOSE 80
EXPOSE 443

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
