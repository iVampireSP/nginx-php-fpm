# Note

I removed supervisor, use init.d instead.

# Nginx PHP-FPM Docker image

> 🐳 Full Docker image for Nginx PHP-FPM container created to run Laravel or any php based applications.

- [Docker Hub](https://hub.docker.com/r/jkaninda/nginx-php-fpm)
- [Github](https://github.com/jkaninda/nginx-php-fpm)

## PHP Versions:
- 8.3
- 8.2
- 8.1
- 8.0
- 7.4
- 7.2

## Specifications:

* Composer
* OpenSSL PHP Extension
* XML PHP Extension
* PDO PHP Extension
* Rdkafka PHP Extension
* Redis PHP Extension
* Mbstring PHP Extension
* PCNTL PHP Extension
* ZIP PHP Extension
* GD PHP Extension
* BCMath PHP Extension
* Memcached
* Laravel Cron Job
* Laravel Schedule
* Nodejs
* NPM

## Simple docker-compose usage:

```yml
version: '3'
services:
    app:
        image: jkaninda/nginx-php-fpm:8.3
        container_name: my-app
        restart: unless-stopped 
        user: www-data # Optional - for production usage    
        volumes:
        #Project root
            - ./:/var/www/html
        ports:
           - "80:80"
        networks:
            - default #if you're using networks between containers

```
## Laravel `artisan` command usage:
### CLI
```sh
docker-compose exec  app bash

```
```sh
docker exec -it app bash

```

## Advanced Nignx-php-fpm:
### docker-compose.yml
```yml
version: '3'
services:
    app:
        image: jkaninda/nginx-php-fpm
        container_name: nginx-fpm
        restart: unless-stopped 
        ports:
           - "80:80"    
        volumes:
        #Project root
            - ./:/var/www/html
            - ~/.ssh:/root/.ssh # If you use private CVS
             #./php.ini:/usr/local/etc/php/conf.d/php.ini # Optional, your custom php init file
        environment:
           - APP_ENV=development # Optional, or production
           - LARAVEL_PROCS_NUMBER=2 # Optional, Laravel queue:work process number
           #- CLIENT_MAX_BODY_SIZE=20M # Optional
           #- DOMAIN=example.com # Optional
           - DOCUMENT_ROOT=/var/www/html #Optional
 
```
Default web root:
```
/var/www/html
```


## Docker run
```sh
 docker-compose up -d

```
## Build from base
Dockerfile
```Dockerfile
FROM jkaninda/nginx-php-fpm:8.3
# Copy laravel project files
COPY . /var/www/html
# Storage Volume
VOLUME /var/www/html/storage

WORKDIR /var/www/html

# Custom cache invalidation / optional
#ARG CACHEBUST=1
# composer install / Optional
#RUN composer install
# Fix permissions
RUN chown -R www-data:www-data /var/www/html

USER www-data
```


## Nginx custom config:
### Enable custom nginx config files
> /var/www/html/conf/nginx/nginx.conf

> /var/www/html/conf/nginx/nginx-site.conf



### Storage permision issue
```sh
 docker-compose exec php-fpm /bin/bash 
 ```
```sh
chown -R www-data:www-data /var/www/html/
```

> chmod -R 775 /var/www/html/storage

> P.S. please give a star if you like it :wink: