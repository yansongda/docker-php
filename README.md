# docker-php7-fpm
Docker with php7-fpm

## Usage
### China Region
docker pull registry.cn-shenzhen.aliyuncs.com/yansongda/php7-fpm

### Docker Hub
docker pull yansongda/php7-fpm

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

## Added tools
- composer
- git