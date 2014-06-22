#!/bin/bash 
# Kiem tra lenh source trong shell

echo "###########TAO FILE CHO BIEN MOI TRUONG##################"
echo "export OS_cong=admin" > admin-openrc-demo.sh
# echo "export OS_PASSWORDcong=Welcome123" >> admin-openrc-demo.sh
# echo "export OS_TENANT_NAME=admin" >> admin-openrc-demo.sh
# echo "export OS_AUTH_URL=http://192.168.1.55:35357/v2.0" >> admin-openrc-demo.sh

# Xoa bien moi truong truoc do
# unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT

# Chay lai bien moi truoc 
source admin-openrc-demo.sh

sleep 5
echo "#################### Thuc thi bien moi truong ##################"
source admin-openrc-demo.sh

echo echo "#################### Hoan thanh cai dat keystone ##################"
