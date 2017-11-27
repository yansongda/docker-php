FROM php:fpm
MAINTAINER yansongda <me@yansongda.cn>

WORKDIR /www

COPY sources.list /etc/apt/sources.list
COPY php.ini /usr/local/etc/php/conf.d/

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libbz2-dev libmcrypt-dev libmemcached-dev libssh-dev \
  && pecl install -o -f mongodb swoole redis memcached \
  && docker-php-ext-install opcache bcmath bz2 gd iconv mcrypt mysqli pdo pdo_mysql zip \
  && docker-php-ext-enable opcache redis memcached mongodb swoole \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/pear \
  && curl https://dl.laravel-china.org/composer.phar -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
  && composer config -g repo.packagist composer https://packagist.phpcomposer.com