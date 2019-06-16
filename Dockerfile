FROM php:7.1.30-fpm

LABEL maintainer="yansongda <me@yansongda.cn>"

WORKDIR /www

ENV TZ=Asia/Shanghai
ENV DEPENDENCIES curl gnupg git wget gcc
ENV PHP_DEPENDENCIES \
                    libwebp-dev libmcrypt-dev libmemcached-dev libbz2-dev libpng-dev \
                    libxpm-dev librabbitmq-dev libfreetype6-dev libjpeg-dev libssh-dev \
ENV PHP_EXT_INSTALLED \
                    mongodb swoole redis memcached mcrypt amqp
ENV PHP_COMPOSER_URL https://dl.laravel-china.org/composer.phar
ENV PHP_COMPOSER_REPO https://packagist.laravel-china.org

RUN apt-get update \
  && apt-get install -y $PHP_DEPENDENCIES $DEPENDENCIES \
  && pecl install -o -f $PHP_EXT_INSTALLED \
  && docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
      --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
  && docker-php-ext-install opcache bcmath bz2 gd iconv mysqli pdo pdo_mysql zip sockets \
  && docker-php-ext-enable opcache redis memcached mongodb swoole mcrypt amqp \
  && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
  && composer config -g repo.packagist composer $PHP_COMPOSER_REPO

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get -y remove $DEPENDENCIES \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/pear ~/.pearrc

COPY sources.list /etc/apt/sources.list
COPY php.ini /usr/local/etc/php/conf.d/
