FROM php:7.4.5-fpm

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ=Asia/Shanghai
ENV DEPENDENCIES gnupg git gcc g++
ENV WORKING_DIR /www/software

# ENV for PHP
ENV PHP_DEPENDENCIES \
                    curl wget unzip libcurl4-openssl-dev libwebp-dev libmcrypt-dev \
                    libmemcached-dev libbz2-dev libpng-dev libxpm-dev librabbitmq-dev \
                    libfreetype6-dev libjpeg-dev libssh-dev libzip-dev
ENV PHP_EXT_INSTALLED_PECL \
                    mongodb-1.7.4 redis-5.2.2 memcached-3.1.5 mcrypt-1.0.3 amqp-1.10.2
ENV PHP_EXT_SWOOLE_VERSION 4.5.1
ENV PHP_COMPOSER_URL https://getcomposer.org/composer.phar
ENV PHP_COMPOSER_REPO https://mirrors.aliyun.com/composer/

# INSTALL PHP
RUN apt update \
  && apt install -y $PHP_DEPENDENCIES $DEPENDENCIES \
# INSTALL PHP EXT-SWOOLE
  && mkdir -p $WORKING_DIR && cd $WORKING_DIR \
  && curl -SL "https://github.com/swoole/swoole-src/archive/v${PHP_EXT_SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
  && ls -alh \
  && mkdir -p swoole \
  && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
  && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-mysqlnd --enable-openssl --enable-http2 \
        && make -s -j$(nproc) && make install \
    ) \
# INSTALL PHP EXT
  && pecl install -o -f $PHP_EXT_INSTALLED_PECL \
  && docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
      --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
  && docker-php-ext-install opcache bcmath bz2 gd iconv mysqli pdo pdo_mysql zip sockets \
  && docker-php-ext-enable opcache redis memcached mongodb mcrypt amqp swoole \
  && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
  && composer config -g repo.packagist composer $PHP_COMPOSER_REPO \
# CLEAN
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt -y remove $DEPENDENCIES \
  && apt purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/pear ~/.pearrc \
  && cd $WORKING_DIR && cd .. && rm -rf $WORKING_DIR

# After Build
WORKDIR /www

COPY sources.list /etc/apt/sources.list
COPY php.ini /usr/local/etc/php/
COPY php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf
