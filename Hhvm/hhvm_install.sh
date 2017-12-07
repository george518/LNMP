#!/bin/bash
#install hhvm
# by haodaquan
# 2016-11-27


#添加epel yum源
rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
#安装hhvm所需要的依赖包
yum -y install libmcrypt-devel glog-devel jemalloc-devel tbb-devel libdwarf-devel mysql-devel \
libxml2-devel libicu-devel pcre-devel gd-devel boost-devel sqlite-devel pam-devel \
bzip2-devel oniguruma-devel openldap-devel readline-devel libc-client-devel libcap-devel \
libevent-devel libcurl-devel libmemcached-devel
#添加gleez yum源
# rpm -Uvh //blog.linuxeye.com/wp-content/uploads/2014/05/gleez-repo-6-0.el6.noarch.rpm
rpm -Uvh http://yum.gleez.com/6/x86_64/gleez-repo-6-0.el6.noarch.rpm
#添加remi yum源
# rpm -Uvh http://rpms.famillecollet.com/enterprise/6/remi/x86_64/remi-release-6.5-1.el6.remi.noarch.rpm
 rpm -Uvh http://rpms.famillecollet.com/enterprise/6/remi/x86_64/remi-release-6.6-2.el6.remi.noarch.rpm
# # warning: /etc/my.cnf created as /etc/my.cnf.rpmnew
# rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
#从remi安装hhvm依赖包
yum -y --enablerepo=remi install libwebp mysql mysql-devel mysql-lib
#安装hhvm
yum -y --nogpgcheck install hhvm