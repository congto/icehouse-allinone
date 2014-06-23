#!/bin/bash -ex 

eth0_address=`/sbin/ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
eth1_address=`/sbin/ifconfig eth1 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
MASTER=$eth0_address
LOCAL_IP=$eth1_address
GATEWAY_IP=192.168.1.1

echo "##### CAU HINH IP STATIC CHO NICs #####"
sleep 3

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# EXT NETWORK
auto eth0
iface eth0 inet static
address $MASTER
netmask 255.255.255.0
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8

# DATA NETWORK
auto eth1
iface eth1 inet static
address $LOCAL_IP
netmask 255.255.255.0

EOF

/etc/init.d/networking restart 

echo "##### Thu hien update he thong truoc khi cai dat #####"
sleep 3

apt-get install -y python-software-properties &&  add-apt-repository cloud-archive:icehouse 

apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade 


iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost
touch $iphost

echo "##### Khai bao Hostname cho ubuntu #####"
sleep 3

hostname controller
echo "controller" > /etc/hostname
 
cat << EOF >> $iphost
127.0.0.1       localhost
127.0.1.1       controller
$eth0_address	controller
$eth1_address	controller
 
# The following lines are desirable for IPv6 capable hosts
# ::1     ip6-localhost ip6-loopback
# fe00::0 ip6-localnet
# ff00::0 ip6-mcastprefix
# ff02::1 ip6-allnodes
# ff02::2 ip6-allrouters
EOF


/etc/init.d/networking restart 

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
sysctl -p

echo "######## Cai dat & cau hinh NTP ########"
sleep 3
apt-get install -y ntp

# Update /etc/ntp.conf file
# Here we set ntp.ubuntu.com as the direct source of time.
# You will also find that a local time source 
# is also provided in case of internet time service interruption.
sed -i 's/server ntp.ubuntu.com/ \
server ntp.ubuntu.com \
server 127.127.1.0 \
fudge 127.127.1.0 stratum 10/g' /etc/ntp.conf

echo "##### Khoi dong lai NTP #####"
sleep 3
service ntp restart


echo "##### Cai dat RABBITMQ #####"
sleep 3
apt-get -y install rabbitmq-server

echo "##### Khai bao mat khau cho RABBITMQ #####"
sleep 3
rabbitmqctl change_password guest Welcome123
echo " ##### Khoi dong lai may ##### "
sleep 3

init 6 
