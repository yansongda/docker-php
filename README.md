# docker-php
Docker with php include php and cli

## Build layout
- `docker/{cli,zts}/{alpine,trixie}/Dockerfile`: shared multi-stage templates,
  parameterized via `--build-arg PHP_VERSION=x.y` (CI matrix builds 8.2 – 8.5)
- `php.ini`: shared PHP configuration
- `legacy/`: archived Dockerfiles for PHP 7.1 – 8.1, no longer built

## Usage
### China Region
docker pull registry.cn-shenzhen.aliyuncs.com/yansongda/php

### Docker Hub
docker pull yansongda/php

## Added ext

see `ENV` in `docker/{cli,zts}/{alpine,trixie}/Dockerfile`
(extensions are compiled in the `builder` stage; only the artifacts and runtime
libraries land in the final image, so no runtime `pecl`/`pie` compile capability)

## Tags

- Currently built & maintained: PHP 8.2 – 8.5 (`cli-*` / `zts-*` variants, alpine & Debian trixie).
- `cli-*` (e.g. `yansongda/php:cli-8.5-alpine`): built on official NTS images (`php:8.x-cli-*`)
- `zts-*` (e.g. `yansongda/php:zts-8.5-alpine`): built on official ZTS images (`php:8.x-zts-*`),
  with Swoole compiled `--enable-swoole-thread` for the `Swoole\Thread` API (ZTS-only).
  Note: `--enable-swoole-curl` is omitted on ZTS builds due to swoole-src#6145.
- PHP 7.1 – 8.1 images (including the old `fpm-*` variants) are archived under `legacy/`
  and are **no longer built**.

## Modified php.ini
- memory_limit = 512M
- post_max_size = 100M
- upload_max_filesize = 100M
- date.timezone = Asia/Shanghai
- max_execution_time = 60
- expose_php = Off
- opcache.enable_cli = On

  Note: since PHP 8.5, opcache is built into the PHP binary and is no longer shipped as a
  loadable `.so` module (php/php-src#20557). On 8.2 ZTS builds the opcache JIT is disabled
  (`zend_jit_x86.dasc` fails to compile with gcc 15).

## Added tools
- composer
- pie
