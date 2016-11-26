#!/bin/bash
# install Mysql-5.6.21
# by haodaquan
# 2016-05-13
# 
# dir：/home/work
# posion : /home/work/server
# download : /home/work/soft




echo "Before installing the mysql-5.6.21 !"
echo "Please backup your data !!"
read -p "Enter the y or Y to continue:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
   exit 1
fi

#定义安装目录和软件下载目录
install_path=/home/work/server
soft_path=/home/work/soft

if [ ! -d ${install_path} ]; then
        mkdir -p ${install_path}
fi
if [ ! -d ${soft_path} ]; then
        mkdir -p ${soft_path}
fi
# 停止mysql服务
killall mysqld

cd ${soft_path}
if [ ! -d ./mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz ]; then
        wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
fi

tar zxvf mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
mkdir ${install_path}/mysql
mv mysql-5.6.21-linux-glibc2.5-x86_64/*  ${install_path}/mysql
cd ${install_path}/mysql

if [ ! -d etc ]; then
        mkdir etc
fi

if [ ! -d ${install_path}/log ]; then
        mkdir -p ${install_path}/log
fi

rm -rf ./etc/*

touch ./etc/my.cnf
mkdir ${install_path}/log
cat > ./etc/my.cnf <<END
[client]
port            = 3306
socket          = /home/work/server/mysql/mysql.sock
[mysqld]
port            = 3306
socket          = /home/work/server/mysql.sock
skip-external-locking
log-error=/home/work/server/log/mysql_error.log
basedir = /home/work/server/mysql
datadir = /home/work/server/mysql/data
pid-file = /home/work/server/mysql/mysql.pid
user = work
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M

log-bin=mysql-bin
binlog_format=mixed
server-id       = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
END

echo "数据库初始化……"
sleep 5

${install_path}/mysql/scripts/mysql_install_db --defaults-file=${install_path}/mysql/etc/my.cnf
echo "正在启动数据库……"
sleep 5
${install_path}/mysql/bin/mysqld_safe --defaults-file=${install_path}/mysql/etc/my.cnf & > /dev/null

echo "数据库安装完成！请启动客户端进行验证"
echo "=============================="
echo "启动方法：/home/work/server/mysql/bin/mysql -u root -S /home/work/server/mysql.sock"
echo "卸载方法：killall mysqld && rm -rf /home/work/server/mysql "
echo "切记：数据备份再卸载！！！"
echo "=============================="
#echo "启动方法：/home/work/server/mysql/bin/mysql -u root -S /home/work/server/mysql.sock"


