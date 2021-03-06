# Chú ý: 30/06/2014

Hiện hướng dẫn này đã được chuyển về repos của cộng đồng VIETSTACK để được hoàn thiện hơn. Mình tạm dừng hỗ trợ repos này để tập trung vào phiên bản cài đặt mới và hoàn chỉnh hơn tại link github sau:

https://github.com/vietstacker/icehouse-aio-ubuntu

Cám ơn sự quan tâm của các bạn !

<!---
# Cài đặt & HDSD OpenStack Icehouse AIO
- Phiên bản: Nhiệt và đam mê. 22/06/2014
- Người tổng hợp: tu0ng_c0ng và những người bạn.

## Giới thiệu
Hướng dẫn này được cung cấp giúp các bạn đã tìm hiểu tổng quan về Cloud Computing (dựa theo định nghĩa trong tài liệu NIST - Cloud Computing) và OpenStack có thể triển khai một cách gọn gàng và đủ tính năng tối thiểu cho mục đích trải nghiệm và tìm hiểu cách sử dụng OpenStack.

Hướng dẫn được triển khai trên môi trường LAB (VMware Workstation), trên 1 máy chủ duy nhất có hỗ trợ công nghệ ảo hóa, x64. Trong phiên bản "Nhiệt & Đam Mê" của hướng dẫn này, mình tham khảo nguồn chính là docs của OpenStack và GOOGLE nên xin phép không trích dẫn lại các link khác ở đây. Một số script mình có chỉnh sửa lại đê tối giản các dòng lệnh và giải thích trong từng script.

Theo docs OpenStack, mô hình chuẩn là 03 node (Controller, Compute, Network) nếu sử dụng Neutron cho thành phần Networking. Nhưng vì nhiều bạn mới tìm hiểu không đủ tài nguyên để triển khai và một số bạn muốn tham gia phát triển các project hoặc tìm hiểu các tùy chọn cho cấu hình do vậy mình quyết định tổng hợp hướng dẫn này trên một node (một máy chủ duy nhất).

Các core project trong phiên bản hướng dẫn này gồm: KEYSTONE, GLANCE, NOVA, NEUTRON, CINDER, HORIZON. Trong phiên bản tiếp theo mình sẽ bổ sung các project khác của OpenStack sau khi test thành công.

Trong các script mình có sao lưu các file cấu hình gốc, sử dụng các lệnh về thao tác chuỗi, phân quyền, khai báo biến .... để thực hiện việc cấu hình cho OpenStack, các bạn có thể tham khảo trong từng script.

Liên hệ và trao đổi:

    Email: tcvn1985@gmail.com
    Skype: tu0ng_c0ng
    Twitter: twitter.com/tothanhcong
    Facebook: facebook.com/tcvn1985

-->
## [Hướng dẫn cài đặt OpenStack AIO](https://github.com/vietstacker/icehouse-aio-ubuntu/blob/master/hd-caidat-openstack-icehouse-aio.md)

<!--
## [Hướng dẫn sử dụng OpenStack AIO](hd-sudung-openstack-icehouse-aio.rst)
-->

