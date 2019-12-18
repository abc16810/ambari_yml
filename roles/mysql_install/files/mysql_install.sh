#!/bin/bash
#########
#Mysql install
########



if [ `rpm -qa | grep mariadb |wc -l` -ne 0 ];then
        echo -e "检测到mariadb存在"
        rpm -e --nodeps `rpm -qa | grep mariadb`
        echo -e "mariadb卸载完成"
else
        echo "未检测到mariadb存在"
fi 


export INITDIR=$(readlink -m $(dirname $0))

echo "*** remove mysql ***"
yum -y remove mysql-community mysql-community-server mysql-community-client mysql-community-libs mysql-community-common
rm -rf /var/lib/mysql /usr/lib64/mysql /usr/share/mysql


yum -y install perl
yum -y install libaio


perl -v  &> /dev/null
Rs=$?
if [ $Rs -eq 0 ] ; then
  echo "perl,已经安装，继续！"
else
  echo -e "\033[5;31mperl,没有安装，退出\033[0m"
  exit 4
fi
echo $INITDIR


echo "*** Installing MYSQL ***"
rpm -ivh $INITDIR/file/mysql/mysql-community-common-5.7.24-1.el7.x86_64.rpm
rpm -ivh $INITDIR/file/mysql/mysql-community-libs-5.7.24-1.el7.x86_64.rpm
rpm -ivh $INITDIR/file/mysql/mysql-community-libs-compat-5.7.24-1.el7.x86_64.rpm
rpm -ivh $INITDIR/file/mysql/mysql-community-client-5.7.24-1.el7.x86_64.rpm
rpm -ivh $INITDIR/file/mysql/mysql-community-server-5.7.24-1.el7.x86_64.rpm
rpm -ivh $INITDIR/file/mysql/mysql-community-devel-5.7.24-1.el7.x86_64.rpm


mysqld --initialize --user=mysql
echo "*** config MYSQL ***"
cp $INITDIR/file/mysql/my.cnf /etc/
echo "*** Starting to MySQL and setting to run ***"
systemctl restart mysqld.service
systemctl enable mysqld.service
mysql --execute="update mysql.user set authentication_string=password('Ch@123Mysql') where user='root' and Host = 'localhost';"
mysql --execute="update mysql.user set authentication_string=password('Ch@123Mysql') where user='root' and Host = '%';"
echo "*** setting config ***"
cp $INITDIR/file/my.cnf /etc/

systemctl restart mysqld.service
echo "*** update password ***"
#$INITDIR/expect/mysql.expect
#ALTER USER 'root'@'localhost' IDENTIFIED BY 'Zwkj@123Mysql';
echo "*** import data ***"
mysql --user="root" --password="Ch@123Mysql" --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY 'Ch@123Mysql' WITH GRANT OPTION;"
mysql --user="root" --password="Ch@123Mysql" --execute="FLUSH PRIVILEGES;"
#mysql --user="root" --password="Ch@123Mysql" --execute="source $INITDIR/file/clbs_init_3.7.0.sql;"
echo "*** install complete ***"
echo "安装MySQL完成"

