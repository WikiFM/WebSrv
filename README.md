# WebSrv
To add a language or a vh you must to add in apache2/sites-available/ dir a file named "[langcode].wikifm.org.conf" and add to abilita_sites.sh file a line "a2ensite [langcode].wikifm.org.conf"
###### Example content for "[langcode].wikifm.org.conf" is:
```
<VirtualHost *:80>
	ServerAdmin  webmaster@kde.org
	ServerName   [langcode].wikifm.org
	ServerAlias  [langcode].direct.wikifm.org

	ErrorLog ${APACHE_LOG_DIR}/[langcode].wikifm.org-error.log
	CustomLog ${APACHE_LOG_DIR}/[langcode].wikifm.org.log combined

	Include /etc/apache2/common/WikiFM.conf
</VirtualHost>
<VirtualHost *:443>
        ServerAdmin  webmaster@kde.org
        ServerName   [langcode].wikifm.org
        ServerAlias  [langcode].direct.wikifm.org

        ErrorLog ${APACHE_LOG_DIR}/[langcode].wikifm.org-error.log
        CustomLog ${APACHE_LOG_DIR}/[langcode].wikifm.org.log combined

        Include /etc/apache2/common/WikiFM.conf
        Include /etc/apache2/common/ssl.conf   
</VirtualHost>
```
