# MySQL

|HOST|db|
|USER|dev|
|PASSWORD|dev|
|DATABASE|dev|

# TYPO3 Environments

If the hostname ends on production the TYPO3_CONTEXT is set to Production/Docker.
Otherwise it is Development/Docker

# Introduction package

If you just want to develop an extension or tinker a little bit around install the introduction package to have a nice point to start from.

	composer require 'typo3-ter/introduction'

# TODO

0. Gulp
0. Sitepacke inkludieren
0. Failed loading /usr/lib/php/20151012/opcache.so:  /usr/lib/php/20151012/opcache.so: undefined symbol: pcre_free
0. "PHP extension soap not loaded" in TYPO3 Install Tool
0. "PHP extension zip not loaded" in TYPO3 Install Tool

# MySQL debug

If you want to debug your MySQL database you can add the following to your docker-compose.yml to expose the port 3306

    db:
        image: mysql
        ports:
          - "3306:3306"
        environment:
            - MYSQL_RANDOM_ROOT_PASSWORD=yes
            - MYSQL_DATABASE=dev
            - MYSQL_USER=dev
            - MYSQL_PASSWORD=dev

After that you have to recreate your db container. Now you can access the db with the provided credentials on port 3306. To get the IP just execute

    docker-machine ip <machine-name>
