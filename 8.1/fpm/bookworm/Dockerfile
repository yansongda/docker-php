FROM php:8.1-fpm-bookworm

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ=Asia/Shanghai
ENV DEPENDENCIES gnupg git gcc g++
ENV WORKING_DIR /tmp

# ENV for PHP
ENV PHP_DEPENDENCIES \
                    curl wget unzip libcurl4-openssl-dev libwebp-dev \
                    libbz2-dev libpng-dev libxpm-dev librabbitmq-dev \
                    libfreetype6-dev libjpeg-dev libssh-dev libzip-dev
ENV PHP_EXT_INSTALLED_PECL \
                    redis-6.0.2 xlswriter-1.5.5 mongodb-1.16.2 amqp-2.1.1
ENV PHP_EXT_SWOOLE_VERSION 5.1.3
ENV PHP_COMPOSER_URL https://getcomposer.org/composer-stable.phar

# Prepare
RUN apt-get update \
  && apt-get install -y $PHP_DEPENDENCIES $DEPENDENCIES \
  && pecl install -o -f $PHP_EXT_INSTALLED_PECL \
# Swoole
  && mkdir -p $WORKING_DIR && cd $WORKING_DIR \
  && curl -SL "https://github.com/swoole/swoole-src/archive/v${PHP_EXT_SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
  && ls -alh \
  && mkdir -p swoole \
  && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
  && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-openssl --enable-swoole-curl \
        && make -s -j$(nproc) && make install \
    ) \
# Extentions
  && docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype \
  && docker-php-ext-install opcache bcmath bz2 gd mysqli pdo pdo_mysql zip sockets pcntl \
  && docker-php-ext-enable opcache mongodb redis amqp xlswriter swoole \
# Composer
  && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
# Clean
  && apt-get -y remove $DEPENDENCIES \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/* /tmp/pear ~/.pearrc && cd $WORKING_DIR && cd .. && rm -rf $WORKING_DIR \
# For me
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && php --ri swoole && php --ri xlswriter

# After Build
WORKDIR /www

COPY ./bookworm/sources.list /etc/apt/sources.list
COPY php.ini /usr/local/etc/php/
COPY php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf
