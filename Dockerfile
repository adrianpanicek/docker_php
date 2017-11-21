FROM php:7.1.11-alpine

# Setup environment variables
ENV APK_BRANCH_VERSION 3.6
ENV BASE_FOLDER /var/php
ENV PHPREDIS_VERSION 3.1.2
ENV COMPOSER_HOME /var/composer
ENV PATH "$COMPOSER_HOME/vendor/bin:$PATH"

# Update indexes of apk
RUN echo "" > /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v$APK_BRANCH_VERSION/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v$APK_BRANCH_VERSION/community" >> /etc/apk/repositories \
 && apk update

# Setup php.ini settings
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
 && echo "max_execution_time=-1" > $PHP_INI_DIR/conf.d/max_execution_time.ini

# Install required system packages
RUN apk --no-cache --update add curl git gcc openssh openssl zlib-dev autoconf tar openldap-dev alpine-sdk libxml2-dev

# Install php dependencies
RUN docker-php-ext-install pdo pdo_mysql ldap pcntl bcmath soap

# Pull and install php redis
RUN cd /tmp \
 && curl -L -o ./redis.tar.gz https://codeload.github.com/phpredis/phpredis/tar.gz/$PHPREDIS_VERSION#$RANDOM \
 && tar xfz redis.tar.gz \
 && rm -r redis.tar.gz \
 && mkdir -p /usr/src/php/ext \
 && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
 && docker-php-ext-install redis

# Install xDebug by pecl | Uncomment for xDebug compatibility
RUN pecl install xdebug-2.5.0

RUN docker-php-ext-enable xdebug

# Install RdKafka extension
RUN apk add librdkafka-dev pcre-dev

# Configure copy configuration files
COPY ./config $PHP_INI_DIR/conf.d

# Pull composer and install
RUN mkdir -p $COMPOSER_HOME \
 && chmod -R 777 $COMPOSER_HOME \
 && curl -sfLo /tmp/composer-setup.php https://getcomposer.org/installer \
 && curl -sfLo /tmp/composer-setup.sig https://composer.github.io/installer.sig \
 && php -r " \
    \$hash = hash('SHA384', file_get_contents('/tmp/composer-setup.php')); \
    \$signature = trim(file_get_contents('/tmp/composer-setup.sig')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/composer-setup.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/bin --filename=composer \
 && composer --no-interaction --no-ansi --version \
 && rm /tmp/composer-setup.php

# Set the working dir to
WORKDIR $BASE_FOLDER

# Copy source code into image
COPY . $BASE_FOLDER

# Testing building process
RUN php test.php && rm test.php