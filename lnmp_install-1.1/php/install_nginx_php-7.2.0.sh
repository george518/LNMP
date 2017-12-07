#!/bin/bash
# rm -rf php-7.2.0
if [ ! -f php-7.2.0.tar.gz ];then
  wget http://mirrors.sohu.com/php/php-7.2.0.tar.gz
fi
tar zxvf php-7.2.0.tar.gz
cd php-7.2.0
./configure \
--prefix=/webroot/server/php7 \
--exec-prefix=/webroot/server/php7 \
--bindir=/webroot/server/php7/bin \
--sbindir=/webroot/server/php7/sbin \
--includedir=/webroot/server/php7/include \
--libdir=/webroot/server/php7/lib/php \
--mandir=/webroot/server/php7/php/man \
--with-config-file-path=/webroot/server/php7/etc \
--with-mysql-sock=/tmp/mysql.sock \
--with-mcrypt \
--with-mhash \
--with-openssl \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv \
--with-zlib \
--with-xmlrpc \
--without-pear \
--with-gettext \
--with-curl \
--without-gdbm \
--without-sqlite \
--with-gd \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.6 \
--with-png-dir=/usr/local/libpng.1.2.50 \

--enable-inline-optimization \
--enable-shared \
--enable-xml \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-mbregex \
--enable-mbstring \
--enable-ftp \
--enable-gd-native-ttf \
--enable-pcntl \
--enable-sockets \
--enable-soap \
--enable-session \
--enable-opcache \
--enable-fpm \
--enable-fastcgi \
--enable-static \
--enable-wddx \
--enable-zip \
--enable-calendar \
--disable-ipv6 \
--disable-debug \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo \
--disable-rpath \

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./php-7.2.0/php.ini-production /webroot/server/php7/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/webroot/server/php7/lib/php/extensions/no-debug-non-zts-20121212/"#'  /webroot/server/php7/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /webroot/server/php7/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /webroot/server/php7/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /webroot/server/php7/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /webroot/server/php7/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /webroot/server/php7/etc/php.ini
#adjust php-fpm
cp /webroot/server/php7/etc/php-fpm.conf.default /webroot/server/php7/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = /webroot/log/php/php-fpm.log,g'   /webroot/server/php7/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = /webroot/log/php/\$pool.log.slow,g'   /webroot/server/php7/etc/php-fpm.conf
#self start
install -v -m755 ./php-7.2.0/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm7
/etc/init.d/php-fpm7 start
sleep 5