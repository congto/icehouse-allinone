#!/bin/bash -ex
#

RABBIT_PASS=Welcome123
ADMIN_PASS=Welcome123
METADATA_SECRET=OpenStack1
MYSQL_PASS=Welcome123
SERVICE_ID=`keystone tenant-get service | awk '$2~/^id/{print $4}'`
#
eth0_address=`/sbin/ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
eth1_address=`/sbin/ifconfig eth1 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
MASTER=$eth0_address
LOCAL_IP=$eth1_address
GATEWAY_IP=192.168.1.1

echo "########## CAI DAT NEUTRON TREN CONTROLLER################"
sleep 5
apt-get install -y neutron-server neutron-common neutron-plugin-openvswitch-agent openvswitch-datapath-dkms neutron-l3-agent neutron-dhcp-agent neutron-plugin-ml2 

######## SAO LUU CAU HINH NEUTRON.CONF CHO CONTROLLER##################"
echo "############ SUA FILE CAU HINH  NEUTRON CHO CONTROLLER##########"
sleep 7

#
controlneutron=/etc/neutron/neutron.conf
test -f $controlneutron.orig || cp $controlneutron $controlneutron.orig
rm $controlneutron
touch $controlneutron
cat << EOF >> $controlneutron
[DEFAULT]
state_path = /var/lib/neutron
lock_path = \$state_path/lock
core_plugin = ml2
service_plugins = router
auth_strategy = keystone
allow_overlapping_ips = True
rpc_backend = neutron.openstack.common.rpc.impl_kombu

rabbit_host = $MASTER
rabbit_password = $ADMIN_PASS
rabbit_userid = guest

notification_driver = neutron.openstack.common.notifier.rpc_notifier
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True
nova_url = http://$MASTER:8774/v2
nova_admin_username = nova
nova_admin_tenant_id = $SERVICE_ID
nova_admin_password = $ADMIN_PASS
nova_admin_auth_url = http://$MASTER:35357/v2.0

[quotas]

[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf

[keystone_authtoken]
auth_host = 127.0.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = $ADMIN_PASS
signing_dir = \$state_path/keystone-signing

[database]
connection = mysql://neutron:$MYSQL_PASS@$MASTER/neutron
[service_providers]
service_provider=LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
service_provider=VPN:openswan:neutron.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default

EOF


######## SAO LUU CAU HINH ML2 CHO CONTROLLER##################"
echo "############ SUA FILE CAU HINH  ML2 CHO CONTROLLER##########"
sleep 7

controlML2=/etc/neutron/plugins/ml2/ml2_conf.ini
test -f $controlML2.orig || cp $controlML2 $controlML2.orig
rm $controlML2
touch $controlML2

cat << EOF >> $controlML2
[ml2]
type_drivers = gre
tenant_network_types = gre
mechanism_drivers = openvswitch

[ml2_type_flat]

[ml2_type_vlan]

[ml2_type_gre]
tunnel_id_ranges = 1:1000

[ml2_type_vxlan]

[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

[ovs]
local_ip = $LOCAL_IP
tunnel_type = gre
enable_tunneling = True

EOF


######## SAO LUU CAU HINH METADATA CHO CONTROLLER##################"
echo "############ SUA FILE CAU HINH  METADATA ##############"
sleep 7

metadatafile=/etc/neutron/metadata_agent.ini
test -f $metadatafile.orig || cp $metadatafile $metadatafile.orig
rm $metadatafile
touch $metadatafile
cat << EOF >> $metadatafile
[DEFAULT]
verbose = True 
auth_url = http://localhost:5000/v2.0
auth_region = RegionOne
admin_tenant_name = service
admin_user = neutron
admin_password = $ADMIN_PASS
nova_metadata_ip = $MASTER
metadata_proxy_shared_secret = $METADATA_SECRET

EOF

######## SUA FILE CAU HINH  DHCP ##################"
echo "############ SUA FILE CAU HINH  DHCP #################"
sleep 7

dhcpfile=/etc/neutron/dhcp_agent.ini 
test -f $dhcpfile.orig || cp $dhcpfile $dhcpfile.orig
rm $dhcpfile
touch $dhcpfile
cat << EOF >> $dhcpfile
[DEFAULT]
verbose = True 
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True

EOF

###################### SAO LUU CAU HINH L3 ###########################"
echo "############ SUA FILE CAU HINH  L3 ####################"
sleep 7


l3file=/etc/neutron/l3_agent.ini
test -f $l3file.orig || cp $l3file $l3file.orig
rm $l3file
touch $l3file
cat << EOF >> $l3file
[DEFAULT]
verbose = True 
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
use_namespaces = True

EOF

echo "###################KHOI DONG LAI NEUTRON ###############################"
sleep 4
cd /etc/init.d/; for i in $( ls neutron-* ); do sudo service $i restart; done

echo "###################KHOI DONG LAI NEUTRON ###############################"
sleep 10 
cd /etc/init.d/; for i in $( ls neutron-* ); do sudo service $i restart; done
cd /root/


echo "###################KIEM TRA NEUTRON####################"
sleep 25
neutron agent-list
