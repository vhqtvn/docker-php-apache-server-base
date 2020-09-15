FROM ubuntu:focal
LABEL maintainer="\"Hoa NV\" <hoanv@vzota.com.vn>"

ARG PHP_VERSION=7.4
ENV PHP_VERSION=${PHP_VERSION}

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /var/www

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

#install git
RUN apt-get update \
    && apt-get install -y git

#install apache2
RUN apt-get update \
    && apt-get install -y apache2

RUN apt-get update \
	&& apt-get install -y netcat

#install php
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
	curl \
	git \
	mercurial \
	python \
	python-setuptools \
	graphicsmagick \
	libgraphicsmagick++1-dev \
	libgraphicsmagick1-dev \
	graphicsmagick-imagemagick-compat \
	php${PHP_VERSION} \
	php${PHP_VERSION}-cli \
	libapache2-mod-php${PHP_VERSION} \
	php${PHP_VERSION}-dev \
	php${PHP_VERSION}-pgsql \
	php${PHP_VERSION}-sqlite \
	php-redis \
	php${PHP_VERSION}-json \
	php${PHP_VERSION}-zip \
	php${PHP_VERSION}-curl \
	php${PHP_VERSION}-soap \
	php${PHP_VERSION}-opcache \
	php${PHP_VERSION}-gd \
	php${PHP_VERSION}-fpm \
	php${PHP_VERSION}-gmp \
	php${PHP_VERSION}-dom \
	php${PHP_VERSION}-bcmath \
	php${PHP_VERSION}-mbstring \
	php${PHP_VERSION}-memcached \
	php${PHP_VERSION}-mysqli \
	php${PHP_VERSION}-pdo-mysql \
	php${PHP_VERSION}-intl \
	php${PHP_VERSION}-cli \
	php${PHP_VERSION}-xsl \
	php${PHP_VERSION}-pdo \
	php${PHP_VERSION}-pdo-pgsql

# Install MySQL CLI Client
RUN apt-get update \
    && apt-get install -y mysql-client

# Install mongo
RUN apt-get update && \
    apt-get dist-upgrade -y && \
	pecl install mongodb && \
    echo "extension=mongodb.so" >> /etc/php/7.4/apache2/php.ini && \
    echo "extension=mongodb.so" >> /etc/php/7.4/cli/php.ini


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

ENV XDEBUG_ENABLE 0

# Define PHP_TIMEZONE env variable
ENV PHP_TIMEZONE GMT

# Configure Apache Document Root
ENV APACHE_DOC_ROOT /app/public

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Additional PHP ini configuration
COPY ./files/999-php.ini /usr/local/etc/php/conf.d/
COPY ./files/999-php.ini /etc/php/${PHP_VERSION}/apache2/conf.d/
COPY ./files/999-php.ini /etc/php/${PHP_VERSION}/cli/conf.d/
COPY ./files/index.php /app/public/index.php
COPY ./files/start /usr/local/bin/
COPY ./files/apache2-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-foreground

EXPOSE 80

ENV DEBIAN_FRONTEND teletype

#DEPLOY-PART

# Start!
CMD ["start"]