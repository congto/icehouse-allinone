#!/bin/bash -ex

brex_address=`/sbin/ifconfig br-ex | awk '/inet addr/ {print $2}' | cut -f2 -d ":"`
MASTER=$brex_address

###################
echo " #### CAI DAT DASHBOARD ##### "
###################
sleep 5

echo "#################Cài đặt Dashboard#################"
apt-get -y install openstack-dashboard memcached && dpkg --purge openstack-dashboard-ubuntu-theme


echo "############Cau hinh fix loi cho apache2################"
sleep 5
# Fix loi apache cho ubuntu 14.04
# echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
# sudo a2enconf servername 
echo "ServerName localhost" >> /etc/apache2/httpd.conf

## /* Khởi động lại apache và memcached
service apache2 restart
service memcached restart
echo "##### Hoan thanh cai dat Horizon #####"

echo "##### THONG TIN DANG NHAP VAO HORIZON ##### "
echo "URL: http://$MASTER/horizon"
echo "User: Admin"
echo "Pass: $ADMIN_PASS"
