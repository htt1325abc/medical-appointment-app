# Kế hoạch triển khai toàn bộ FE còn lại — MediCare+

> Trạng thái: **Đang triển khai — Đợt 1 chờ duyệt trên thiết bị**  
> Cập nhật: 03/11/2026  
> Nguồn thiết kế chuẩn: [Figma MediCare+](https://www.figma.com/design/4Ejk0nWovXheXQwjLDJ6tB/Untitled?node-id=0-1&p=f&t=BsDPD6cdnM7RReZz-0)

## 1. Phạm vi đã chốt

- Chỉ triển khai **Flutter FE** theo Figma: giao diện, điều hướng, validation và tương tác cục bộ.
- Dùng dữ liệu mock có cấu trúc; không làm API, Firebase, database hay đăng nhập thật.
- Thanh toán, gọi video, bản đồ, thông báo đẩy và Chat AI chỉ mô phỏng UI/UX, không tích hợp SDK hoặc dịch vụ thật.
- Figma là nguồn chuẩn cho màu sắc, typography, khoảng cách, bo góc, icon, ảnh, nội dung và thứ tự luồng.
- Kích thước thiết kế gốc là **393 × 852**; đồng thời phải hiển thị tốt trên Xiaomi Mi 8 SE đang kết nối.

### Tình trạng hiện tại

| Vai trò | Tổng frame Figma | Đã hoàn thành | Còn lại |
|---|---:|---:|---:|
| Patient | 41 | 6 màn xác thực `05–10` | 35 |
| Doctor | 28 | 0 | 28 |
| Admin | 27 | 0 | 27 |
| **Tổng** | **96** | **6** | **90** |

Các màn Patient đã có: Tạo tài khoản, Đăng nhập, Quên mật khẩu, Nhập mã xác thực, Đặt lại mật khẩu và Hoàn tất đăng ký.

### Tiến độ hiện tại

- [x] `FE-00`: router, mock data, component trạng thái và screen catalog debug.
- [x] `PAT-01`: Splash và ba màn onboarding.
- [x] `PAT-02`: Home, tìm chuyên khoa, danh sách Nội khoa và hồ sơ bác sĩ.
- [ ] Đợt 1 được duyệt trên Xiaomi Mi 8 SE.
- [ ] Đợt 2 và các đợt tiếp theo.

## 2. Nguyên tắc triển khai

1. Làm theo thứ tự **Patient → Doctor → Admin → QA tổng thể**.
2. Mỗi task dùng chung Design System hiện có; không hard-code lại màu, font hoặc spacing trong từng màn.
3. Màn có dữ liệu phải chuẩn bị các trạng thái: loading, content, empty, error/offline và retry. Bản content theo đúng Figma là trạng thái mặc định khi demo.
4. Tất cả nút chính, tab, bộ lọc, form, dialog và back navigation phải hoạt động bằng state mock.
5. Không tự thêm chức năng sản phẩm ngoài Figma. Thành phần cần cho việc kiểm thử chỉ được đặt trong chế độ debug.
6. Mỗi đợt phải được kiểm tra trên Mi 8 SE và được duyệt trước khi chuyển sang đợt tiếp theo.

## 3. Task nền tảng dùng chung

### FE-00 — Hoàn thiện khung ứng dụng

- Chuẩn hóa router và route guard giả lập cho ba vai trò.
- Tách module theo `patient`, `doctor`, `admin`; dùng chung `core/theme`, `core/widgets`, `mock_data`.
- Tạo app shell, app bar, bottom navigation, list/card/form/dialog và các widget trạng thái dùng lại.
- Tạo dữ liệu mock typed cho bác sĩ, bệnh nhân, lịch hẹn, hồ sơ khám, đơn thuốc, thanh toán và thông báo.
- Thêm màn catalog chỉ trong `kDebugMode` để mở nhanh 90 màn khi nghiệm thu; không xuất hiện trong bản release.
- Chuẩn hóa ảnh local, placeholder, xử lý ảnh lỗi và accessibility semantics.

**Điều kiện xong:** router mở được từng feature, theme không lệch bản hiện có, không có màn demo rời rạc hoặc route chết.

## 4. Backlog Patient — 35 màn còn lại

### PAT-01 — Khởi động & giới thiệu (4 màn)

- `01 · Splash`
- `02 · Onboarding 1`
- `03 · Onboarding 2`
- `04 · Onboarding 3`

**Tương tác:** tự chuyển Splash, vuốt/tiếp tục/bỏ qua onboarding, lưu trạng thái đã xem bằng state cục bộ.

### PAT-02 — Trang chủ & tìm bác sĩ (4 màn)

- `11 · Xin chào, Nguyễn Thảo Ly`
- `12 · Tìm kiếm chuyên khoa`
- `13 · Nội khoa`
- `14 · Hồ sơ bác sĩ`

**Tương tác:** search, lọc chuyên khoa, chọn bác sĩ, CTA tư vấn/đặt lịch và bottom navigation.

### PAT-03 — Đặt lịch & thanh toán (4 màn)

- `15 · Chọn ngày khám`
- `16 · Xác nhận lịch hẹn`
- `17 · Chọn phương thức thanh toán`
- `18 · Thanh toán thành công`

**Tương tác:** chọn ngày/giờ, xác nhận thông tin, chọn phương thức, mô phỏng thanh toán thành công và quay về lịch hẹn.

### PAT-04 — Lịch hẹn của tôi (2 màn)

- `19 · Chi tiết lịch hẹn`
- `20 · Lịch hẹn của tôi`

**Tương tác:** tab trạng thái, lọc, mở chi tiết, hủy/đặt lại lịch bằng dialog và state mock.

### PAT-05 — Tư vấn & gọi video (3 màn)

- `21 · Tư vấn trực tuyến`
- `22 · BS. Trần Thị Lan`
- `23 · Gọi video với bác sĩ`

**Tương tác:** danh sách bác sĩ online, chat cục bộ, trạng thái đang nhập, giao diện cuộc gọi và các nút mic/kết thúc/camera.

### PAT-06 — Hồ sơ sức khỏe (6 màn)

- `24 · Kết quả khám`
- `25 · Chi tiết kết quả`
- `26 · Đơn thuốc`
- `27 · Hồ sơ sức khỏe`
- `28 · Chỉ số sức khỏe`
- `29 · Nhắc lịch uống thuốc`

**Tương tác:** lọc kết quả, xem chi tiết/tệp giả lập, xem đơn thuốc, chuyển hồ sơ, biểu đồ chỉ số, bật/tắt và chỉnh lịch nhắc thuốc.

### PAT-07 — Bệnh viện & kiến thức (4 màn)

- `30 · Kiến thức sức khỏe`
- `31 · Bệnh viện liên kết`
- `32 · Bệnh viện Đà Nẵng`
- `33 · Chỉ đường đến bệnh viện`

**Tương tác:** tab/chủ đề bài viết, tìm bệnh viện, mở chi tiết, UI bản đồ và chọn phương tiện; không gọi Maps API.

### PAT-08 — Tài khoản, thông báo & hỗ trợ (8 màn)

- `34 · Thông báo`
- `35 · Hồ sơ gia đình`
- `36 · Cài đặt tài khoản`
- `37 · Trung tâm hỗ trợ`
- `38 · Đánh giá ứng dụng`
- `39 · Giới thiệu ứng dụng`
- `40 · Cảm ơn bạn`
- `41 · Đăng xuất`

**Tương tác:** đọc/đánh dấu thông báo, đổi hồ sơ, chỉnh setting, FAQ/search, đánh giá sao, gửi phản hồi giả lập và xác nhận đăng xuất.

## 5. Backlog Doctor — 28 màn

### DOC-01 — Xác thực (7 màn)

- `D01 · Đăng nhập`
- `D24 · Đăng ký`
- `D25 · Quên mật khẩu`
- `D26 · Nhập mã xác thực`
- `D27 · Đặt lại mật khẩu`
- `D28 · Hoàn tất đăng ký`
- `D15 · Xác nhận đăng xuất`

### DOC-02 — Tài khoản & hồ sơ cá nhân (3 màn)

- `D02 · Đổi mật khẩu`
- `D13 · Cá nhân bác sĩ`
- `D14 · Cập nhật thông tin bác sĩ`

### DOC-03 — Trang chủ & thông báo (2 màn)

- `D03 · Trang chủ bác sĩ`
- `D21 · Thông báo`

### DOC-04 — Xem lịch hẹn (3 màn)

- `D04 · Danh sách lịch hẹn`
- `D16 · Lịch hẹn đã xác nhận`
- `D05 · Xem lịch khám`

### DOC-05 — Xử lý lịch hẹn (4 màn)

- `D06 · Chi tiết lịch hẹn (chờ xác nhận)`
- `D07 · Từ chối lịch hẹn`
- `D08 · Hủy lịch hẹn (đã xác nhận)`
- `D09 · Xác nhận lịch hẹn thành công`

### DOC-06 — Khám bệnh (4 màn)

- `D17 · Bệnh nhân của tôi`
- `D18 · Hồ sơ bệnh nhân`
- `D19 · Kê đơn thuốc`
- `D20 · Hoàn tất khám`

### DOC-07 — Tư vấn & Chat AI (3 màn)

- `D10 · Tư vấn sức khỏe`
- `D11 · Chat với bệnh nhân`
- `D12 · Chat với trợ lý AI`

### DOC-08 — Lịch làm việc & hỗ trợ (2 màn)

- `D23 · Lịch làm việc`
- `D22 · Trung tâm hỗ trợ`

**Tương tác chung Doctor:** tab/lọc lịch, xác nhận–từ chối–hủy bằng dialog, form hồ sơ/kê đơn, chat mock, toggle lịch làm việc và cập nhật hồ sơ bằng state cục bộ. Chat AI không gọi mô hình thật.

## 6. Backlog Admin — 27 màn

### ADM-01 — Xác thực (7 màn)

- `20 · Đăng nhập`
- `21 · Đăng ký`
- `22 · Quên mật khẩu`
- `23 · Nhập mã xác thực`
- `24 · Đặt lại mật khẩu`
- `25 · Hoàn tất đăng ký`
- `26 · Đăng xuất`

### ADM-02 — Tổng quan & thông báo (2 màn)

- `1 · Tổng quan quản trị`
- `14 · Thông báo`

### ADM-03 — Quản lý lịch hẹn (2 màn)

- `3 · Lịch hẹn`
- `2 · Chi tiết lịch hẹn`

### ADM-04 — Quản lý bác sĩ (4 màn)

- `7 · Bác sĩ`
- `5 · Chi tiết bác sĩ`
- `4 · Thêm bác sĩ`
- `6 · Lịch làm việc`

### ADM-05 — Quản lý bệnh nhân (2 màn)

- `8 · Bệnh nhân`
- `9 · Chi tiết bệnh nhân`

### ADM-06 — Chuyên khoa & đánh giá (3 màn)

- `15 · Chuyên khoa`
- `16 · Chi tiết chuyên khoa`
- `19 · Đánh giá`

### ADM-07 — Thanh toán, báo cáo & khuyến mãi (3 màn)

- `11 · Thanh toán`
- `12 · Báo cáo`
- `17 · Khuyến mãi`

### ADM-08 — Cài đặt & hệ thống (4 màn)

- `10 · Cài đặt`
- `13 · Thông báo đẩy`
- `18 · Phân quyền`
- `52 · Đổi mật khẩu`

**Tương tác chung Admin:** tìm kiếm/lọc, bảng–danh sách responsive, form thêm/sửa, toggle setting, phân quyền giả lập, biểu đồ báo cáo mock và dialog xác nhận. Không ghi dữ liệu ra server.

## 7. Chia đợt thực hiện và điểm duyệt

| Đợt | Task | Số màn | Nội dung bàn giao để duyệt |
|---|---|---:|---|
| 0 | FE-00 | — | Router, mock data, shell và screen catalog debug |
| 1 | PAT-01 + PAT-02 | 8 | Khởi động, onboarding, home, tìm kiếm, hồ sơ bác sĩ |
| 2 | PAT-03 + PAT-04 | 6 | Đặt lịch, thanh toán và quản lý lịch hẹn |
| 3 | PAT-05 + PAT-06 | 9 | Tư vấn, gọi video và hồ sơ sức khỏe |
| 4 | PAT-07 | 4 | Kiến thức, bệnh viện và chỉ đường |
| 5 | PAT-08 | 8 | Tài khoản, thông báo, hỗ trợ và đăng xuất |
| 6 | DOC-01 + DOC-02 | 10 | Xác thực và hồ sơ bác sĩ |
| 7 | DOC-03 + DOC-04 + DOC-05 | 9 | Dashboard và toàn bộ quản lý lịch hẹn bác sĩ |
| 8 | DOC-06 + DOC-07 + DOC-08 | 9 | Khám bệnh, chat, lịch làm việc và hỗ trợ |
| 9 | ADM-01 + ADM-02 | 9 | Xác thực, dashboard và thông báo Admin |
| 10 | ADM-03 + ADM-04 | 6 | Quản lý lịch hẹn và bác sĩ |
| 11 | ADM-05 + ADM-06 | 5 | Quản lý bệnh nhân, chuyên khoa và đánh giá |
| 12 | ADM-07 + ADM-08 | 7 | Thanh toán, báo cáo, khuyến mãi và hệ thống |
| 13 | FE-QA | 96 tổng | Rà soát toàn ứng dụng, accessibility, responsive và regression |

### Quy trình duyệt mỗi đợt

1. Hoàn thành code và kiểm tra tĩnh.
2. Chạy test liên quan và build APK debug.
3. Cài/chạy trên Xiaomi Mi 8 SE.
4. Duyệt trực tiếp từng màn và luồng chính; ghi nhận sai khác so với Figma.
5. Sửa hết lỗi của đợt, chụp lại màn trọng yếu.
6. Chỉ chuyển đợt tiếp theo sau khi nhận xác nhận duyệt.

Mỗi task hoặc đợt được commit riêng để dễ review và quay lại khi cần. Không push bản chưa qua kiểm tra cơ bản.

## 8. Definition of Done cho từng task

- Đúng hierarchy, nội dung, màu, font, kích thước, spacing, radius, icon và ảnh theo Figma.
- Màn 393 × 852 khớp thiết kế; Mi 8 SE không overflow, không chữ bị cắt và vùng chạm tối thiểu 44–48 px.
- Điều hướng tới/lui, bottom navigation, tab, form, dialog và CTA chính hoạt động bằng mock state.
- Có loading/content/empty/error-offline/retry cho màn dữ liệu.
- Có xử lý bàn phím, safe area, scroll, ảnh lỗi và text scale hợp lý.
- Không có logic backend trá hình hoặc secret/config dịch vụ ngoài.
- `flutter analyze` không lỗi; `flutter test` qua; APK debug build được.
- Đã đối chiếu Figma và kiểm tra trực tiếp trên Mi 8 SE.

## 9. Ngoài phạm vi

- API/backend, Firebase, database và đồng bộ dữ liệu thật.
- Xác thực thật, OTP thật, phân quyền server hoặc lưu token.
- Cổng thanh toán, video call, Maps/GPS, push notification và AI thật.
- Upload/download hồ sơ y tế thật.
- Web admin hoặc desktop layout riêng ngoài các frame mobile của Figma.

## 10. Điều kiện bắt đầu triển khai

Sau khi kế hoạch này được duyệt, bắt đầu từ **FE-00**, sau đó thực hiện **Đợt 1**. Mọi thay đổi phạm vi hoặc thứ tự phải được cập nhật lại ngay trong file này để đây luôn là nguồn theo dõi duy nhất.
