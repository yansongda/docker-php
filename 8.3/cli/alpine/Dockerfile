FROM php:8.3-cli-alpine

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ=Asia/Shanghai
ENV DEPENDENCIES $PHPIZE_DEPS curl-dev openssl-dev pcre-dev pcre2-dev zlib-dev
ENV BUILD_DIR /tmp

# ENV for PHP
ENV PHP_DEPENDENCIES \
                    libpng-dev libzip-dev freetype-dev \
                    libwebp-dev libjpeg-turbo-dev libxpm-dev \
                    bzip2-dev libstdc++ linux-headers
ENV PHP_EXT_PECL_INSTALL \
                    redis-6.0.2 xlswriter-1.5.5
ENV PHP_EXT_SWOOLE_VERSION 5.1.2
ENV PHP_COMPOSER_URL https://getcomposer.org/composer-stable.phar

# Prepare
RUN apk add -U --no-cache --virtual .build-deps $DEPENDENCIES \
  && apk add -U --no-cache tzdata $PHP_DEPENDENCIES \
  && pecl install -o -f $PHP_EXT_PECL_INSTALL \
# Swoole
  && mkdir -p $BUILD_DIR && cd $BUILD_DIR \
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
  && docker-php-ext-enable redis xlswriter swoole \
# Composer
  && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer \
# Clean
  && apk del .build-deps \
  && rm -rf /tmp/* ~/.pearrc /var/cache/apk/* \
  && cd && rm -rf $BUILD_DIR \
## For me
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
  && cp /usr/share/zoneinfo/$TZ /etc/localtime && date \
  && php --ri swoole && php --ri xlswriter

# After Build
WORKDIR /www

COPY php.ini /usr/local/etc/php/
