@echo off


echo Building 7.4...
docker build -f src/docker/7.4/Dockerfile -t registry.leafdev.top/packaged/nginx-php-fpm-docker:7.4 .
docker push registry.leafdev.top/packaged/nginx-php-fpm-docker:7.4

echo Building 8.0...
docker build -f src/docker/8.0/Dockerfile -t registry.leafdev.top/packaged/nginx-php-fpm-docker:8.0 .
docker push registry.leafdev.top/packaged/nginx-php-fpm-docker:8.0

echo Building 8.0-swoole-loader...
docker build -f src/docker/8.0-swoole-loader/Dockerfile -t registry.leafdev.top/packaged/nginx-php-fpm-docker:8.0-swoole-loader .
docker push registry.leafdev.top/packaged/nginx-php-fpm-docker:8.0-swoole-loader


echo Finished.