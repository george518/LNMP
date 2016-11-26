#!/bin/bash

if [ "$1" != "in" ];then
	echo "Before cleaning the installation script environment !"
	echo "Please backup your data !!"
	read -p "Enter the y or Y to continue:" isY
	if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
	   exit 1
	fi
fi

mkdir -p /webroot
if which mkfs.ext4 > /dev/null ;then
	if ls /dev/xvdb1 &> /dev/null;then
	   if cat /etc/fstab|grep /webroot > /dev/null ;then
			if cat /etc/fstab|grep /webroot|grep ext3 > /dev/null ;then
				sed -i "/\/webroot/d" /etc/fstab
			fi
	   else
			echo '/dev/xvdb1             /webroot                 ext4    defaults        0 0' >> /etc/fstab
	   fi
	   mount -a
	fi
else
	if ls /dev/xvdb1 &> /dev/null;then
	   if cat /etc/fstab|grep /webroot > /dev/null ;then
			echo ""
	   else
			echo '/dev/xvdb1             /webroot                 ext3    defaults        0 0' >> /etc/fstab
	   fi
	   mount -a
	fi
fi

/etc/init.d/mysqld stop &> /dev/null
/etc/init.d/nginx stop &> /dev/null
/etc/init.d/php-fpm stop &> /dev/null
/etc/init.d/vsftpd stop &> /dev/null
/etc/init.d/httpd stop &> /dev/null
killall mysqld &> /dev/null
killall nginx &> /dev/null
killall httpd &> /dev/null
killall apache2 &> /dev/null
killall vsftpd &> /dev/null
killall php-fpm &> /dev/null

echo "--------> Clean up the installation environment"
rm -rf /usr/local/freetype.2.1.10
rm -rf /usr/local/libpng.1.2.50
rm -rf /usr/local/freetype.2.1.10
rm -rf /usr/local/libpng.1.2.50
rm -rf /usr/local/jpeg.6

echo ""
echo "--------> Delete directory"
echo "/webroot/server/mysql             delete ok!" 
rm -rf /webroot/server/mysql
echo "rm -rf /webroot/server/mysql-*    delete ok!"
rm -rf /webroot/server/mysql-*
echo "/webroot/server/php               delete ok!"
rm -rf /webroot/server/php
echo "/webroot/server/php-*             delete ok!"
rm -rf /webroot/server/php-*
echo "/webroot/server/nginx             delete ok!"
rm -rf /webroot/server/nginx
echo "rm -rf /webroot/server/nginx-*    delete ok!"
rm -rf /webroot/server/nginx-*
echo "/webroot/server/httpd             delete ok!"
rm -rf /webroot/server/httpd
echo "/webroot/server/httpd-*           delete ok!"
rm -rf /webroot/server/httpd-*
echo ""
echo "/webroot/log/php                  delete ok!"
rm -rf /webroot/log/php
echo "/webroot/log/mysql                delete ok!"
rm -rf /webroot/log/mysql
echo "/webroot/log/nginx                delete ok!"
rm -rf /webroot/log/nginx
echo "/webroot/log/httpd                delete ok!"
rm -rf /webroot/log/httpd
echo ""
echo "/webroot/www/phpwind              delete ok!"
rm -rf /webroot/www/phpwind


echo ""
echo "--------> Delete file"
echo "/etc/my.cnf                delete ok!"
rm -f /etc/my.cnf
echo "/etc/init.d/mysqld         delete ok!"
rm -f /etc/init.d/mysqld
echo "/etc/init.d/nginx          delete ok!"
rm -f /etc/init.d/nginx
echo "/etc/init.d/php-fpm        delete ok!"
rm -r /etc/init.d/php-fpm
echo "/etc/init.d/httpd          delete ok!"
rm -f /etc/init.d/httpd

echo ""
ifrpm=$(cat /proc/version | grep -E "redhat|centos")
ifdpkg=$(cat /proc/version | grep -Ei "ubuntu|debian")
ifcentos=$(cat /proc/version | grep centos)
echo "--------> Clean up files"
echo "/etc/rc.local                   clean ok!"
if [ "$ifrpm" != "" ];then
	if [ -L /etc/rc.local ];then
		echo ""
	else
		\cp /etc/rc.local /etc/rc.local.bak
		rm -rf /etc/rc.local
		ln -s /etc/rc.d/rc.local /etc/rc.local
	fi
	sed -i "/\/etc\/init\.d\/mysqld.*/d" /etc/rc.d/rc.local
	sed -i "/\/etc\/init\.d\/nginx.*/d" /etc/rc.d/rc.local
	sed -i "/\/etc\/init\.d\/php-fpm.*/d" /etc/rc.d/rc.local
	sed -i "/\/etc\/init\.d\/vsftpd.*/d" /etc/rc.d/rc.local
	sed -i "/\/etc\/init\.d\/httpd.*/d" /etc/rc.d/rc.local
else
	sed -i "/\/etc\/init\.d\/mysqld.*/d" /etc/rc.local
	sed -i "/\/etc\/init\.d\/nginx.*/d" /etc/rc.local
	sed -i "/\/etc\/init\.d\/php-fpm.*/d" /etc/rc.local
	sed -i "/\/etc\/init\.d\/vsftpd.*/d" /etc/rc.local
	sed -i "/\/etc\/init\.d\/httpd.*/d" /etc/rc.local
fi

echo ""
echo "/etc/profile                    clean ok!"
sed -i "/export PATH=\$PATH\:\/webroot\/server\/mysql\/bin.*/d" /etc/profile
source /etc/profile

echo ""
if [ "$ifrpm" != "" ];then
	yum -y remove vsftpd  &> /dev/null
	cp -f ./ftp/config-ftp/rpm_ftp/* /etc/vsftpd/
	rm -f /etc/vsftpd/chroot_list
	rm -f /etc/vsftpd/ftpusers
	rm -f /etc/vsftpd/user_list
	rm -f /etc/vsftpd/vsftpd.conf
else
	apt-get -y remove vsftpd
	rm -f /etc/vsftpd.conf
	rm -f /etc/vsftpd.chroot_list
	rm -f /etc/vsftpd.user_list
	rm -rf /etc/pam.d/vsftpd
fi
echo "vsftpd                    remove ok!"
