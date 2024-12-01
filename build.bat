@echo off


echo Building 7.4...
docker build -f src/docker/7.4/Dockerfile -t leafdev.top/packaged/nginx-php-fpm-docker:7.4 .
docker push leafdev.top/packaged/nginx-php-fpm-docker:7.4

echo Building 8.0...
docker build -f src/docker/8.0/Dockerfile -t leafdev.top/packaged/nginx-php-fpm-docker:8.0 .
docker push leafdev.top/packaged/nginx-php-fpm-docker:8.0

echo Building 8.0-swoole-loader...
docker build -f src/docker/8.0-swoole-loader/Dockerfile -t leafdev.top/packaged/nginx-php-fpm-docker:8.0-swoole-loader .
docker push leafdev.top/packaged/nginx-php-fpm-docker:8.0-swoole-loader

echo Building 8.2...
docker build -f src/docker/8.2/Dockerfile -t leafdev.top/packaged/nginx-php-fpm-docker:8.2 .
docker push leafdev.top/packaged/nginx-php-fpm-docker:8.2


echo Finished.