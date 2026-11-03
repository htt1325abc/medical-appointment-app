# Figma UI Source of Truth & Flutter FE Plan

> Trạng thái: baseline đã chốt cho kiến trúc màn hình và thứ tự triển khai. Các giá trị pixel/hex/font chưa đọc được từ layer Figma được đánh dấu `TBD-FIGMA`, không tự suy đoán.

## 1. Nguồn tham chiếu

- Figma: [Untitled](https://www.figma.com/design/4Ejk0nWovXheXQwjLDJ6tB/Untitled?node-id=0-1&p=f&t=BsDPD6cdnM7RReZz-0)
- Node gốc: `0:1`
- Kích thước canvas công khai: khoảng `7240 x 3599`
- Ngày ghi nhận: `2026-11-03`
- Báo cáo nghiệp vụ: `/home/huynhtuantu/Downloads/laptrinhdidong.docx`

### Mức độ tin cậy

- **Đã xác minh:** bố cục tổng thể canvas, các cụm màn hình, hướng màu sắc, kiểu card/form/button và phạm vi ba vai trò.
- **Đã đối chiếu với báo cáo:** luồng đăng nhập, tìm bác sĩ/bệnh viện/chuyên khoa, đặt lịch, quản lý lịch, đánh giá, bác sĩ xử lý lịch và admin CRUD.
- **Chưa đóng đinh:** mã màu, font family/weight, spacing, radius, shadow, kích thước icon và nội dung chữ nhỏ. Editor Figma không render trên máy hiện tại do WebGL; thumbnail công khai không đủ độ phân giải để đo chính xác.

Tài liệu này là nơi ghi nhớ duy nhất cho cấu trúc UI. Không cần mở lại toàn bộ Figma để lập kế hoạch hoặc dựng luồng; chỉ mở layer Figma khi cần thay các mục `TBD-FIGMA` bằng số đo chính xác.

## 2. Kết luận thiết kế từ canvas

Canvas dùng ngôn ngữ mobile UI sáng, nhẹ và thân thiện với y tế:

- Nền chủ đạo trắng hoặc pastel rất nhạt.
- Màu hành động chính nằm trong dải xanh lam/xanh ngọc; trạng thái phụ dùng xanh lá, cam/coral và trung tính.
- Form field có viền mảnh, nền sạch, bo góc vừa phải.
- Button chính dạng khối bo góc, tương phản rõ; button phụ nhẹ hơn.
- Card bác sĩ, bệnh viện và lịch hẹn dùng ảnh/avatar, tiêu đề, metadata ngắn và trạng thái dễ quét.
- Các nhóm màn hình dùng sắc nền pastel khác nhau để phân vùng nhưng vẫn cùng hệ component.
- Không dùng hiệu ứng nặng; hierarchy đến từ khoảng trắng, cỡ chữ, màu và nhóm nội dung.

### Token policy

Figma luôn thắng khi có xung đột với token tạm trong code hoặc skill.

| Nhóm token | Giá trị triển khai |
| --- | --- |
| Primary / deep / ink | `#069ACA` / `#006DA5` / `#101B32` |
| Muted / soft / background / border | `#6F839E` / `#EDF7FC` / `#FAFDFF` / `#DCE8F0` |
| Success / danger / warning | `#20C98B` / `#F85663` / `#FFAF1A` |
| Font family và type scale | Inter; `10 / 11 / 12 / 14 / 16 / 18 / 20 / 24 / 28 / 32` |
| Spacing scale | Hệ 4/8; form content rộng `345`, lề ngang `24`, gap chính `16` |
| Radius | Input `10`; mobile presentation frame `24`; các radius khác tiếp tục đọc theo component |
| Icon set | Icon nét đồng nhất theo Design System MediCare+; Flutter dùng Material equivalents khi không có SVG riêng |

Không lấy màu trực tiếp từ thumbnail bằng công cụ eyedropper vì ảnh đã bị scale/compress.

## 3. Bản đồ màn hình

Tên route bên dưới là chuẩn kỹ thuật cho Flutter; tên frame Figma có thể khác.

### Shared và authentication

| Route đề xuất | Mục tiêu | Thành phần chính |
| --- | --- | --- |
| `/splash` | Khởi tạo phiên đăng nhập | Logo, loading, lỗi khởi tạo |
| `/onboarding` | Giới thiệu giá trị ứng dụng | Illustration, pager, bỏ qua/tiếp tục |
| `/auth/sign-in` | Đăng nhập | Email/số điện thoại, mật khẩu, quên mật khẩu |
| `/auth/sign-up` | Tạo tài khoản | Thông tin cơ bản, mật khẩu, điều khoản |
| `/auth/verify-otp` | Xác minh tài khoản | OTP, đếm ngược, gửi lại mã |
| `/auth/forgot-password` | Yêu cầu đặt lại mật khẩu | Email/số điện thoại, trạng thái đã gửi |
| `/auth/reset-password` | Đặt mật khẩu mới | Mật khẩu, xác nhận, success state |

### Patient

| Route đề xuất | Mục tiêu | Trạng thái/CTA bắt buộc |
| --- | --- | --- |
| `/patient/home` | Bắt đầu tìm dịch vụ khám | Search, specialty, doctor/hospital nổi bật |
| `/patient/search` | Tìm và lọc | Query, filter, sort, empty/error |
| `/patient/specialties` | Chọn chuyên khoa | Grid/list, selected state |
| `/patient/specialties/:id/doctors` | Xem bác sĩ theo chuyên khoa | Doctor cards, filter |
| `/patient/doctors/:id` | Đánh giá bác sĩ trước khi đặt | Profile, chuyên môn, nơi khám, rating, `Đặt lịch` |
| `/patient/hospitals/:id` | Xem bệnh viện | Thông tin, địa chỉ, chuyên khoa/bác sĩ |
| `/patient/booking/:doctorId` | Chọn ngày và khung giờ | Calendar, available/unavailable slot, timezone |
| `/patient/booking/review` | Kiểm tra trước khi gửi | Bác sĩ, bệnh nhân, ngày giờ, ghi chú, `Gửi yêu cầu` |
| `/patient/booking/result` | Thông báo kết quả gửi yêu cầu | Pending state, hướng dẫn bước tiếp theo |
| `/patient/appointments` | Theo dõi các lịch hẹn | Upcoming/history tabs, status filter |
| `/patient/appointments/:id` | Xem/hủy lịch | Timeline trạng thái, lý do, CTA theo state |
| `/patient/reviews/new` | Đánh giá sau khám | Rating, comment, validation |
| `/patient/profile` | Xem và sửa hồ sơ | Thông tin cá nhân, avatar, đăng xuất |

### Doctor

| Route đề xuất | Mục tiêu | Trạng thái/CTA bắt buộc |
| --- | --- | --- |
| `/doctor/home` | Tổng quan công việc hôm nay | Số lịch chờ, đã xác nhận, lịch kế tiếp |
| `/doctor/appointments` | Quét và lọc yêu cầu | Date/status filter, patient/time/status |
| `/doctor/appointments/:id` | Xử lý một yêu cầu | Thông tin bệnh nhân, ghi chú, `Xác nhận`/`Từ chối` |
| `/doctor/schedule` | Quản lý lịch làm việc | Calendar, slots, unavailable state |
| `/doctor/profile` | Cập nhật hồ sơ chuyên môn | Chuyên khoa, bệnh viện, kinh nghiệm, mô tả |

### Admin

| Route đề xuất | Mục tiêu | Hành vi responsive |
| --- | --- | --- |
| `/admin/dashboard` | Tổng quan dữ liệu | Cards/charts; grid rộng, stack hẹp |
| `/admin/doctors` | Quản lý bác sĩ | Search/filter/table, CRUD, confirm delete |
| `/admin/patients` | Quản lý bệnh nhân | Search/filter/table, xem chi tiết |
| `/admin/hospitals` | Quản lý bệnh viện | Search/list, add/edit/delete |
| `/admin/specialties` | Quản lý chuyên khoa | Search/list, add/edit/delete |
| `/admin/appointments` | Giám sát lịch hẹn | Status/date filters, read-only detail mặc định |

## 4. Luồng nghiệp vụ cần giữ đúng

### Đặt lịch

`Chọn bác sĩ -> Chọn ngày -> Chọn slot còn trống -> Kiểm tra thông tin -> Gửi yêu cầu -> Pending`

- Gửi yêu cầu không đồng nghĩa với đã xác nhận.
- Chỉ backend/repository quyết định slot còn khả dụng ở bước submit cuối.
- Nếu slot vừa bị người khác lấy, giữ lại thông tin hợp lệ và yêu cầu chọn slot khác.
- Không hiển thị thanh toán cho MVP vì báo cáo chưa định nghĩa nghiệp vụ thanh toán đầy đủ.

### Trạng thái lịch hẹn

`draft -> pending -> confirmed -> completed`

Nhánh phụ: `pending -> rejected`; `pending|confirmed -> cancelled`.

Mỗi status phải có label, màu, mô tả “ai cần làm gì tiếp theo” và tập CTA riêng. Chỉ cho phép đánh giá khi `completed`.

### Doctor decision

- Xác nhận và từ chối là hai hành động tách biệt.
- Từ chối cần chọn/nhập lý do.
- Sau thao tác phải cập nhật list/detail nhất quán và có feedback rõ.

## 5. Component inventory

Tạo component chung trước feature screen:

- `AppScaffold`, `AppTopBar`, responsive navigation/bottom navigation.
- `PrimaryButton`, `SecondaryButton`, `DestructiveButton`, loading/disabled variants.
- `AppTextField`, password/OTP/search fields, validation message.
- `DoctorCard`, `HospitalCard`, `SpecialtyTile`, `AppointmentCard`.
- `StatusChip`, `RatingSummary`, `EmptyState`, `ErrorState`, `OfflineBanner`.
- `DateSelector`, `TimeSlotGrid`, `BookingSummary`, `AppointmentTimeline`.
- `ConfirmDialog`, `BottomSheet`, `Toast/Snackbar` wrapper.
- Admin: `DataTableShell`, filter bar, pagination, responsive CRUD form.

Mỗi component phải có states: default, pressed/focused, disabled, loading, error (nếu áp dụng). Touch target tối thiểu 48 x 48 logical pixels.

## 6. Kiến trúc Flutter FE

```text
lib/
  app/                 # router, app shell, bootstrap
  core/
    design_system/     # tokens, theme, typography, components
    models/            # shared domain models
    routing/
    utils/
  features/
    auth/
    patient/
    doctor/
    admin/
  data/
    repositories/      # interfaces + mock/API implementations
    services/
```

- Dùng view/view-model hoặc controller/repository; widget không chứa business logic.
- Bắt đầu với mock repositories để hoàn thiện UX độc lập backend.
- Dùng typed routing và route guard theo role.
- Theme/tokens là nguồn duy nhất cho màu, type, spacing, radius và elevation.
- Model UI phải biểu diễn loading/content/empty/error/offline rõ ràng.

## 7. Kế hoạch triển khai

### Phase 0 — Design foundation

- Trích xuất token chính xác từ Figma vào `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`.
- Dựng theme, router shell, responsive breakpoints và component gallery.
- Chụp golden/screenshot baseline cho component quan trọng.

**Done:** token không hard-code trong feature; button/input/card/status có đủ states.

### Phase 1 — Auth và app shell

- Splash/onboarding, sign in/up, OTP, forgot/reset password.
- Navigation và route guard cho Patient/Doctor/Admin.
- Validation tiếng Việt, keyboard/large-text/accessibility checks.

### Phase 2 — Patient discovery

- Home, search/filter, specialty list, doctor/hospital detail.
- Mock data có empty/error/loading; skeleton không làm layout nhảy.

### Phase 3 — Booking và appointments

- Date/slot selection, review, pending result.
- Appointment list/detail, cancel, timeline và rating-after-completion.
- Unit test state machine; widget test happy path và slot-conflict path.

### Phase 4 — Doctor

- Dashboard/list/detail, confirm/reject, schedule và profile.
- Kiểm tra thao tác nguy hiểm, reason validation và dữ liệu sau mutation.

### Phase 5 — Admin responsive

- Dashboard và CRUD doctors/patients/hospitals/specialties.
- Table ở wide layout; card/list ở narrow layout; search/filter/pagination giữ state.

### Phase 6 — Polish & handoff

- Visual QA ở 360 x 800, 412 x 915, 768 px và desktop admin.
- Kiểm tra contrast, semantics, focus order, text scale, keyboard, offline/error.
- `dart format`, `flutter analyze`, `flutter test` và golden tests.

## 8. Thứ tự ưu tiên MVP

1. Design system + auth shell.
2. Patient discovery.
3. Booking + appointment lifecycle.
4. Doctor processing.
5. Admin CRUD.
6. Ratings và polish.

AI chat, thanh toán, hồ sơ bệnh án đầy đủ và notification nâng cao không thuộc MVP cho tới khi có yêu cầu nghiệp vụ/API rõ ràng.

## 9. Checklist khi lấy được layer Figma

Chỉ cần cập nhật các mục này, không phải lập lại plan:

- [x] Tên font, type scale, title/body weight và line height nền tảng.
- [x] Hex của semantic colors chính và status colors.
- [x] Form width, page padding và gap nền tảng của auth.
- [ ] Radius, border width, shadow/elevation cho toàn bộ component ngoài auth.
- [ ] Kích thước icon/avatar/illustration và asset export.
- [ ] Frame-to-route mapping và copy chính xác từng màn hình.
- [ ] Prototype transitions, modal/bottom-sheet behavior.
- [ ] Cập nhật token policy trong skill nếu Figma thay đổi hướng thị giác.

## 10. Quyết định đã chốt

- Flutter FE dùng một design system chung cho ba role.
- Figma là nguồn sự thật về visual; báo cáo là nguồn nghiệp vụ tham khảo, không sao chép các mâu thuẫn của báo cáo.
- MVP không giả định thanh toán hoặc AI chat.
- Appointment request bắt đầu ở `pending`, không phải `confirmed`.
- Tất cả màn hình dữ liệu có loading, empty, error, offline và retry.
- UI copy chính là tiếng Việt; code/route/model dùng tiếng Anh.
- Mỗi phase phải qua analyzer, test và visual QA trước khi chuyển phase.
