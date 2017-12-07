#!/bin/bash
#rm -rf nginx-1.8.1
if [ ! -f nginx-1.8.1.tar.gz ];then
  wget http://nginx.org/download/nginx-1.8.1.tar.gz
fi
tar zxvf nginx-1.8.1.tar.gz
cd nginx-1.8.1
./configure --user=www \
--group=www \
--prefix=/webroot/server/nginx \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
chmod 775 /webroot/server/nginx/logs
chown -R www:www /webroot/server/nginx/logs
chmod -R 775 /webroot/www
chown -R www:www /webroot/www
cd ..
cp -fR ./nginx/config-nginx/* /webroot/server/nginx/conf/
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' /webroot/server/nginx/conf/nginx.conf
chmod 755 /webroot/server/nginx/sbin/nginx
#/webroot/server/nginx/sbin/nginx
mv /webroot/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
/etc/init.d/nginx start