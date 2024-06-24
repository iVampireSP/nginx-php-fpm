#!/bin/sh

# Must use LF, do not use CRLF

echo ""
echo "***********************************************************"
echo " Starting NGINX PHP-FPM Docker Container                   "
echo "***********************************************************"

set -e
set -e
info() {
    { set +x; } 2> /dev/null
    echo '[INFO] ' "$@"
}
warning() {
    { set +x; } 2> /dev/null
    echo '[WARNING] ' "$@"
}
fatal() {
    { set +x; } 2> /dev/null
    echo '[ERROR] ' "$@" >&2
    exit 1
}

info "You can put custom nginx site conf at /var/www/conf/site.conf"

# Enable custom nginx config files if they exist
if [ -f /var/www/conf/site.conf ]; then
  info "Custom nginx site config found"
  rm /etc/nginx/conf.d/default.conf
  cp /var/www/conf/site.conf /etc/nginx/conf.d/default.conf
  info "Start nginx with custom server config..."
  else
  info "site.conf not found"
  info "If you want to use custom configs, create config file in /var/www/conf/site.conf"
  info "Start nginx with default config..."
fi

info "You can put extend-php.ini to /var/www/conf/extend-php.ini, it will be add to /usr/local/etc/php/conf.d/extend-php.ini"
if [ -f /var/www/conf/extend-php.ini ]; then
    info "Extend PHP config found"
    cp /var/www/conf/extend-php.ini /usr/local/etc/php/conf.d/extend-php.ini
fi

service php-fpm start

# start nginx
nginx -g 'daemon off;'