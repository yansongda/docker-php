FROM php:8.0-fpm-alpine3.15

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ=Asia/Shanghai
ENV DEPENDENCIES $PHPIZE_DEPS curl-dev openssl-dev pcre-dev pcre2-dev zlib-dev
ENV BUILD_DIR /www/build

# ENV for PHP
ENV PHP_DEPENDENCIES \
                    libmcrypt-dev rabbitmq-c-dev libpng-dev \
                    libwebp-dev libjpeg-turbo-dev libxpm-dev freetype-dev \
                    bzip2-dev libzip-dev
ENV PHP_EXT_PECL_INSTALL \
                    mongodb-1.13.0 redis-5.3.7 mcrypt-1.0.4 amqp-1.11.0
ENV PHP_EXT_SWOOLE_VERSION 4.8.10
ENV PHP_COMPOSER_URL https://getcomposer.org/composer-stable.phar
ENV PHP_COMPOSER_REPO https://mirrors.aliyun.com/composer/

COPY repositories /etc/apk/repositories
COPY php.ini /usr/local/etc/php/
COPY php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf

RUN apk add -U --no-cache --virtual .build-deps $DEPENDENCIES \
  && apk add -U --no-cache tzdata $PHP_DEPENDENCIES \
  && cp /usr/share/zoneinfo/$TZ /etc/localtime && date \
# INSTALL PHP EXT-SWOOLE
  && mkdir -p $BUILD_DIR && cd $BUILD_DIR \
  && curl -SL "https://github.com/swoole/swoole-src/archive/v${PHP_EXT_SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
  && ls -alh \
  && mkdir -p swoole \
  && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
  && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-openssl --enable-http2 --enable-swoole-json --enable-swoole-curl \
        && make -s -j$(nproc) && make install \
    ) \
# INSTALL PHP EXT
  && pecl install -o -f $PHP_EXT_PECL_INSTALL \
  && docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype \
  && docker-php-ext-install opcache bcmath bz2 gd mysqli pdo pdo_mysql zip sockets pcntl \
  && docker-php-ext-enable redis mongodb mcrypt amqp swoole \
  && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
  && composer config -g repo.packagist composer $PHP_COMPOSER_REPO \
# Clean
  && apk del .build-deps \
  && rm -rf /tmp/pear ~/.pearrc \
  && cd && rm -rf $BUILD_DIR

# After Build
WORKDIR /www

COPY repositories /etc/apk/repositories
COPY php.ini /usr/local/etc/php/
COPY php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf
