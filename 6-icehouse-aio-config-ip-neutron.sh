#!/bin/bash -ex

eth0_address=`/sbin/ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
eth1_address=`/sbin/ifconfig eth1 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
MASTER=$eth0_address
LOCAL_IP=$eth1_address
GATEWAY_IP=192.168.1.1
#
echo "############Cai dat va cau hinh OpenvSwitch ######################"
sleep 5
apt-get install -y openvswitch-controller openvswitch-switch openvswitch-datapath-dkms

echo "############# Cau hinh br-int va br-ex cho OpenvSwitch #################"
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth0

echo "#############CAU HINH LAI NETWORK#################"
sleep 5 

ifaces=/etc/network/interfaces
test -f $ifaces.orig1 || cp $ifaces $ifaces.orig1
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto br-ex
iface br-ex inet static
address $MASTER
netmask 255.255.255.0
gateway $GATE_WAY
dns-nameservers 8.8.8.8

auto eth0
iface eth0 inet manual
   up ifconfig \$IFACE 0.0.0.0 up
   up ip link set \$IFACE promisc on
   down ip link set \$IFACE promisc off
   down ifconfig \$IFACE down

auto eth1
iface eth1 inet static
address $LOCAL_IP
netmask 255.255.255.0

auto eth2
iface eth2 inet static
address 192.168.100.10
netmask 255.255.255.0
EOF



echo "############## KHOI DONG LAI MAY VAT LY #################"
init 6
