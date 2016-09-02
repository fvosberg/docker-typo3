FROM php:7.0-apache
MAINTAINER Frederik Vosberg <frederik@rattazonk.com>

# needed for virtual machine configuration
ENV APACHE_LOG_DIR /var/log/apache2

RUN apt-get update && apt-get install -y \
	vim \
	curl \
	git \
	wget \
	aptitude

RUN apt-get install -y \
	libcurl3-dev \
	libxml2-dev \
	libbz2-dev \
	zlib1g-dev

RUN docker-php-ext-install bcmath mbstring mysqli soap bz2 zip

RUN apt-get install -y \
	graphicsmagick \
	libpng3 \
	libfreetype6-dev \
	libjpeg62-turbo-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install xdebug \
	&& docker-php-ext-enable xdebug
RUN docker-php-ext-install opcache

RUN mkdir /var/log/php
RUN chmod go+w /var/log/php

RUN echo 'xdebug.max_nesting_level=400' >> /usr/local/etc/php/php.ini
RUN echo 'max_input_vars=1500' >> /usr/local/etc/php/php.ini
RUN echo 'max_execution_time=240' >> /usr/local/etc/php/php.ini
RUN echo 'error_log=/var/log/php/errors.log' >> /usr/local/etc/php/php.ini
RUN echo 'log_errors=On' >> /usr/local/etc/php/php.ini
RUN echo 'error_reporting=E_ALL' >> /usr/local/etc/php/php.ini
RUN echo 'session.save_path=/tmp' >> /usr/local/etc/php/php.ini
RUN echo 'date.timezone=Europe/Berlin' >> /usr/local/etc/php/php.ini

#ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["apache2-foreground"]
VOLUME ["/var/log/apache2"]

# give the apache user the uid 1000 because new files in the mounted Volume gets
# the owner uid 1000 and apache must be able to write to these folders
RUN usermod -u 1000 www-data

RUN rm /etc/apache2/sites-available/*
ADD apache-virtual-host.conf /etc/apache2/sites-available/typo3.conf
RUN a2ensite typo3
RUN a2dissite 000-default
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod expires

RUN echo 'alias ll="ls -lisah"' >> ~/.bashrc

RUN mkdir /app
WORKDIR /app

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
