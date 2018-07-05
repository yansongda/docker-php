# docker-php-fpm
Docker with php-fpm

## Usage
### China Region
docker pull registry.cn-shenzhen.aliyuncs.com/yansongda/php-fpm

### Docker Hub
docker pull yansongda/php-fpm

## Added ext
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

## Modified php.ini
- memory_limit = 256M
- post_max_size = 20M
- upload_max_filesize = 20M
- date.timezone = Asia/Shanghai
- max_execution_time = 60

## Added tools
- composer