#!/bin/bash

if [ ! -f yaf-2.3.4.tgz ];then
  wget http://pecl.php.net/get/yaf-2.3.4.tgz
fi
tar zxvf yaf-2.3.4.tgz
cd yaf-2.3.4

/webroot/server/php/bin/phpize && ./configure --with-php-config=/webroot/server/php/bin/php-config 

make && make install

#if cat /webroot/server/php/etc/php.ini | grep yaf.so > /dev/null ;then
cat >> /webroot/server/php/etc/php.ini <<END
[yaf]
yaf.environ = product
yaf.library = NULL
yaf.cache_config = 0
yaf.name_suffix = 1
yaf.name_separator = "":
yaf.forward_limit = 5
yaf.use_namespace = 0
yaf.use_spl_autoload = 0
extension=/webroot/server/php/lib/php/extensions/no-debug-non-zts-20131226/yaf.so
END
#fi

service php-fpm restart

echo "********* yaf-2.3.4  install ok *************"