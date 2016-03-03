FROM php:7.0-apache
MAINTAINER Frederik Vosberg <frederik.vosberg@diemedialen.de>

RUN apt-get update && apt-get install -y \
	vim \
	curl \
	git \
	unzip

RUN docker-php-ext-install -j$(nproc) iconv

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
VOLUME ["/var/log/apache2"]

ADD docker/apache.conf /etc/apache2/sites-available/typo3.conf
RUN a2ensite typo3
RUN touch /etc/apache2/iwashere

RUN echo 'alias ll="ls -lisah"' >> ~/.bashrc

RUN mkdir /app
ADD . /app
WORKDIR /app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy the composer.json as well as the composer.lock and install 
# the dependencies. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
#COPY composer.json composer.lock ./ 
#RUN composer install
