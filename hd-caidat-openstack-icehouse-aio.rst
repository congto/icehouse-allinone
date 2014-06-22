================================
Hướng dẫn cài đặt bằng script OpenStack Icehouse AIO
================================

.. contents::


I. Thông tin LAB
============
- Cài đặt OpenStack Icehouse trên Ubuntu 12.04, môi trường giả lập vmware-workstation
- Các thành phần cài đặt trong OpenStack: Keystone, Glance, Nova (sử dụng KVM), Neutron, Horizon
- Neutron sử dụng plugin ML2, GRE và use case cho mô hình mạng là per-teanant per-router
- Máy ảo sử dụng 2 Nics. Eth0 dành cho Extenal, API, MGNT. Eth1 dành cho Internal.

II. Các bước cài đặt
============

1. Cài đặt Ubuntu 12.04 trong Vmware Workstation
----------
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
.. image:: http://i.imgur.com/3krYzVu.png

- Ảnh thiết lập network cho vmware workstation 
.. image:: http://i.imgur.com/pNg16qO.png

2. Thực hiện các script
----------

Thực hiện tải gói gile và phân quyền cho các file sau khi tải từ github về::

   apt-get install git -y
   
   git clone https://github.com/congto/icehouse-allinone.git
   
   cd icehouse-allinone
   
   chmod +x *.sh

2.0 Update hệ thống và cài đặt các gói bổ trợ
-----------------
Thiết lập tên, khai báo file hosts, cấu hình ip address cho các NICs::

   bash 0-icehouse-aio-prepare.sh

Chú ý: Khi thưc hiện update hệ thống, nếu xuất hiện dòng dưới thì gõ ENTER để tiếp tục::

   More info: https://wiki.ubuntu.com/ServerTeam/CloudArchive
   Press [ENTER] to continue or ctrl-c to cancel adding it

Sau khi thực hiện script trên xong, hệ thống sẽ khởi động lại. Lúc này bạn đăng nhập vào hệ thống và di chuyển vào thưc mục icehouse-allinone bằng lệnh::

    cd icehouse-allinone

2.1 Cài đặt MYSQL và tạo DB cho các thành phần
-----------------
Cài đặt MYSQL, tạo DB cho Keystone, Glance, Nova, Neutron::
  
   bash 1-icehouse-aio-install-mysql.sh

2.2 Cài đặt keystone 
-----------------
Cài đặt và cấu hình file keystone.conf::
  
   bash 2-icehouse-aio-instal-keystonel.sh

2.3 Khai báo user, role, tenant, endpoint
----
Khai báo user, role, teant và endpoint cho các service trong OpenStack::

   bash 3-icehouse-aio-creatusetenant.sh

2.4 Cài đặt glance
----
Cài đặt GLACE và add image cirros để kiểm tra hoạt động của Glance sau khi cài::

   bash 4-icehouse-aio-glance.sh

2.5 Cài đặt NOVA và kiểm tra hoạt động
----
Cài đặt các gói về nova::

   bash 5-icehouse-aio-nova.sh
