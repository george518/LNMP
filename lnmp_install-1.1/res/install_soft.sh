#!/bin/bash

#default
cp ./index.php /webroot/www/default
cd -

#phpmyadmin
if [ ! -f phpmyadmin.zip ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/phpMyAdmin-4.1.8-all-languages.zip
fi
rm -rf phpMyAdmin-4.1.8-all-languages
unzip phpMyAdmin-4.1.8-all-languages.zip
mv phpMyAdmin-4.1.8-all-languages /webroot/www/default/phpmyadmin

chown -R www:www /webroot/www/default/