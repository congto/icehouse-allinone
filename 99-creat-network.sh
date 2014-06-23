#!/bin/bash -ex

echo "##### Khai bao rule cho policy #####"

nova secgroup-add-group-rule default default icmp -1 -1
nova secgroup-add-group-rule default default tcp 22 22


#############
# PROVIDER
#############

echo "##### Tao network cho provider (EXTENAL) #####"
neutron net-create ext_net --router:external True --shared 

echo "#####  Tao subnet cho EXTENAL #####"
neutron subnet-create --name sub_ext_net ext_net 192.168.1.0/24 --gateway 192.168.1.1 --allocation-pool start=192.168.1.150,end=192.168.1.220 --enable_dhcp=False --dns-nameservers list=true 8.8.8.8 8.8.4.4 210.245.0.11


####################
# Network cho tenant
####################

echo "##### Tao network cho tenant #####"
neutron net-create int_net 

echo "#####  Tao subnet cho network trong tenant #####"
neutron subnet-create int_net --name int_subnet --dns-nameserver 8.8.8.8 50.60.70.0/24


#####################
# Tao router, gan network, gan interface 
#####################

echo "##### Tao router #####"
neutron router-create router_1

echo "##### Thiet lap defaul gateway cho Router #####"
neutron router-gateway-set router_1 ext_net

echo "##### Khai bao network cua tenant cho Router #####"
neutron router-interface-add router_1 int_subnet


# Tao flavor or example, create a new flavor called m1.custom with an ID of 6, 512 MB of RAM, 5 GB of root disk space, and 1 vCPU:

echo "#### Tao flavor co ID la 6 #####"
nova flavor-create m1.custom 6 512 5 1

# LAY ID cua subnet internal  
# ID_int_net=`neutron net-list | awk '/int*/ {print $2}'`
# echo $ID_int_net

