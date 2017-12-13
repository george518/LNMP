#!/bin/bash
# rm -rf php-7.2.0
if [ ! -f php-7.2.0.tar.gz ];then
  wget http://mirrors.sohu.com/php/php-7.2.0.tar.gz
fi
tar zxvf php-7.2.0.tar.gz
cd php-7.2.0
./configure \
--prefix=/webroot/server/php \
--exec-prefix=/webroot/server/php \
--bindir=/webroot/server/php/bin \
--sbindir=/webroot/server/php/sbin \
--includedir=/webroot/server/php/include \
--libdir=/webroot/server/php/lib/php \
--mandir=/webroot/server/php/php/man \
--with-config-file-path=/webroot/server/php/etc \
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

cp ./php-7.2.0/php.ini-production /webroot/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /webroot/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /webroot/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /webroot/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /webroot/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /webroot/server/php/etc/php.ini
#adjust php-fpm
cp ./php-7.2.0/sapi/fpm/php-fpm.conf.in /webroot/server/php/etc/php-fpm.conf
sed -i 's,include=@php_fpm_sysconfdir@/php-fpm.d/\*.conf,include=/webroot/server/php/etc/php-fpm.d/\*.conf,g' /webroot/server/php/etc/php-fpm.conf
mkdir -p /webroot/server/php/etc/php-fpm.d
cp ./php-7.2.0/sapi/fpm/www.conf.in /webroot/server/php/etc/php-fpm.d/www.conf
sed -i 's,user = @php_fpm_user@,user=www,g'   /webroot/server/php/etc/php-fpm.d/www.conf
sed -i 's,group = @php_fpm_group@,group=www,g'   /webroot/server/php/etc/php-fpm.d/www.conf

#self start
install -v -m755 ./php-7.2.0/sapi/fpm/init.d.php-fpm.in  /etc/init.d/php-fpm
sed -i 's,prefix=@prefix@,#prefix=@prefix@,g' /etc/init.d/php-fpm
sed -i 's,exec_prefix=@exec_prefix@,#exec_prefix=@exec_prefix@,g' /etc/init.d/php-fpm
sed -i 's,php_fpm_BIN=@sbindir@/php-fpm,php_fpm_BIN=/webroot/server/php/sbin/php-fpm,g' /etc/init.d/php-fpm
sed -i 's,php_fpm_CONF=@sysconfdir@/php-fpm.conf,php_fpm_CONF=/webroot/server/php/etc/php-fpm.conf,g' /etc/init.d/php-fpm
sed -i 's,php_fpm_PID=@localstatedir@/run/php-fpm.pid,php_fpm_PID=/webroot/server/php/php-fpm.pid,g' /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5