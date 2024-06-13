# Enable plugin
```
sed -i 's/<\!--pluginsdir>\/kohadevbox\/koha_plugin<\/pluginsdir-->/<pluginsdir>\/kohadevbox\/koha_plugin<\/pluginsdir>/g' /etc/koha/sites/kohadev/koha-conf.xml
```

```
perl /kohadevbox/koha/misc/devel/install_plugins.pl
```

# Apache config updates

etc/apache2/sites-available/kohadev.conf
```
   ScriptAlias /acquisitions "/kohadevbox/plugins/koha-plugin-acq2/Koha/Plugin/Acquire/views/acquisitions.pl"
   Alias /plugin “/var/lib/koha/kohadev/plugins"
```

/etc/apache2/apache2.conf
```
<Directory /kohadevbox/plugins>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```

/etc/koha/apache-shared-intranet-git.conf
(Already included on development branch - acq2.0 in PTFS Europe/Koha)
```
RewriteRule ^/cgi-bin/koha/acqui/.*$ /acquisitions [PT]
```

If needed then chmod +x acquisitions.pl

# Production apache config
etc/apache2/sites-available/kohadev.conf
```
   ScriptAlias /acquisitions "/var/lib/koha/INSTANCE/plugins/Koha/Plugin/Acquire/views/acquisitions.pl"
   Alias /plugin “/var/lib/koha/INSTANCE/plugins"
```

/etc/apache2/apache2.conf
```
<Directory /var/lib/koha/INSTANCE/plugins>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```