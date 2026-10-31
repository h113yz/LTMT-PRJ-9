# Hệ thống quản lý thực tập tốt nghiệp (ASP.NET Core 8)

Giải pháp gồm 3 dự án C#:

| Dự án | Vai trò |
|---|---|
| `src/QuanLyThucTap.Api` | ASP.NET Core Web API + EF Core. Chứa toàn bộ nghiệp vụ, phân quyền (JWT) và CSDL 13 bảng theo tài liệu thiết kế. Có Swagger. |
| `src/QuanLyThucTap.Web` | Giao diện web ASP.NET Core MVC (Razor + Bootstrap). Mọi thao tác đều gọi API bằng `HttpClient` (`Services/ApiClient.cs`). |
| `src/QuanLyThucTap.Shared` | DTO, hằng số vai trò/trạng thái dùng chung giữa API và Web. |
| `tests/QuanLyThucTap.Tests` | Unit test (xUnit) cho quy tắc tính điểm và lịch đợt. Chạy bằng `dotnet test`. |

`database/QuanLyThucTap_SqlServer.sql` là script DDL SQL Server sinh từ mô hình EF Core (để nộp báo cáo hoặc tạo CSDL thủ công).

## 1. Yêu cầu

- .NET 8 SDK (`dotnet --version` ≥ 8.0)
- SQL Server (LocalDB đi kèm Visual Studio, SQL Server Express hoặc bản đầy đủ). Muốn chạy thử không cần SQL Server thì dùng SQLite (mục 3).

## 2. Chạy với SQL Server

1. Sửa chuỗi kết nối trong `src/QuanLyThucTap.Api/appsettings.json` (`ConnectionStrings:SqlServer`). Mặc định dùng LocalDB:
   `Server=(localdb)\MSSQLLocalDB;Database=QuanLyThucTap;Trusted_Connection=True;TrustServerCertificate=True`
   Với SQL Server có tài khoản: `Server=localhost;Database=QuanLyThucTap;User Id=sa;Password=...;TrustServerCertificate=True`
2. Đổi `Jwt:Key` thành chuỗi bí mật riêng (≥ 32 ký tự) trước khi triển khai thật.
3. Mở 2 cửa sổ dòng lệnh:

```bash
# Cửa sổ 1 - API (http://localhost:5080, Swagger tại /swagger)
cd src/QuanLyThucTap.Api
dotnet run

# Cửa sổ 2 - Web (http://localhost:5070)
cd src/QuanLyThucTap.Web
dotnet run
```

Lần chạy đầu, API tự tạo CSDL `QuanLyThucTap` và nạp dữ liệu mẫu. Tắt dữ liệu mẫu bằng `Database:NapDuLieuMau = false` (khi đó chỉ tạo tài khoản `admin`).

### Chạy bằng Visual Studio 2022 (≥ 17.8)

> Nếu gặp lỗi **"A project with an Output Type of Class Library cannot be started directly"** là do đang đặt `QuanLyThucTap.Shared` làm dự án khởi động. `Shared` chỉ là thư viện dùng chung, **không chạy được**. Làm như sau:

1. Mở tệp `QuanLyThucTap.sln` (không mở từng tệp `.csproj`).

**Cách nhanh (Visual Studio 17.11 trở lên):** ô chọn cạnh nút ▶ trên thanh công cụ có sẵn hồ sơ **Api + Web** (khai báo trong tệp `QuanLyThucTap.slnLaunch`). Chọn hồ sơ đó rồi bấm F5 là xong. Nếu không thấy hồ sơ này, làm thủ công theo các bước 2–5 dưới đây.

2. Trong *Solution Explorer*, chuột phải vào dòng **Solution 'QuanLyThucTap'** trên cùng → **Configure Startup Projects...** (hoặc *Properties* → *Common Properties* → *Startup Project*).
3. Chọn **Multiple startup projects**, rồi đặt cột *Action*:
   - `QuanLyThucTap.Api` → **Start**
   - `QuanLyThucTap.Web` → **Start**
   - `QuanLyThucTap.Shared` → **None**
   - `QuanLyThucTap.Tests` → **None** (dự án unit test, chạy bằng *Test Explorer*)
4. Dùng mũi tên bên phải để đưa `QuanLyThucTap.Api` lên trên `QuanLyThucTap.Web` (API khởi động trước), bấm **OK**.
5. Trên thanh công cụ, ô cạnh nút ▶ phải hiện *<Multiple Startup Projects>*. Bấm **F5** (hoặc Ctrl+F5). Hai cửa sổ trình duyệt mở ra: Swagger của API (cổng 5080) và trang web (cổng 5070). Dùng trang cổng **5070**.

Nếu chỉ muốn chạy một dự án: chuột phải `QuanLyThucTap.Web` (hoặc `.Api`) → **Set as Startup Project**, nhưng khi đó phải tự chạy dự án còn lại bằng `dotnet run`, vì Web cần API đang chạy.

## 3. Chạy thử nhanh bằng SQLite (không cần SQL Server)

```bash
# Windows PowerShell
$env:Database__Provider="Sqlite"; dotnet run --project src/QuanLyThucTap.Api
# Linux/macOS
Database__Provider=Sqlite dotnet run --project src/QuanLyThucTap.Api
```

CSDL nằm ở `src/QuanLyThucTap.Api/App_Data/thuctap.db`. Xóa thư mục `App_Data` để tạo lại dữ liệu mẫu từ đầu.

## 4. Tài khoản mẫu

| Vai trò | Tên đăng nhập | Mật khẩu |
|---|---|---|
| Quản trị viên | `admin` | `Admin@123` |
| Đơn vị | `donvi1` … `donvi26` (xem bảng dưới) | `123456` |
| Giảng viên | `gv01`, `gv02`, `gv03` | `123456` |
| Sinh viên | `sv01` … `sv10` | `123456` |

Danh sách đơn vị lấy theo các đơn vị của Bộ Công an:
- `donvi1` Cục Kỹ thuật nghiệp vụ, `donvi2` Cục An ninh mạng và phòng, chống tội phạm sử dụng công nghệ cao, `donvi3` Cục Hồ sơ nghiệp vụ: ba đơn vị này có sẵn vị trí thực tập, đơn ứng tuyển và điểm mẫu.
- `donvi4` … `donvi12`: các Cục cấp Bộ còn lại (Cảnh sát hình sự, Cảnh sát điều tra tội phạm về ma túy, Cảnh sát kinh tế, Cảnh sát QLHC về TTXH, Cảnh sát giao thông, Cảnh sát PCCC và CNCH, Quản lý xuất nhập cảnh, Đào tạo, Tổ chức cán bộ).
- `donvi13` … `donvi26`: các Phòng nghiệp vụ thuộc Công an cấp tỉnh, lấy **Công an TP Hà Nội** làm ví dụ (An ninh điều tra, Cảnh sát hình sự, …, Thanh tra, Văn phòng Cơ quan CSĐT).

Email (`donviN@thuctap.local`), người đại diện và số điện thoại của đơn vị là dữ liệu mẫu; Admin sửa lại ở mục *Đơn vị* khi dùng thật. Cấp xã không có Cục/Phòng nên không đưa vào.

Dữ liệu mẫu có 3 đợt, mốc thời gian tính theo ngày chạy để thấy đủ các giai đoạn:
- **Kỳ 2025.2** đang ở giai đoạn *nộp báo cáo & chấm điểm*: sv01 có 2 phiên bản (bản 1 đã chấm, bản 2 chưa chấm → *Chưa đủ điểm*), sv02 có điểm GV 5.6 / DV 4.0 → tổng 4.96 *Không đạt* (đúng ví dụ trong tài liệu), sv03 *Đạt*, sv04 chưa nộp.
- **Kỳ 2026.1** đang ở giai đoạn *ứng tuyển & xét duyệt*: có vị trí và đơn chờ duyệt; sv01 tham gia cả hai đợt.
- **Kỳ 2026.2** ở trạng thái *Khởi tạo*.

Muốn chuyển giai đoạn để thử chức năng khác: Admin → *Đợt thực tập* → *Gia hạn lịch* (bắt buộc ghi lý do, có nhật ký).

## 5. Chức năng theo vai trò (10 ca sử dụng)

- **Quản trị viên**: quản lý đơn vị, giảng viên, sinh viên và tài khoản (khóa/mở khóa, đặt lại mật khẩu); tạo đợt với lịch 3 giai đoạn, trọng số, ngưỡng; kích hoạt, gia hạn, kết thúc đợt; thêm sinh viên vào đợt và duyệt điều kiện; phân công/đổi GVHD (kiểm tra chỉ tiêu 15/đợt); chốt điểm, mở lại đánh giá, khóa/gỡ khóa nộp; xuất kết quả CSV; xem nhật ký.
- **Đơn vị**: đăng/sửa/xóa/đóng vị trí trong giai đoạn đăng tin; xem CV, tiếp nhận hoặc từ chối (tiếp nhận tự hủy các đơn còn lại của sinh viên); chấm điểm DV cho sinh viên đã tiếp nhận.
- **Sinh viên**: xem vị trí, ứng tuyển tối đa 3 nguyện vọng với CV PDF ≤ 5 MiB; hủy đơn chờ duyệt/bị từ chối; nộp báo cáo PDF ≤ 20 MiB nhiều phiên bản; xem điểm và kết quả.
- **Giảng viên**: xem sinh viên được phân công, tải báo cáo, chấm điểm GV.

## 6. Quy tắc nghiệp vụ đã cài đặt (trích)

- Mọi kiểm tra quyền, thời hạn, trạng thái thực hiện ở API; mã người chấm/người duyệt lấy từ phiên đăng nhập, không tin mã do trình duyệt gửi. Mỗi yêu cầu kiểm tra tài khoản còn hoạt động.
- Khoảng thời gian `tg_mo ≤ thời điểm < tg_dong`, lưu UTC, hiển thị và nhập theo giờ Asia/Ho_Chi_Minh.
- Ràng buộc duy nhất có điều kiện bằng chỉ mục lọc: (ma_tham_gia, thu_tu_nguyen_vong) và (ma_tham_gia, ma_vi_tri) với đơn chưa hủy; ma_tham_gia với đơn đã tiếp nhận. FK ghép buộc hồ sơ và vị trí cùng đợt.
- Bản hiện hành = MAX(so_phien_ban); chỉ chấm bản hiện hành; không chuyển điểm bản cũ sang bản mới.
- Tổng = GV × trọng số GV + DV × trọng số DV bằng `decimal`; xét đạt trên tổng gốc, chỉ làm tròn 2 chữ số khi hiển thị.
- Tệp CV/báo cáo lưu ở `App_Data/files` với tên do hệ thống sinh; kiểm tra chữ ký PDF thực tế và dung lượng; tải tệp đi qua kiểm tra quyền.
- FK dùng NO ACTION (không xóa dây chuyền); ngừng dùng thì khóa tài khoản; đơn hủy bằng trạng thái.
- Nhật ký `NhatKyThayDoi` ghi duyệt đơn, hủy đơn, phân công/đổi GVHD (giá trị trước/sau + lý do), nhập/sửa điểm, chốt, mở khóa, gia hạn.

## 7. Xuất lại script SQL Server

```bash
cd src/QuanLyThucTap.Api
dotnet run -- --xuat-sql ../../database/QuanLyThucTap_SqlServer.sql
```

## 8. Về biểu trưng

Giao diện dùng hai logo do người dùng cung cấp, đặt trong `src/QuanLyThucTap.Web/wwwroot/img/`:
- `logo-bca.png`: huy hiệu Công an nhân dân (Bộ Công an), đã tách nền trắng.
- `logo-hvannd.png`: logo Học viện An ninh nhân dân, đã cắt tròn và làm nền trong suốt; dùng luôn làm biểu tượng tab trình duyệt (favicon).

Hai logo hiện cạnh nhau ở đầu mọi trang (`Views/Shared/_Layout.cshtml`) và ở trang đăng nhập (`Views/TaiKhoan/DangNhap.cshtml`). Muốn thay logo, chép đè tệp PNG cùng tên.

## 9. Quy ước code

Mã nguồn viết theo tài liệu *Hướng dẫn viết code C# chuẩn* (PGS.TS Nguyễn Đình Nghĩa). Tệp `.editorconfig` ở thư mục gốc giúp Visual Studio và `dotnet format` tự kiểm tra các quy tắc chính.

- **Đặt tên:**
  - PascalCase cho lớp, phương thức, thuộc tính và hằng.
  - camelCase cho biến cục bộ và tham số; `_camelCase` cho trường private.
  - Interface bắt đầu bằng `I`. Biến bool bắt đầu bằng `Is/Has/Can/Should`. Phương thức là động từ (`LayDanhSach`, `TiepNhanDonAsync`…).
  - Không viết tắt tên biến.
  - Ngoại lệ có chủ đích: tên thuộc tính của entity và DTO giữ đúng tên cột trong tài liệu thiết kế CSDL (`MaSv`, `TgMoDnDangTin`…), để đối chiếu được với tài liệu.
  - Tên action của controller MVC giữ nguyên vì đó là đường dẫn URL.
- **Cấu trúc:** mỗi tệp một kiểu public, tên tệp trùng tên lớp. Namespace theo dạng `HocVienAnNinh.QuanLyThucTap.<Dự án>.<Thư mục>`. Các thư mục chính:
  - API: `Controllers`, `Services`, `Interfaces`, `Repositories`, `Mappings`, `Models`, `Dtos`, `Data`, `Constants`, `Exceptions`, `Extensions`, `Options`.
  - Web: `Controllers`, `Services`, `Interfaces`, `Helpers`, `Models`, `Filters`.
  - Shared: `Dtos`, `Constants`.
- **SOLID:**
  - Controller chỉ nhận yêu cầu và gọi service. Nghiệp vụ nằm trong service.
  - Mọi service đều có interface và được tiêm qua Dependency Injection (đăng ký ở `Program.cs`).
  - Lịch đợt và cách tính điểm dùng đồng hồ tiêm vào, nhờ đó viết được unit test.
- **Định dạng:**
  - Mỗi câu lệnh một dòng, mọi khối `if/else/for` đều có `{}`.
  - Khi xuống dòng thì ngắt sau toán tử hoặc dấu phẩy.
  - `using System.*` đứng trước.
  - Không dùng số "bí ẩn" mà đặt hằng có tên.
- **Ngoại lệ:** chỉ bắt ngoại lệ cụ thể, không nuốt lỗi, có ghi log. Lỗi nghiệp vụ dùng `NghiepVuException` và được chuyển thành thông báo tiếng Việt.
- **Tài liệu:** mọi lớp và phương thức public đều có XML documentation (`/// <summary>`).

Kiểm tra định dạng: `dotnet format QuanLyThucTap.sln --verify-no-changes`. Chạy unit test: `dotnet test`.
