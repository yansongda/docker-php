FROM php:7.2.18-fpm

LABEL maintainer="yansongda <me@yansongda.cn>"

WORKDIR /www

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y libmcrypt-dev libmemcached-dev mcrypt libbz2-dev libpng-dev libjpeg-dev \
  && pecl install -o -f mongodb swoole redis mcrypt memcached \
  && docker-php-ext-enable mongodb swoole redis mcrypt memcached \
  && docker-php-ext-install bcmath opcache bz2 gd iconv mysqli pdo pdo_mysql zip \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/pear ~/.pearrc \
  && curl https://dl.laravel-china.org/composer.phar -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
  && composer config -g repo.packagist composer https://packagist.laravel-china.org \
  && composer selfupdate \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY sources.list /etc/apt/sources.list
COPY php.ini /usr/local/etc/php/conf.d/
