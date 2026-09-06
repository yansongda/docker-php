ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-cli-alpine AS builder

LABEL maintainer="yansongda <me@yansongda.cn>"

# ENV for Global
ENV TZ="Asia/Shanghai"

# ENV for PHP
ENV PHP_EXT_PECL_INSTALL="redis-6.3.0 xlswriter-3.0.0"
ENV PHP_EXT_SWOOLE_VERSION="6.2.2"
ENV COMPOSER_VERSION="2.10.3"
ENV PIE_VERSION="1.4.10"

# Dependencies (build-only, dropped in the final image)
# NOTE: c-ares-dev is installed explicitly and not relied upon transitively
# via curl-dev.
RUN apk add -U --no-cache \
      $PHPIZE_DEPS \
      curl-dev openssl-dev pcre-dev pcre2-dev zlib-dev c-ares-dev \
      libpng-dev libzip-dev freetype-dev libwebp-dev libjpeg-turbo-dev \
      libxpm-dev bzip2-dev libssh2-dev linux-headers \
  && pecl install -o -f $PHP_EXT_PECL_INSTALL

# Swoole
RUN curl -fSL "https://github.com/swoole/swoole-src/archive/v${PHP_EXT_SWOOLE_VERSION}.tar.gz" -o /tmp/swoole.tar.gz \
  && mkdir -p /tmp/swoole \
  && tar -xf /tmp/swoole.tar.gz -C /tmp/swoole --strip-components=1 \
  && ( \
        cd /tmp/swoole \
        && phpize \
        && ./configure --enable-swoole-curl --enable-cares --enable-swoole-ftp --with-swoole-ssh2 \
        && make -s -j$(nproc) && make install \
    )

# Extentions
# NOTE: since PHP 8.5.0, opcache is built into the PHP binary and no longer
# produces a loadable .so module (php/php-src#20557), so it is neither
# installed nor enabled there.
# NOTE: the official images set ENV PHP_VERSION=<full version> (e.g. 8.5.10),
# which shadows the ARG inside RUN; derive the branch version from PHP itself.
RUN docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype \
  && PHP_VERSION_MAIN=$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;') \
  && case "$PHP_VERSION_MAIN" in 8.5) OPCACHE="";; *) OPCACHE="opcache";; esac \
  && docker-php-ext-install $OPCACHE bcmath bz2 gd mysqli pdo pdo_mysql zip sockets pcntl \
  && docker-php-ext-enable redis xlswriter swoole \
  && if [ -n "$OPCACHE" ]; then docker-php-ext-enable opcache; fi

# Composer
# (pinned & sha256-verified; no runtime pecl/pie compile capability is kept)
RUN curl -fSL "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" -o /usr/local/bin/composer \
  && curl -fSL "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar.sha256sum" -o /tmp/composer.phar.sha256sum \
  && sed -i 's|composer.phar|/usr/local/bin/composer|' /tmp/composer.phar.sha256sum \
  && sha256sum -c /tmp/composer.phar.sha256sum \
  && chmod a+x /usr/local/bin/composer \
  && curl -fSL "https://github.com/php/pie/releases/download/${PIE_VERSION}/pie.phar" -o /usr/local/bin/pie \
  && chmod +x /usr/local/bin/pie

# Runtime image: extensions + runtime libraries only, no toolchain
ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine

LABEL maintainer="yansongda <me@yansongda.cn>"

ENV TZ="Asia/Shanghai"

# Runtime libraries required by the installed extensions
RUN apk add -U --no-cache tzdata \
      libstdc++ c-ares libssh2 curl openssl zlib pcre2 \
      libpng libzip freetype libwebp libjpeg-turbo libxpm bzip2 \
  && cp /usr/share/zoneinfo/$TZ /etc/localtime \
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer
COPY --from=builder /usr/local/bin/pie /usr/local/bin/pie

COPY php.ini /usr/local/etc/php/

WORKDIR /www
