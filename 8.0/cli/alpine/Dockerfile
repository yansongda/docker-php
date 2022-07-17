FROM alpine:3.15

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ=Asia/Shanghai
ENV DEPENDENCIES="autoconf dpkg-dev dpkg file g++ gcc libc-dev make php8-dev php8-pear pkgconf re2c pcre-dev pcre2-dev zlib-dev libtool automake libaio-dev openssl-dev curl-dev"

# ENV for PHP
ENV PHP_DEPENDENCIES libstdc++
ENV PHP_EXT_PECL_INSTALL xlswriter-1.5.2
ENV PHP_EXT_SWOOLE_VERSION 4.8.11
ENV PHP_COMPOSER_URL https://getcomposer.org/composer-stable.phar
ENV PHP_COMPOSER_REPO https://mirrors.aliyun.com/composer/

ADD https://php.hernandev.com/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN set -ex \
# PHP
    && echo "https://php.hernandev.com/v3.15/php-8.0" >> /etc/apk/repositories \
    && echo "@php https://php.hernandev.com/v3.15/php-8.0" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    # Install base packages ('ca-certificates' will install 'nghttp2-libs')
    ca-certificates \
    curl \
    wget \
    tar \
    xz \
    libressl \
    tzdata \
    pcre \
    php8 \
    php8-bcmath \
    php8-curl \
    php8-ctype \
    php8-dom \
    php8-gd \
    php8-iconv \
    php8-mbstring \
    php8-mysqlnd \
    php8-openssl \
    php8-pdo \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-phar \
    php8-posix \
    php8-redis \
    php8-sockets \
    php8-sodium \
    php8-zip \
    php8-zlib \
    php8-xml \
    php8-xmlreader \
    php8-bz2 \
    php8-pecl-mcrypt \
    php8-pcntl \
    php8-opcache \
    && ln -sf /usr/bin/php8 /usr/bin/php \
    && php -v \
    && php -m \
# PHP ext
    && apk add -U --no-cache --virtual .build-deps $DEPENDENCIES \
    && apk add -U --no-cache tzdata $PHP_DEPENDENCIES \
    && ln -s /usr/bin/pecl8 /usr/local/bin/pecl \
    && pecl install ${PHP_EXT_PECL_INSTALL} \
# PHP ext-swoole
    && cd /tmp \
    && curl -SL "https://github.com/swoole/swoole-src/archive/${PHP_EXT_SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
    && ls -alh \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && ln -s /usr/bin/phpize8 /usr/local/bin/phpize \
    && ln -s /usr/bin/php-config8 /usr/local/bin/php-config \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-openssl --enable-http2 --enable-swoole-curl --enable-swoole-json \
        && make -s -j$(nproc) && make install \
    ) \
    && echo "opcache.enable_cli = 'On'" >> /etc/php8/conf.d/00_opcache.ini \
    && echo "extension=swoole.so" > /etc/php8/conf.d/50_swoole.ini \
    && php --ri swoole \
    && php --ri Zend\ OPcache \
# PHP ext-xlswriter
    && echo "extension=xlswriter.so" > /etc/php8/conf.d/50_xlswriter.ini \
    && php --ri xlswriter \
# Composer 
    && curl $PHP_COMPOSER_URL -o /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer \
    && composer config -g repo.packagist composer $PHP_COMPOSER_REPO \
# For me
    && cp /usr/share/zoneinfo/$TZ /etc/localtime && date \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
# Clean
    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php8

# After Build
WORKDIR /www
