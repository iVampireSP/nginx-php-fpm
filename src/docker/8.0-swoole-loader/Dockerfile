FROM php:8.0-fpm
ARG WORKDIR=/var/www
ENV DOCUMENT_ROOT=${WORKDIR}
ENV LARAVEL_PROCS_NUMBER=1
ENV DOMAIN=_
ENV CLIENT_MAX_BODY_SIZE=15M
ARG GROUP_ID=1000
ARG USER_ID=1000
ENV USER_NAME=www-data
ARG GROUP_NAME=www-data
ENV TZ=Asia/Shanghai

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmemcached-dev \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    librdkafka-dev \
    libpq-dev \
    libgmp-dev \ 
    zlib1g-dev \ 
    libssl-dev \ 
    libcurl4-openssl-dev libcurl4 libwebp-dev libjpeg-dev libfreetype6-dev libjpeg62-turbo-dev libmemcached-dev \
    zip \
    unzip \
    sqlite3  \
    nano \
    cron \
    nginx

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp 

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

COPY src/ext/swoole_loader80.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930
COPY src/php-fpm /etc/init.d/php-fpm


RUN docker-php-ext-install -j$(nproc) pdo_mysql opcache intl gmp mysqli curl zip mbstring exif pdo pdo_pgsql gd && \
    docker-php-ext-enable pdo_mysql opcache intl gmp mysqli curl zip mbstring exif pdo pdo_pgsql gd && \
    install-php-extensions redis pcntl && docker-php-ext-enable redis pcntl && \
    docker-php-ext-enable swoole_loader80 && \
    # clean
    rm /usr/local/bin/install-php-extensions && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /tmp/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR $WORKDIR

ADD src/index.php $WORKDIR/index.php
ADD src/php.ini $PHP_INI_DIR/conf.d/
# ADD src/opcache.ini $PHP_INI_DIR/conf.d/

COPY src/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    ln -s /usr/local/bin/entrypoint.sh / && \
    rm -rf /etc/nginx/conf.d/default.conf && rm -rf /etc/nginx/sites-enabled/default && rm -rf /etc/nginx/sites-available/default && rm -rf /etc/nginx/nginx.conf

COPY src/nginx.conf /etc/nginx/nginx.conf
COPY src/default.conf /etc/nginx/conf.d/
COPY src/fpm-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY src/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN usermod -u ${USER_ID} ${USER_NAME} && \
    groupmod -g ${USER_ID} ${GROUP_NAME} && \
    mkdir -p /var/log/nginx  && \
    mkdir -p /var/cache/nginx  && \
    chown -R ${USER_NAME}:${GROUP_NAME} /var/www && \
    chown -R ${USER_NAME}:${GROUP_NAME} /var/log/ && \
    chown -R ${USER_NAME}:${GROUP_NAME} $PHP_INI_DIR/conf.d/ && \
    touch /var/run/nginx.pid && \
    chown -R $USER_NAME:$USER_NAME /var/cache/nginx && \
    chown -R $USER_NAME:$USER_NAME /var/lib/nginx/ && \
    chown -R $USER_NAME:$USER_NAME /var/run/nginx.pid && \
    chown -R $USER_NAME:$USER_NAME /etc/nginx/nginx.conf && \
    chown -R $USER_NAME:$USER_NAME /etc/nginx/conf.d/ && \
    chown -R ${USER_NAME}:${GROUP_NAME} /tmp


#USER ${USER_NAME}
EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]
