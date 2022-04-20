FROM php:7.4-fpm-bullseye

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ=Asia/Shanghai
ENV DEPENDENCIES gnupg git gcc g++
ENV WORKING_DIR /www/software

# ENV for PHP
ENV PHP_DEPENDENCIES \
                    curl wget unzip libcurl4-openssl-dev libwebp-dev libmcrypt-dev \
                    libbz2-dev libpng-dev libxpm-dev librabbitmq-dev librdkafka-dev \
                    libfreetype6-dev libjpeg-dev libssh-dev libzip-dev
ENV PHP_EXT_INSTALLED_PECL \
                    mongodb-1.13.0 redis-5.3.7 mcrypt-1.0.4 amqp-1.11.0 rdkafka-5.0.2
ENV PHP_EXT_SWOOLE_VERSION 4.8.9
ENV PHP_COMPOSER_URL https://getcomposer.org/composer-stable.phar
ENV PHP_COMPOSER_REPO https://mirrors.aliyun.com/composer/

# INSTALL PHP
RUN apt-get update \
  && apt-get install -y $PHP_DEPENDENCIES $DEPENDENCIES \
# INSTALL PHP EXT-SWOOLE
  && mkdir -p $WORKING_DIR && cd $WORKING_DIR \
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
  && pecl install -o -f $PHP_EXT_INSTALLED_PECL \
  && docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype \
  && docker-php-ext-install opcache bcmath bz2 gd mysqli pdo pdo_mysql zip sockets pcntl \
  && docker-php-ext-enable opcache redis mongodb mcrypt amqp swoole rdkafka \
  && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
  && composer config -g repo.packagist composer $PHP_COMPOSER_REPO \
# CLEAN
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get -y remove $DEPENDENCIES \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/pear ~/.pearrc \
  && cd $WORKING_DIR && cd .. && rm -rf $WORKING_DIR

# After Build
WORKDIR /www

COPY sources.list /etc/apt/sources.list
COPY php.ini /usr/local/etc/php/
COPY php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf
