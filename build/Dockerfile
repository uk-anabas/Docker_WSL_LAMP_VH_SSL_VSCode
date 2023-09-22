FROM php:8.2-apache

RUN apt-get update \
    && apt-get install -y zlib1g-dev g++ git libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libicu-dev libonig-dev expect\
    && docker-php-ext-install pdo pdo_mysql mysqli iconv intl \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install sysvsem \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled \
    && /bin/sh -c a2enmod rewrite

RUN mkdir ssl
COPY openssl.exp ssl/
WORKDIR /var/www/html/ssl
RUN openssl genrsa 2048 > server.key
RUN expect openssl.exp
RUN ls -la
RUN openssl x509 -days 36500 -req -signkey server.key < server.csr > server.crt
WORKDIR /var/www/html
RUN cp ssl/server.crt /etc/ssl/certs/
RUN cp ssl/server.key /etc/ssl/private/
RUN sed -i -e 's/\/etc\/ssl\/certs\/ssl\-cert\-snakeoil\.pem/\/etc\/ssl\/certs\/server\.crt/' \
    -i -e 's/\/etc\/ssl\/private\/ssl\-cert\-snakeoil\.key/\/etc\/ssl\/private\/server\.key/' \
    /etc/apache2/sites-available/default-ssl.conf
RUN a2enmod ssl \
    && a2ensite default-ssl.conf

WORKDIR /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
