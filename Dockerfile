FROM php:7.0-apache
MAINTAINER Frederik Vosberg <frederik.vosberg@diemedialen.de>

RUN apt-get update && apt-get install -y \
	vim \
	curl \
	git \
	unzip \
	graphicsmagick \
	wget \
	libpng3 \
	aptitude

RUN curl https://www.dotdeb.org/dotdeb.gpg | apt-key add -
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list


RUN apt-get update && apt-get install -y \
	php7.0-mysql \
	php7.0-bz2 \
	php7.0-curl \
	php7.0-opcache \
	php7.0-imagick \
	php7.0-xdebug \
	php7.0-gd

RUN pear install soap-beta

RUN echo "extension_dir=\"/usr/lib/php/20151012\"" >> /usr/local/etc/php/conf.d/php.ini
RUN ln -s /etc/php/mods-available/gd.ini /usr/local/etc/php/conf.d/
RUN ln -s /etc/php/mods-available/imagick.ini /usr/local/etc/php/conf.d/
RUN ln -s /etc/php/mods-available/mysqli.ini /usr/local/etc/php/conf.d/
RUN ln -s /etc/php/mods-available/opcache.ini /usr/local/etc/php/conf.d/
RUN ln -s /etc/php/mods-available/xdebug.ini /usr/local/etc/php/conf.d/


# RUN docker-php-ext-install -j$(nproc) 

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
VOLUME ["/var/log/apache2"]

# give the apache user the uid 1000 because new files in the mounted Volume gets 
# the owner uid 1000 and apache must be able to write to these folders
RUN usermod -u 1000 www-data

ADD apache-virtual-host.conf /etc/apache2/sites-available/typo3.conf
RUN a2ensite typo3
RUN ln -s ../mods-available/rewrite.load /etc/apache2/mods-enabled/
RUN ln -s ../mods-available/headers.load /etc/apache2/mods-enabled/
RUN ln -s ../mods-available/expires.load /etc/apache2/mods-enabled/

RUN echo 'alias ll="ls -lisah"' >> ~/.bashrc

RUN mkdir /app
WORKDIR /app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the composer.json as well as the composer.lock and install 
# the dependencies. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
#COPY composer.json composer.lock ./ 
#RUN composer install
