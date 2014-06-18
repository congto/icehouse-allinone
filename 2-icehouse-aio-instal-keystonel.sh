#!/bin/bash -ex
#
# Khoi tao bien
TOKEN_PASS=Welcome123
MYSQL_PASS=Welcome123
ADMIN_PASS=Welcome123
MASTER=192.168.1.55
# Cai dat keystone
apt-get install keystone -y


#/* Sao luu truoc khi sua file nova.conf
filekeystone=/etc/keystone/keystone.conf
test -f $filekeystone.orig || cp $filekeystone $filekeystone.orig

#Chen noi dung file /etc/keystone/keystone.conf
cat << EOF > $filekeystone
[DEFAULT]
admin_token=$SERVICE_PASSWORD
public_bind_host=0.0.0.0
admin_bind_host=0.0.0.0
compute_port=8774
admin_port=35357
public_port=5000
verbose=True
[assignment]
[auth]
[cache]
[catalog]
[credential]
[database]
connection = mysql://keystone:$MYSQL_PASS@$MASTER/keystone
idle_timeout=3600
[ec2]
[endpoint_filter]
[federation]
[identity]
[kvs]
[ldap]
[matchmaker_ring]
[memcache]
[oauth1]
[os_inherit]
[paste_deploy]
[policy]
[revoke]
[signing]
[ssl]
[stats]
[token]
[trust]
[extra_headers]
Distribution = Ubuntu

EOF
#
# Xoa DB mac dinh
rm  /var/lib/keystone/keystone.db

#Khoi dong lai MYSQL
service keystone restart
sleep 3
service keystone restart

# Dong bo cac bang trong DB
keystone-manage db_sync

(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' >> /var/spool/cron/crontabs/keystone

export OS_SERVICE_TOKEN=Welcome123
export OS_SERVICE_ENDPOINT=http://$MASTER:35357/v2.0
