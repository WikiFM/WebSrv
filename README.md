# WebSrv
To add a language or a vh you must to add in apache2/sites-available/ dir a file named "[langcode].wikitolearn.org.conf" and add to abilita_sites.sh file a line "a2ensite [langcode].wikitolearn.org.conf"
###### Example content for "[langcode].wikitolearn.org.conf" is:
```
<VirtualHost *:80>
	ServerAdmin  webmaster@kde.org
	ServerName   [langcode].wikitolearn.org
	ServerAlias  [langcode].direct.wikitolearn.org

	ErrorLog ${APACHE_LOG_DIR}/[langcode].wikitolearn.org-error.log
	CustomLog ${APACHE_LOG_DIR}/[langcode].wikitolearn.org.log combined

	Include /etc/apache2/common/wikitolearn.conf
</VirtualHost>
<VirtualHost *:443>
        ServerAdmin  webmaster@kde.org
        ServerName   [langcode].wikitolearn.org
        ServerAlias  [langcode].direct.wikitolearn.org

        ErrorLog ${APACHE_LOG_DIR}/[langcode].wikitolearn.org-error.log
        CustomLog ${APACHE_LOG_DIR}/[langcode].wikitolearn.org.log combined

        Include /etc/apache2/common/wikitolearn.conf
        Include /etc/apache2/common/ssl.conf   
</VirtualHost>
```
You also must add a line like
```
RUN a2ensite [langcode].wikitolearn.org.conf
```
and another like
```
ADD ./apache2/sites-available/[langcode].wikitolearn.org.conf /etc/apache2/sites-available/[langcode].wikitolearn.org.conf
```
in Dockerfile file
