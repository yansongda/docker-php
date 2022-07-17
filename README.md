# docker-php
Docker with php include php and cli

## Usage
### China Region
docker pull registry.cn-shenzhen.aliyuncs.com/yansongda/php

### Docker Hub
docker pull yansongda/php

## Added ext

detail version see every floder

- amqp
- bcmath
- bz2 
- gd 
- iconv 
- mcrypt
- mysqli
- pdo
- pdo_mysql
- zip
- mongodb
- redis
- memcached
- swoole
- opcache
- sockets

## Modified php.ini
- memory_limit = 512M
- post_max_size = 20M
- upload_max_filesize = 20M
- date.timezone = Asia/Shanghai
- max_execution_time = 60

## Added tools
- composer