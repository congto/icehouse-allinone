================================
Hướng dẫn cài đặt bằng script OpenStack Icehouse AIO
================================

.. contents::


Thông tin LAB
- Cài đặt OpenStack Icehouse trên Ubuntu 12.04, môi trường giả lập vmware-workstation
- Các thành phần cài đặt trong OpenStack: Keystone, Glance, Nova (sử dụng KVM), Neutron, Horizon
- Neutron sử dụng plugin ML2, GRE và use case cho mô hình mạng là per-teanant per-router
- Máy ảo sử dụng 2 Nics. Eth0 dành cho Extenal, API, MGNT. Eth1 dành cho Internal.


Các bước cài đặt
===================

Cài đặt ubuntu server 12.04 với thông số như sau
----------

- RAM 4GB
- HDD 80GB
- NICs 02 (ETH0 dùng chế độ bridge, ETH1 dùng VMnet hoặc host only. Chú ý đứng từ máy vật lý có thể truy cập được vào máy ảo bằng cả 2 NICs)
- Mật khẩu cho tất cả các dịch vụ là Welcome123
- Cài đặt với quyền root 


Thực hiện các script
----------

Update hệ thống và cài đặt các gói bổ trợ
----
  + bash 0-icehouse-aio-prepare.sh

Cài đặt MYSQL và tạo DB cho các thành phần
----
  + bash 1-icehouse-aio-install-mysql.sh

Cài đặt keystone 
----
  + bash 2-icehouse-aio-instal-keystonel.sh

Khai báo user, role, teant và endpoint cho các service trong OpenStack
----
  + bash 3-icehouse-aio-creatusetenant.sh

Cài đặt GLACE và add image cirros để kiểm tra hoạt động của Glance sau khi cài
----
  + bash 4-icehouse-aio-glance.sh

Cài đặt NOVA và kiểm tra hoạt động
----
  + bash 5-icehouse-aio-nova.sh
