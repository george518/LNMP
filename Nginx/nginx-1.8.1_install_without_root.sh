#!/bin/bash
#install nginx
# by haodaquan
# 2016-05-13
# 
# dir：/home/work
# posion : /home/work/server
# download : /home/work/soft

echo "Before installing the nginx-1.8.1 !"
echo "Please backup your data !!"
read -p "Enter the y or Y to continue:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
   exit 1
fi

#定义安装目录和软件下载目录
base_path=/home/work
install_path=${base_path}/server/nginx
soft_path=${base_path}/soft
www_path=${base_path}/www
user_name=work
group_name=work

if [ ! -d ${install_path} ]; then
        mkdir -p ${install_path}
fi
if [ ! -d ${soft_path} ]; then
        mkdir -p ${soft_path}
fi

mkdir -p ${install_path}/logs
mkdir -p ${www_path}/default

chmod 775 ${install_path}/logs
chown -R ${user_name}:${group_name} ${install_path}
chmod -R 775 ${www_path}
chown -R ${user_name}:${group_name} ${www_path}

# 停止nginx服务
killall nginx &> /dev/null

cd ${soft_path}

rm -rf nginx-1.8.1
if [ ! -f nginx-1.8.1.tar.gz ];then
  wget http://nginx.org/download/nginx-1.8.1.tar.gz
fi
tar zxvf nginx-1.8.1.tar.gz

cd nginx-1.8.1
./configure --user=${user_name} \
--group=${group_name} \
--prefix=${install_path} \
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

#配置文件

if [ ! -d ${install_path}/conf/rewrite ]; then
	mkdir -p ${install_path}/conf/rewrite
fi

if [ ! -d ${install_path}/conf/vhosts ]; then
	mkdir -p ${install_path}/conf/vhosts
fi

touch ${install_path}/conf/rewrite/default.conf
touch ${install_path}/conf/vhosts/default.conf
cat > ${install_path}/conf/vhosts/default.conf <<END
server {
        listen       8080;
        server_name  localhost;
		index index.html index.htm index.php;
		root $www_path/default;
		location ~ .*\.(php|php5)?$
		{
			#fastcgi_pass  unix:/tmp/php-cgi.sock;
			fastcgi_pass  127.0.0.1:9000;
			fastcgi_index index.php;
			include fastcgi.conf;
		}
		location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
		{
			expires 30d;
		}
		location ~ .*\.(js|css)?$
		{
			expires 1h;
		}
		#配置文件
		include $install_path/conf/rewrite/default.conf;
		access_log  $install_path/logs/default.log;
}

END

#fastCGI配置
touch ${install_path}/conf/fastcgi.conf
cat > ${install_path}/conf/fastcgi.conf <<END
if (\$request_filename ~* (.*)\.php) {
    set \$php_url \$1;
}
if (!-e \$php_url.php) {
    return 403;
}
fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
fastcgi_param  QUERY_STRING       \$query_string;
fastcgi_param  REQUEST_METHOD     \$request_method;
fastcgi_param  CONTENT_TYPE       \$content_type;
fastcgi_param  CONTENT_LENGTH     \$content_length;

fastcgi_param  SCRIPT_NAME        \$fastcgi_script_name;
fastcgi_param  REQUEST_URI        \$request_uri;
fastcgi_param  DOCUMENT_URI       \$document_uri;
fastcgi_param  DOCUMENT_ROOT      \$document_root;
fastcgi_param  SERVER_PROTOCOL    \$server_protocol;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/\$nginx_version;

fastcgi_param  REMOTE_ADDR        \$remote_addr;
fastcgi_param  REMOTE_PORT        \$remote_port;
fastcgi_param  SERVER_ADDR        \$server_addr;
fastcgi_param  SERVER_PORT        \$server_port;
fastcgi_param  SERVER_NAME        \$server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;

END

#nginx 配置文件
touch ${install_path}/conf/nginx.conf
cat > ${install_path}/conf/nginx.conf <<END
#user  $user_name $group_name;
worker_processes  2;

error_log  $install_path/logs/error.log crit;
pid        $install_path/logs/nginx.pid;

#Specifies the value for maximum file descriptors that can be opened by this process. 
worker_rlimit_nofile 65535;

events 
{
  use epoll;
  worker_connections 65535;
}


http {
	include       mime.types;
	default_type  application/octet-stream;

	#charset  gb2312;

	server_names_hash_bucket_size 128;
	client_header_buffer_size 32k;
	large_client_header_buffers 4 32k;
	client_max_body_size 8m;

	sendfile on;
	tcp_nopush     on;

	keepalive_timeout 60;

	tcp_nodelay on;

	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;
	fastcgi_buffer_size 64k;
	fastcgi_buffers 4 64k;
	fastcgi_busy_buffers_size 128k;
	fastcgi_temp_file_write_size 128k;

	gzip on;
	gzip_min_length  1k;
	gzip_buffers     4 16k;
	gzip_http_version 1.0;
	gzip_comp_level 2;
	gzip_types       text/plain application/x-javascript text/css application/xml;
	gzip_vary on;
	#limit_zone  crawler  $binary_remote_addr  10m;
	log_format '\$remote_addr - \$remote_user [\$time_local] "\$request" '
	              '\$status \$body_bytes_sent "\$http_referer" '
	              '"\$http_user_agent" "\$http_x_forwarded_for"';
	include $install_path/conf/vhosts/*.conf;
}

END

#nginx 管理shell
touch ${install_path}/conf/nginx
cat > ${install_path}/conf/nginx <<END
#!/bin/bash
# nginx Startup script for the Nginx HTTP Server

nginxd=$install_path/sbin/nginx
nginx_config=$install_path/conf/nginx.conf
nginx_pid=$install_path/logs/nginx.pid

RETVAL=0
prog="nginx"

[ -x \$nginxd ] || exit 0

lock_path=$install_path/lock
if [ ! -d \${lock_path} ]; then
        mkdir -p \${lock_path}
fi

touch \${lock_path}/nginx
chmod 755 \${lock_path}/nginx

# Start nginx daemons functions.
start() {
    
    if [ -e \$nginx_pid ] && netstat -tunpl | grep nginx &> /dev/null;then
        echo "nginx already running...."
        exit 1
    fi
        
    echo -n \$"Starting \$prog!"
    \$nginxd -c \${nginx_config}
    RETVAL=\$?
    echo
    [ \$RETVAL = 0 ] && touch \$lock_path/nginx
    return \$RETVAL
}


# Stop nginx daemons functions.
stop() {
    echo -n \$"Stopping \$prog!"
    \$nginxd -s stop
    RETVAL=\$?
    echo
    [ \$RETVAL = 0 ] && rm -f \$lock_path/nginx
}


# reload nginx service functions.
reload() {

    echo -n \$"Reloading \$prog!"
    \$nginxd -s reload
    RETVAL=\$?
    echo

}

# See how we were called.
case "\$1" in
start)
        start
        ;;

stop)
        stop
        ;;

reload)
        reload
        ;;

restart)
        stop
        start
        ;;

*)
        echo \$"Usage: $prog {start|stop|restart|reload|help}"
        exit 1
esac

exit \$RETVAL

END

chmod +x ${install_path}/conf/nginx

sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' ${install_path}/conf/nginx.conf
chmod 755 ${install_path}/sbin/nginx

#测试文件
touch ${www_path}/default/index.html
cat > ${www_path}/default/index.html <<END

"安装完成……，启动试试吧！"
"======================================================"
"start：$install_path/conf/nginx start|reload|stop|restart"
"uninstall：killall nginx && rm -rf $install_path/nginx "
"test：curl localhost:8080 "
"Thank you for using nginx"
"======================================================"

END



echo "安装完成……，启动试试吧！"
echo "======================================================"
echo "启动方法：$install_path/conf/nginx start|reload|stop"
echo "卸载方法：killall nginx && rm -rf $install_path/nginx "
echo "验证方法：curl localhost:8080 "
echo "======================================================"
