#!/bin/bash

#phpwind
if [ ! -f phpwind_GBK_8.7.zip ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/phpwind_GBK_8.7.zip
fi
rm -rf phpwind_GBK_8.7
unzip phpwind_GBK_8.7.zip
mv phpwind_GBK_8.7/upload/* /webroot/www/phpwind/
chmod -R 777 /webroot/www/phpwind/attachment
chmod -R 777 /webroot/www/phpwind/data
chmod -R 777 /webroot/www/phpwind/html
cd /webroot/www/phpwind/
find ./ -type f | xargs chmod 644
find ./ -type d | xargs chmod 755
chmod -R 777 attachment/ html/ data/
cd -

#phpmyadmin
if [ ! -f phpmyadmin.zip ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/phpMyAdmin-4.1.8-all-languages.zip
fi
rm -rf phpMyAdmin-4.1.8-all-languages
unzip phpMyAdmin-4.1.8-all-languages.zip
mv phpMyAdmin-4.1.8-all-languages /webroot/www/phpwind/phpmyadmin

chown -R www:www /webroot/www/phpwind/