# docker-php
Docker with php include php and cli

## Usage
### China Region
docker pull registry.cn-shenzhen.aliyuncs.com/yansongda/php

### Docker Hub
docker pull yansongda/php

## Added ext

detail version see every floder

## Tags

- `cli-*` (e.g. `yansongda/php:cli-8.5-alpine`): built on official NTS images (`php:8.x-cli-*`)
- `zts-*` (e.g. `yansongda/php:zts-8.5-alpine`): built on official ZTS images (`php:8.x-zts-*`),
  with Swoole compiled `--enable-swoole-thread` for the `Swoole\Thread` API (ZTS-only).
  Note: `--enable-swoole-curl` is omitted on ZTS builds due to swoole-src#6145.

## Modified php.ini
- memory_limit = 512M
- post_max_size = 20M
- upload_max_filesize = 20M
- date.timezone = Asia/Shanghai
- max_execution_time = 60

## Added tools
- composer