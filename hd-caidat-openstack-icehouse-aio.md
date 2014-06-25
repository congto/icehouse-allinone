# Hướng dẫn cài đặt bằng script OpenStack Icehouse AIO

**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Hướng dẫn cài đặt bằng script OpenStack Icehouse AIO](#user-content-h%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-c%C3%A0i-%C4%91%E1%BA%B7t-b%E1%BA%B1ng-script-openstack-icehouse-aio)
- [Thông tin LAB](#user-content-th%C3%B4ng-tin-lab)
- [Các bước cài đặt](#user-content-c%C3%A1c-b%C6%B0%E1%BB%9Bc-c%C3%A0i-%C4%91%E1%BA%B7t)
	- [Cài đặt Ubuntu 12.04 trong Vmware Workstation](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-ubuntu-1204-trong-vmware-workstation)
	- [Thực hiện các script](#user-content-th%E1%BB%B1c-hi%E1%BB%87n-c%C3%A1c-script)
		- [Update hệ thống và cài đặt các gói bổ trợ](#user-content-update-h%E1%BB%87-th%E1%BB%91ng-v%C3%A0-c%C3%A0i-%C4%91%E1%BA%B7t-c%C3%A1c-g%C3%B3i-b%E1%BB%95-tr%E1%BB%A3)
		- [Cài đặt MYSQL và tạo DB cho các thành phần](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-mysql-v%C3%A0-t%E1%BA%A1o-db-cho-c%C3%A1c-th%C3%A0nh-ph%E1%BA%A7n)
		- [Cài đặt KEYSTONE](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-keystone)
		- [Khai báo user, role, tenant, endpoint](#user-content-khai-b%C3%A1o-user-role-tenant-endpoint)
		- [Cài đặt GLANCE](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-glance)
		- [Cài đặt NOVA và kiểm tra hoạt động](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-nova-v%C3%A0-ki%E1%BB%83m-tra-ho%E1%BA%A1t-%C4%91%E1%BB%99ng)
		- [Cài đặt CINDER](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-cinder)
		- [Cài đặt OpenvSwich, cấu hình br-int, br-ex](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-openvswich-c%E1%BA%A5u-h%C3%ACnh-br-int-br-ex)
		- [Cài đặt NEUTRON](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-neutron)
		- [Cài đặt HORIZON](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-horizon)
		- [Tạo các subnet, router cho tenant](#user-content-t%E1%BA%A1o-c%C3%A1c-subnet-router-cho-tenant)
- [Chuyển qua hướng dẫn sử dụng dashboard (horizon)](#user-content-chuy%E1%BB%83n-qua-h%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-s%E1%BB%AD-d%E1%BB%A5ng-dashboard-horizon)

# Thông tin LAB
- Cài đặt OpenStack Icehouse trên Ubuntu 12.04, môi trường giả lập vmware-workstation
- Các thành phần cài đặt trong OpenStack: Keystone, Glance, Nova (sử dụng KVM), Neutron, Horizon
- Neutron sử dụng plugin ML2, GRE và use case cho mô hình mạng là per-teanant per-router
- Máy ảo sử dụng 2 Nics. Eth0 dành cho Extenal, API, MGNT. Eth1 dành cho Internal.

# Các bước cài đặt
## Cài đặt Ubuntu 12.04 trong Vmware Workstation

Thiết lập cấu hình cho Ubuntu Server 12.04 trong VMware Workstation hoặc máy vật lý như sau

- RAM 4GB
- 1st HDD (sda) 60GB cài đặt Ubuntu server 12.04-4
- 2nd HDD (sdb) Làm volume cho cinder
- 3rd HDD (sdv)) Dùng cho cấu hình swift
- NIC 1st : External - dùng chế độ bridge - Dải IP 192.168.1.0/24 - dùng để ra (vào) internet.
- NIC 2nd : Inetnal VM - dùng chế độ vmnet4 (cần setup trong vmware workstation trước khi cài Ubuntu - dải IP  192.168.10.0/24
- Mật khẩu cho tất cả các dịch vụ là Welcome123
- Cài đặt với quyền root

- Ảnh thiết lập cấu hình cho Ubuntu server

<img src=http://i.imgur.com/NpiF3HF.png width="60%" height="60%" border="1">

- Ảnh thiết lập network cho vmware workstation 

<img src=http://i.imgur.com/pNg16qO.png width="60%" height="60%" border="1">


## Thực hiện các script

Thực hiện tải gói gile và phân quyền cho các file sau khi tải từ github về:

    apt-get install git -y
    git clone https://github.com/congto/icehouse-allinone.git
    cd icehouse-allinone
    chmod +x *.sh

### Update hệ thống và cài đặt các gói bổ trợ

Thiết lập tên, khai báo file hosts, cấu hình ip address cho các NICs:

    bash 0-icehouse-aio-prepare.sh
   
Chú ý: Khi thưc hiện update hệ thống, nếu xuất hiện dòng dưới thì gõ ENTER để tiếp tục

    More info: https://wiki.ubuntu.com/ServerTeam/CloudArchive
    Press [ENTER] to continue or ctrl-c to cancel adding it

Sau khi thực hiện script trên xong, hệ thống sẽ khởi động lại. Lúc này bạn đăng nhập vào hệ thống và di chuyển vào thưc mục icehouse-allinone bằng lệnh:

    cd icehouse-allinone

### Cài đặt MYSQL và tạo DB cho các thành phần

Cài đặt MYSQL, tạo DB cho Keystone, Glance, Nova, Neutron:

    bash 1-icehouse-aio-install-mysql.sh

### Cài đặt KEYSTONE 

Cài đặt và cấu hình file keystone.conf:

    bash 2-icehouse-aio-instal-keystonel.sh

### Khai báo user, role, tenant, endpoint

Thực thi biến môi trường :

    eth0_address=`/sbin/ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
    MASTER=$eth0_address
    TOKEN_PASS=Welcome123
    export OS_SERVICE_TOKEN=$TOKEN_PASS
    export OS_SERVICE_ENDPOINT=http://$MASTER:35357/v2.0

Khai báo user, role, teant và endpoint cho các service trong OpenStack:

    bash 3-icehouse-aio-creatusetenant.sh

Chạy lệnh để hủy biến môi trường:

    unset OS_SERVICE_ENDPOINT OS_SERVICE_TOKEN

Thực thi lệnh source /etc/profile để khởi tạo biến môi trường:

    source /etc/profile
   
Script trên thực hiện tạo các teant có tên là admin, demo, service. Tạo ra service có tên là keystone, glance, nova, cinder, neutron swift

### Cài đặt GLANCE

Cài đặt GLACE và add image cirros để kiểm tra hoạt động của Glance sau khi cài:

    bash 4-icehouse-aio-glance.sh

Script trên thực hiện cài đặt và cấu hình Glance. Sau đó thực hiển tải image cirros (một dạng lite lunix), có tác dụng để kiểm tra các 
hoạt động của Keystone, Glance và sau này dùng để khởi tạo máy ảo.

### Cài đặt NOVA và kiểm tra hoạt động
----
Cài đặt các gói về nova:

    bash 5-icehouse-aio-install-nova.sh

### Cài đặt CINDER
----
Cài đặt các gói cho CINDER, cấu hình volume group:

    bash 6-icehouse-aio-install-cinder
   
### Cài đặt OpenvSwich, cấu hình br-int, br-ex

Cài đặt OpenvSwtich và cấu hình br-int, br-ex cho Ubuntu:

    bash 7-icehouse-aio-config-ip-neutron.sh
  
### Cài đặt NEUTRON
Cài đặt Neutron Server, ML, L3-agent, DHCP-agent, metadata-agent:

    bash 8-icehouse-aio-install-neutron.sh

### Cài đặt HORIZON
Cài đặt Horizon để cung cấp GUI cho người dùng thao tác với OpenStack:

    bash 9-icehouse-aio-install-horizon.sh

### Tạo các subnet, router cho tenant
Tạo sẵn subnet cho Public Network và Private Network trong teant ADMIN:

    bash 99-creat-network.sh

# Chuyển qua hướng dẫn sử dụng dashboard (horizon)
Truy cập vào dashboard với IP 192.168.1.55/horizon

	User: admin hoặc demo
	Pass: Welcome123









