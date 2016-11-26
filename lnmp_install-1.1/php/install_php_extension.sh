#!/bin/bash

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi

#memcache
# if [ ! -f memcache-3.0.6.tgz ];then
# 	wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/memcache-3.0.6.tgz
# fi
# rm -rf memcache-3.0.6
# tar -xzvf memcache-3.0.6.tgz
# cd memcache-3.0.6
# /webroot/server/php/bin/phpize
# ./configure --enable-memcache --with-php-config=/webroot/server/php/bin/php-config
# CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
# if [ $CPU_NUM -gt 1 ];then
#     make -j$CPU_NUM
# else
#     make
# fi
# make install
# cd ..
# echo "extension=memcache.so" >> /webroot/server/php/etc/php.ini

#zend
if ls -l /webroot/server/ |grep "5.3.18" > /dev/null;then
  mkdir -p /webroot/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  if [ $machine == "x86_64" ];then
	  if [ ! -f ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz ];then
		wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
	  fi
	  tar zxvf ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
	  mv ./ZendGuardLoader-php-5.3-linux-glibc23-x86_64/php-5.3.x/ZendGuardLoader.so /webroot/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  else
      if [ ! -f ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz ];then
        wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
	  fi
	  tar zxvf ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
	  mv ./ZendGuardLoader-php-5.3-linux-glibc23-i386/php-5.3.x/ZendGuardLoader.so /webroot/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  fi
  echo "zend_extension=/webroot/server/php/lib/php/extensions/no-debug-non-zts-20090626/ZendGuardLoader.so" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> /webroot/server/php/etc/php.ini 
elif ls -l /webroot/server/ |grep "5.4.23" > /dev/null;then
  mkdir -p /webroot/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  if [ $machine == "x86_64" ];then
	  if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz ];then 
		wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
	  fi
	  tar zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
	  mv ./ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ZendGuardLoader.so /webroot/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  else
      if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz ];then 
		wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
	  fi
	  tar zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
	  mv ./ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386/php-5.4.x/ZendGuardLoader.so /webroot/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  fi
  echo "zend_extension=/webroot/server/php/lib/php/extensions/no-debug-non-zts-20100525/ZendGuardLoader.so" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> /webroot/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> /webroot/server/php/etc/php.ini 
elif ls -l /webroot/server/ |grep "5.5.7" > /dev/null;then
  mkdir -p /webroot/server/php/lib/php/extensions/no-debug-non-zts-20121212/
  sed -i 's#\[opcache\]#\[opcache\]\nzend_extension=opcache.so#' /webroot/server/php/etc/php.ini
  sed -i 's#;opcache.enable=0#opcache.enable=1#' /webroot/server/php/etc/php.ini
fi