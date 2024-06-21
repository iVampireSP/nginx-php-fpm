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
## Check if the artisan file exists
if [ -f /var/www/html/artisan ]; then
    info "Artisan file found, creating laravel supervisor config"
    # Set DocumentRoot to the Laravel project directory
    export DOCUMENT_ROOT=/var/www/html/public
    ##Create Laravel Scheduler process
    TASK=/etc/supervisor/conf.d/laravel-worker.conf
    touch $TASK
    cat > "$TASK" <<EOF
    [program:Laravel-scheduler]
    process_name=%(program_name)s_%(process_num)02d
    command=/bin/sh -c "while [ true ]; do (php /var/www/html/artisan schedule:run --verbose --no-interaction &); sleep 60; done"
    autostart=true
    autorestart=true
    numprocs=1
    user=$USER_NAME
    stdout_logfile=/var/log/laravel_scheduler.out.log
    redirect_stderr=true
    
    [program:Laravel-worker]
    process_name=%(program_name)s_%(process_num)02d
    command=php /var/www/html/artisan queue:work --sleep=3 --tries=3
    autostart=true
    autorestart=true
    numprocs=$LARAVEL_PROCS_NUMBER
    user=$USER_NAME
    redirect_stderr=true
    stdout_logfile=/var/log/laravel_worker.log
EOF
  info  "Laravel supervisor config created"
else
    info  "artisan file not found"
fi

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
info "You can put custom supervisor conf at /var/www/conf/supervisor.conf"
## Check if the supervisor config file exists
if [ -f /var/www/conf/supervisor.conf ]; then
    info "Custom supervisor config found"
    cp /var/www/conf/supervisor.conf /etc/supervisor/conf.d
fi

info "You can put extend-php.ini to /var/www/conf/extend-php.ini, it will be add to /usr/local/etc/php/conf.d/extend-php.ini"
if [ -f /var/www/conf/extend-php.ini ]; then
    info "Extend PHP config found"
    cp /var/www/conf/extend-php.ini /usr/local/etc/php/conf.d/extend-php.ini
fi

## Start Supervisord
supervisord -c /etc/supervisor/supervisord.conf

