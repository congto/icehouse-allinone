#!/bin/sh -ex
#
SERVICE_PASSWORD=Welcome123
TOKEN_PASS=Welcome123
ADMIN_PASS=Welcome123
export OS_SERVICE_TOKEN=Welcome123
export OS_SERVICE_ENDPOINT="http://192.168.1.55:35357/v2.0"

 
ADMIN_PASSWORD=${ADMIN_PASSWORD:-$ADMIN_PASS}
export SERVICE_ENDPOINT="http://192.168.1.55:35357/v2.0"
SERVICE_TENANT_NAME=${SERVICE_TENANT_NAME:-service}

get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

# Tenants
ADMIN_TENANT=$(get_id keystone tenant-create --name=admin)
SERVICE_TENANT=$(get_id keystone tenant-create --name=$SERVICE_TENANT_NAME)
DEMO_TENANT=$(get_id keystone tenant-create --name=demo)
INVIS_TENANT=$(get_id keystone tenant-create --name=invisible_to_admin)

# Users
ADMIN_USER=$(get_id keystone user-create --name=admin --pass="$ADMIN_PASSWORD" --email=congtt@teststack.com)
DEMO_USER=$(get_id keystone user-create --name=demo --pass="$ADMIN_PASSWORD" --email=congtt@teststack.com)

# Roles
ADMIN_ROLE=$(get_id keystone role-create --name=admin)
KEYSTONEADMIN_ROLE=$(get_id keystone role-create --name=KeystoneAdmin)
KEYSTONESERVICE_ROLE=$(get_id keystone role-create --name=KeystoneServiceAdmin)

# Add Roles to Users in Tenants
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $DEMO_TENANT
keystone user-role-add --user-id $ADMIN_USER --role-id $KEYSTONEADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone user-role-add --user-id $ADMIN_USER --role-id $KEYSTONESERVICE_ROLE --tenant-id $ADMIN_TENANT

# The Member role is used by Horizon and Swift
MEMBER_ROLE=$(get_id keystone role-create --name=Member)
keystone user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $DEMO_TENANT
keystone user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $INVIS_TENANT

# Configure service users/roles
NOVA_USER=$(get_id keystone user-create --name=nova --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=nova@teststack.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $ADMIN_ROLE

GLANCE_USER=$(get_id keystone user-create --name=glance --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=glance@teststack.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $GLANCE_USER --role-id $ADMIN_ROLE

SWIFT_USER=$(get_id keystone user-create --name=swift --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=swift@teststack.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $SWIFT_USER --role-id $ADMIN_ROLE

RESELLER_ROLE=$(get_id keystone role-create --name=ResellerAdmin)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $RESELLER_ROLE

NEUTRON_USER=$(get_id keystone user-create --name=neutron --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=neutron@teststack.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NEUTRON_USER --role-id $ADMIN_ROLE

CINDER_USER=$(get_id keystone user-create --name=cinder --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=cinder@teststack.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $CINDER_USER --role-id $ADMIN_ROLE


#/*Định nghĩa Services và API Endpoint
keystone service-create --name=keystone --type=identity --description="OpenStack Identity"
keystone endpoint-create \
--service-id=$(keystone service-list | awk '/ identity / {print $2}') \
--publicurl=http://192.168.1.55:5000/v2.0 \
--internalurl=http://192.168.1.55:5000/v2.0 \
--adminurl=http://192.168.1.55:35357/v2.0

keystone service-create --name=glance --type=image --description="OpenStack Image Service"
keystone endpoint-create \
--service-id=$(keystone service-list | awk '/ image / {print $2}') \
--publicurl=http://192.168.1.55:9292 \
--internalurl=http://192.168.1.55:9292 \
--adminurl=http://192.168.1.55:9292

keystone service-create --name=nova --type=compute --description="OpenStack Compute"
keystone endpoint-create \
--service-id=$(keystone service-list | awk '/ compute / {print $2}') \
--publicurl=http://192.168.1.55:8774/v2/%\(tenant_id\)s \
--internalurl=http://192.168.1.55:8774/v2/%\(tenant_id\)s \
--adminurl=http://192.168.1.55:8774/v2/%\(tenant_id\)s

keystone service-create --name neutron --type network --description "OpenStack Networking"
keystone endpoint-create \
--service-id $(keystone service-list | awk '/ network / {print $2}') --publicurl http://192.168.1.55:9696 \
--adminurl http://192.168.1.55:9696 \
--internalurl http://192.168.1.55:9696

# keystone service-create --name=cinder --type=volume --description="OpenStack Block Storage"
# keystone endpoint-create \
# --service-id=$(keystone service-list | awk '/ volume / {print $2}') \
# --publicurl=http://192.168.1.55:8776/v1/%\(tenant_id\)s \
# --internalurl=http://192.168.1.55:8776/v1/%\(tenant_id\)s \
# --adminurl=http://192.168.1.55:8776/v1/%\(tenant_id\)s

# keystone service-create --name=cinderv2 --type=volumev2 --description="OpenStack Block Storage v2"
# keystone endpoint-create \
# --service-id=$(keystone service-list | awk '/ volumev2 / {print $2}') \
# --publicurl=http://192.168.1.55:8776/v2/%\(tenant_id\)s \
# --internalurl=http://192.168.1.55:8776/v2/%\(tenant_id\)s \
# --adminurl=http://192.168.1.55:8776/v2/%\(tenant_id\)s

sleep 5
echo "###########TAO FILE CHO BIEN MOI TRUONG##################"
echo "export OS_USERNAME=admin" > admin-openrc.sh
echo "export OS_PASSWORD=Welcome123" >> admin-openrc.sh
echo "export OS_TENANT_NAME=admin" >> admin-openrc.sh
echo "export OS_AUTH_URL=http://192.168.1.55:35357/v2.0" >> admin-openrc.sh

# Xoa bien moi truong truoc do
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
chmod +x admin-openrc.sh

sleep 5
echo "#################### Thuc thi bien moi truong ##################"
cat  admin-openrc.sh >> /etc/profile
source /etc/profile

cp  admin-openrc.sh /root/admin-openrc.sh

echo echo "#################### Hoan thanh cai dat keystone ##################"

echo "#################### Kiem tra bien moi truong ##################"
sleep 5
keystone user-list
