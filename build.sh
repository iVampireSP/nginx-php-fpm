#!/bin/bash
if [ $# -eq 0 ]
  then
    tag='latest'
  else
    tag=$1
fi
if [ $tag != 'latest' ]
then
  echo 'Build from tag'
  docker build -f src/docker/${tag}/Dockerfile -t registry.leafdev.top/packaged/nginx-php-fpm-docker:$tag .
else
 echo 'Build latest'
 docker build -f src/docker/8.3/Dockerfile -t registry.leafdev.top/packaged/nginx-php-fpm-docker:$tag .
 
fi
