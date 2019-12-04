# docker-php-fpm
Docker with php-fpm

## Usage
### China Region
docker pull registry.cn-shenzhen.aliyuncs.com/yansongda/php-fpm

### Docker Hub
docker pull yansongda/php-fpm

## Added ext
- amqp-1.9.4
- bcmath
- bz2 
- gd 
- iconv 
- mcrypt-1.0.3
- mysqli
- pdo
- pdo_mysql
- zip
- mongodb-1.6.0
- redis-4.3.0
- memcached-3.1.3
- swoole-4.4.12
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