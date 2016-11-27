#!/bin/bash

#ifcentos=$(cat /proc/version | grep centos)
ifubuntu=$(cat /proc/version | grep ubuntu)

userdel www
groupadd www
if [ "$ifubuntu" != "" ];then
useradd -g www -M -d /webroot/www -s /usr/sbin/nologin www &> /dev/null
else
useradd -g www -M -d /webroot/www -s /sbin/nologin www &> /dev/null
fi

#if [ "$ifcentos" != "" ];then
#useradd -g www -M -d /webroot/www -s /sbin/nologin www &> /dev/null
#elif [ "$ifubuntu" != "" ];then
#useradd -g www -M -d /webroot/www -s /usr/sbin/nologin www &> /dev/null
#fi

mkdir -p /webroot
mkdir -p /webroot/server
mkdir -p /webroot/www
mkdir -p /webroot/www/default
mkdir -p /webroot/log
mkdir -p /webroot/log/php
mkdir -p /webroot/log/mysql
mkdir -p /webroot/log/nginx
mkdir -p /webroot/log/nginx/access
chown -R www:www /webroot/log

mkdir -p /webroot/server/${mysql_dir}
ln -s /webroot/server/${mysql_dir} /webroot/server/mysql

mkdir -p /webroot/server/${php_dir}
ln -s /webroot/server/${php_dir} /webroot/server/php


mkdir -p /webroot/server/${web_dir}
if echo $web |grep "nginx" > /dev/null;then
mkdir -p /webroot/log/nginx
mkdir -p /webroot/log/nginx/access
ln -s /webroot/server/${web_dir} /webroot/server/nginx
else
mkdir -p /webroot/log/httpd
mkdir -p /webroot/log/httpd/access
ln -s /webroot/server/${web_dir} /webroot/server/httpd
fi
