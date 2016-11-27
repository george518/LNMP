centos 6.7 test ok

nginx_version=1.8.1
mysql_version=5.6.21
php_version=5.6.14
phpmyadmin_version=4.1.8
vsftpd_version=2.3.2
sphinx_version=0.9.9
install_ftp_version=0.0.0

使用方法：

1、解压 
# unzip lnmp_install-1.1.zip

2、赋予权限 !!!!
# chmod -R 777 lnmp_install-1.1

3、进入并执行脚本
# cd lnmp_install-1.1
# ./install.sh  

4、安装yaf

cd ..
./yaf_install.sh


++++++++++++++++++++++++++++++++++++++++++++

 查看安装资料 可以看到mysql root密码和ftp www密码
 cat lnmp_install-1.1/account.log

++++++++++++++++++++++++++++++++++++++++++++


ps:
重启各项服务：
service nginx reload 
service php-fpm restart
service mysql restart


卸载使用
./uninstall.sh
