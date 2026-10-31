CREATE TABLE [DotThucTap] (
    [ma_dot] int NOT NULL IDENTITY,
    [ten_dot] nvarchar(100) NOT NULL,
    [nam_hoc] nvarchar(20) NOT NULL,
    [tg_mo_dn_dang_tin] datetime2 NOT NULL,
    [tg_dong_dn_dang_tin] datetime2 NOT NULL,
    [tg_mo_sv_ung_tuyen] datetime2 NOT NULL,
    [tg_dong_sv_ung_tuyen] datetime2 NOT NULL,
    [tg_mo_nop_bao_cao] datetime2 NOT NULL,
    [tg_dong_cham_diem] datetime2 NOT NULL,
    [trong_so_gv] decimal(4,3) NOT NULL DEFAULT 0.6,
    [trong_so_dn] decimal(4,3) NOT NULL DEFAULT 0.4,
    [nguong_tong] decimal(4,2) NOT NULL DEFAULT 5.0,
    [nguong_gv] decimal(4,2) NOT NULL DEFAULT 4.0,
    [nguong_dn] decimal(4,2) NOT NULL DEFAULT 4.0,
    [trang_thai] tinyint NOT NULL DEFAULT CAST(0 AS tinyint),
    CONSTRAINT [PK_DotThucTap] PRIMARY KEY ([ma_dot]),
    CONSTRAINT [CK_DotThucTap_Lich] CHECK ([tg_mo_dn_dang_tin] < [tg_dong_dn_dang_tin] AND [tg_mo_sv_ung_tuyen] < [tg_dong_sv_ung_tuyen] AND [tg_mo_nop_bao_cao] < [tg_dong_cham_diem] AND [tg_dong_dn_dang_tin] <= [tg_mo_sv_ung_tuyen] AND [tg_dong_sv_ung_tuyen] <= [tg_mo_nop_bao_cao]),
    CONSTRAINT [CK_DotThucTap_Nguong] CHECK ([nguong_tong] BETWEEN 0 AND 10 AND [nguong_gv] BETWEEN 0 AND 10 AND [nguong_dn] BETWEEN 0 AND 10),
    CONSTRAINT [CK_DotThucTap_TrangThai] CHECK ([trang_thai] IN (0,1,2)),
    CONSTRAINT [CK_DotThucTap_TrongSo] CHECK ([trong_so_gv] >= 0 AND [trong_so_gv] <= 1 AND [trong_so_dn] >= 0 AND [trong_so_dn] <= 1 AND ABS([trong_so_gv] + [trong_so_dn] - 1) < 0.0005)
);
GO


CREATE TABLE [NguoiDung] (
    [ma_nguoi_dung] int NOT NULL IDENTITY,
    [ten_dang_nhap] nvarchar(100) NOT NULL,
    [mat_khau_hash] nvarchar(255) NOT NULL,
    [vai_tro] nvarchar(20) NOT NULL,
    [trang_thai] tinyint NOT NULL DEFAULT CAST(1 AS tinyint),
    [ngay_tao] datetime2 NOT NULL,
    CONSTRAINT [PK_NguoiDung] PRIMARY KEY ([ma_nguoi_dung]),
    CONSTRAINT [CK_NguoiDung_TrangThai] CHECK ([trang_thai] IN (0,1)),
    CONSTRAINT [CK_NguoiDung_VaiTro] CHECK ([vai_tro] IN ('ADMIN','DON_VI','SINH_VIEN','GIANG_VIEN'))
);
GO


CREATE TABLE [DonVi] (
    [ma_dv] int NOT NULL IDENTITY,
    [ma_nguoi_dung] int NOT NULL,
    [ten_don_vi] nvarchar(150) NOT NULL,
    [linh_vuc_hoat_dong] nvarchar(100) NULL,
    [email_lien_he] nvarchar(100) NOT NULL,
    [so_dien_thoai] nvarchar(20) NULL,
    [dia_chi] nvarchar(255) NULL,
    [nguoi_dai_dien] nvarchar(100) NOT NULL,
    [ngay_tao] datetime2 NOT NULL,
    CONSTRAINT [PK_DonVi] PRIMARY KEY ([ma_dv]),
    CONSTRAINT [FK_DonVi_NguoiDung_ma_nguoi_dung] FOREIGN KEY ([ma_nguoi_dung]) REFERENCES [NguoiDung] ([ma_nguoi_dung])
);
GO


CREATE TABLE [GiangVien] (
    [ma_gv] int NOT NULL IDENTITY,
    [ma_nguoi_dung] int NOT NULL,
    [ma_can_bo] nvarchar(20) NOT NULL,
    [ho_va_ten] nvarchar(100) NOT NULL,
    [email] nvarchar(100) NOT NULL,
    [bo_mon] nvarchar(100) NOT NULL,
    [hoc_ham_hoc_vi] nvarchar(50) NULL,
    [chi_tieu_toi_da] int NOT NULL DEFAULT 15,
    CONSTRAINT [PK_GiangVien] PRIMARY KEY ([ma_gv]),
    CONSTRAINT [CK_GiangVien_ChiTieu] CHECK ([chi_tieu_toi_da] > 0),
    CONSTRAINT [FK_GiangVien_NguoiDung_ma_nguoi_dung] FOREIGN KEY ([ma_nguoi_dung]) REFERENCES [NguoiDung] ([ma_nguoi_dung])
);
GO


CREATE TABLE [NhatKyThayDoi] (
    [ma_nhat_ky] int NOT NULL IDENTITY,
    [nguoi_thuc_hien] int NULL,
    [loai_doi_tuong] nvarchar(50) NOT NULL,
    [ma_doi_tuong] int NOT NULL,
    [hanh_dong] nvarchar(50) NOT NULL,
    [thoi_gian] datetime2 NOT NULL,
    [du_lieu_truoc] nvarchar(max) NULL,
    [du_lieu_sau] nvarchar(max) NULL,
    [ly_do] nvarchar(500) NULL,
    CONSTRAINT [PK_NhatKyThayDoi] PRIMARY KEY ([ma_nhat_ky]),
    CONSTRAINT [FK_NhatKyThayDoi_NguoiDung_nguoi_thuc_hien] FOREIGN KEY ([nguoi_thuc_hien]) REFERENCES [NguoiDung] ([ma_nguoi_dung])
);
GO


CREATE TABLE [SinhVien] (
    [ma_sv] int NOT NULL IDENTITY,
    [ma_nguoi_dung] int NOT NULL,
    [mssv] nvarchar(20) NOT NULL,
    [ho_va_ten] nvarchar(100) NOT NULL,
    [email_T01] nvarchar(100) NOT NULL,
    [lop_quan_ly] nvarchar(50) NOT NULL,
    [chuyen_nganh] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_SinhVien] PRIMARY KEY ([ma_sv]),
    CONSTRAINT [FK_SinhVien_NguoiDung_ma_nguoi_dung] FOREIGN KEY ([ma_nguoi_dung]) REFERENCES [NguoiDung] ([ma_nguoi_dung])
);
GO


CREATE TABLE [ViTriThucTap] (
    [ma_vi_tri] int NOT NULL IDENTITY,
    [ma_dv] int NOT NULL,
    [ma_dot] int NOT NULL,
    [tieu_de] nvarchar(200) NOT NULL,
    [mo_ta_cong_viec] nvarchar(max) NOT NULL,
    [yeu_cau_cong_viec] nvarchar(max) NOT NULL,
    [so_luong_tuyen] int NOT NULL,
    [ngay_dang] datetime2 NOT NULL,
    [trang_thai_mo] bit NOT NULL DEFAULT CAST(1 AS bit),
    CONSTRAINT [PK_ViTriThucTap] PRIMARY KEY ([ma_vi_tri]),
    CONSTRAINT [AK_ViTriThucTap_ma_vi_tri_ma_dot] UNIQUE ([ma_vi_tri], [ma_dot]),
    CONSTRAINT [CK_ViTri_SoLuong] CHECK ([so_luong_tuyen] > 0),
    CONSTRAINT [FK_ViTriThucTap_DonVi_ma_dv] FOREIGN KEY ([ma_dv]) REFERENCES [DonVi] ([ma_dv]),
    CONSTRAINT [FK_ViTriThucTap_DotThucTap_ma_dot] FOREIGN KEY ([ma_dot]) REFERENCES [DotThucTap] ([ma_dot])
);
GO


CREATE TABLE [SinhVienDotThucTap] (
    [ma_tham_gia] int NOT NULL IDENTITY,
    [ma_sv] int NOT NULL,
    [ma_dot] int NOT NULL,
    [du_dieu_kien_tt] bit NOT NULL DEFAULT CAST(0 AS bit),
    [nguoi_duyet] int NULL,
    [thoi_gian_duyet] datetime2 NULL,
    CONSTRAINT [PK_SinhVienDotThucTap] PRIMARY KEY ([ma_tham_gia]),
    CONSTRAINT [AK_SinhVienDotThucTap_ma_tham_gia_ma_dot] UNIQUE ([ma_tham_gia], [ma_dot]),
    CONSTRAINT [CK_SVDot_Duyet] CHECK ([du_dieu_kien_tt] = 0 OR ([nguoi_duyet] IS NOT NULL AND [thoi_gian_duyet] IS NOT NULL)),
    CONSTRAINT [FK_SinhVienDotThucTap_DotThucTap_ma_dot] FOREIGN KEY ([ma_dot]) REFERENCES [DotThucTap] ([ma_dot]),
    CONSTRAINT [FK_SinhVienDotThucTap_NguoiDung_nguoi_duyet] FOREIGN KEY ([nguoi_duyet]) REFERENCES [NguoiDung] ([ma_nguoi_dung]),
    CONSTRAINT [FK_SinhVienDotThucTap_SinhVien_ma_sv] FOREIGN KEY ([ma_sv]) REFERENCES [SinhVien] ([ma_sv])
);
GO


CREATE TABLE [DonUngTuyen] (
    [ma_ung_tuyen] int NOT NULL IDENTITY,
    [ma_tham_gia] int NOT NULL,
    [ma_dot] int NOT NULL,
    [ma_vi_tri] int NOT NULL,
    [thu_tu_nguyen_vong] tinyint NOT NULL,
    [duong_dan_cv] nvarchar(512) NOT NULL,
    [ten_tep_cv] nvarchar(255) NOT NULL,
    [dung_luong_cv] int NOT NULL,
    [ngay_nop] datetime2 NOT NULL,
    [trang_thai_duyet] tinyint NOT NULL DEFAULT CAST(0 AS tinyint),
    [ghi_chu_dv] nvarchar(max) NULL,
    [nguoi_xu_ly] int NULL,
    [thoi_gian_xu_ly] datetime2 NULL,
    [ly_do_huy] nvarchar(255) NULL,
    CONSTRAINT [PK_DonUngTuyen] PRIMARY KEY ([ma_ung_tuyen]),
    CONSTRAINT [CK_Don_DungLuongCv] CHECK ([dung_luong_cv] BETWEEN 1 AND 5242880),
    CONSTRAINT [CK_Don_LyDoHuy] CHECK ([trang_thai_duyet] <> 3 OR [ly_do_huy] IS NOT NULL),
    CONSTRAINT [CK_Don_ThuTu] CHECK ([thu_tu_nguyen_vong] IN (1,2,3)),
    CONSTRAINT [CK_Don_TrangThai] CHECK ([trang_thai_duyet] IN (0,1,2,3)),
    CONSTRAINT [CK_Don_XuLy] CHECK ([trang_thai_duyet] = 0 OR ([nguoi_xu_ly] IS NOT NULL AND [thoi_gian_xu_ly] IS NOT NULL)),
    CONSTRAINT [FK_DonUngTuyen_DotThucTap_ma_dot] FOREIGN KEY ([ma_dot]) REFERENCES [DotThucTap] ([ma_dot]),
    CONSTRAINT [FK_DonUngTuyen_NguoiDung_nguoi_xu_ly] FOREIGN KEY ([nguoi_xu_ly]) REFERENCES [NguoiDung] ([ma_nguoi_dung]),
    CONSTRAINT [FK_DonUngTuyen_SinhVienDotThucTap_ma_tham_gia_ma_dot] FOREIGN KEY ([ma_tham_gia], [ma_dot]) REFERENCES [SinhVienDotThucTap] ([ma_tham_gia], [ma_dot]),
    CONSTRAINT [FK_DonUngTuyen_ViTriThucTap_ma_vi_tri_ma_dot] FOREIGN KEY ([ma_vi_tri], [ma_dot]) REFERENCES [ViTriThucTap] ([ma_vi_tri], [ma_dot])
);
GO


CREATE TABLE [PhanCongGVHD] (
    [ma_phan_cong] int NOT NULL IDENTITY,
    [ma_tham_gia] int NOT NULL,
    [ma_gv] int NOT NULL,
    [nguoi_phan_cong] int NOT NULL,
    [ngay_phan_cong] datetime2 NOT NULL,
    [ghi_chu] nvarchar(255) NULL,
    CONSTRAINT [PK_PhanCongGVHD] PRIMARY KEY ([ma_phan_cong]),
    CONSTRAINT [FK_PhanCongGVHD_GiangVien_ma_gv] FOREIGN KEY ([ma_gv]) REFERENCES [GiangVien] ([ma_gv]),
    CONSTRAINT [FK_PhanCongGVHD_NguoiDung_nguoi_phan_cong] FOREIGN KEY ([nguoi_phan_cong]) REFERENCES [NguoiDung] ([ma_nguoi_dung]),
    CONSTRAINT [FK_PhanCongGVHD_SinhVienDotThucTap_ma_tham_gia] FOREIGN KEY ([ma_tham_gia]) REFERENCES [SinhVienDotThucTap] ([ma_tham_gia])
);
GO


CREATE TABLE [BaoCaoThucTap] (
    [ma_bao_cao] int NOT NULL IDENTITY,
    [ma_phan_cong] int NOT NULL,
    [ngay_tao] datetime2 NOT NULL,
    [da_khoa_nop] bit NOT NULL DEFAULT CAST(0 AS bit),
    CONSTRAINT [PK_BaoCaoThucTap] PRIMARY KEY ([ma_bao_cao]),
    CONSTRAINT [FK_BaoCaoThucTap_PhanCongGVHD_ma_phan_cong] FOREIGN KEY ([ma_phan_cong]) REFERENCES [PhanCongGVHD] ([ma_phan_cong])
);
GO


CREATE TABLE [PhienBanBaoCao] (
    [ma_phien_ban] int NOT NULL IDENTITY,
    [ma_bao_cao] int NOT NULL,
    [so_phien_ban] int NOT NULL,
    [ten_tep_goc] nvarchar(255) NOT NULL,
    [duong_dan_tep] nvarchar(512) NOT NULL,
    [mime_type] nvarchar(100) NOT NULL,
    [dung_luong_byte] int NOT NULL,
    [thoi_gian_nop] datetime2 NOT NULL,
    [nguoi_nop] int NOT NULL,
    CONSTRAINT [PK_PhienBanBaoCao] PRIMARY KEY ([ma_phien_ban]),
    CONSTRAINT [CK_PhienBan_DungLuong] CHECK ([dung_luong_byte] BETWEEN 1 AND 20971520),
    CONSTRAINT [CK_PhienBan_So] CHECK ([so_phien_ban] > 0),
    CONSTRAINT [FK_PhienBanBaoCao_BaoCaoThucTap_ma_bao_cao] FOREIGN KEY ([ma_bao_cao]) REFERENCES [BaoCaoThucTap] ([ma_bao_cao]),
    CONSTRAINT [FK_PhienBanBaoCao_NguoiDung_nguoi_nop] FOREIGN KEY ([nguoi_nop]) REFERENCES [NguoiDung] ([ma_nguoi_dung])
);
GO


CREATE TABLE [BangDiem] (
    [ma_bang_diem] int NOT NULL IDENTITY,
    [ma_phien_ban] int NOT NULL,
    [diem_dv] decimal(3,1) NULL,
    [nhan_xet_dv] nvarchar(max) NULL,
    [nguoi_cham_dv] int NULL,
    [tg_dn_nhap_diem] datetime2 NULL,
    [diem_gv] decimal(3,1) NULL,
    [nhan_xet_gv] nvarchar(max) NULL,
    [nguoi_cham_gv] int NULL,
    [tg_gv_nhap_diem] datetime2 NULL,
    [trang_thai_chot] bit NOT NULL DEFAULT CAST(0 AS bit),
    [thoi_gian_chot] datetime2 NULL,
    CONSTRAINT [PK_BangDiem] PRIMARY KEY ([ma_bang_diem]),
    CONSTRAINT [CK_BangDiem_Chot] CHECK (([trang_thai_chot] = 0 AND [thoi_gian_chot] IS NULL) OR ([trang_thai_chot] = 1 AND [thoi_gian_chot] IS NOT NULL AND [diem_dv] IS NOT NULL AND [diem_gv] IS NOT NULL)),
    CONSTRAINT [CK_BangDiem_DiemDv] CHECK ([diem_dv] IS NULL OR ([diem_dv] >= 0 AND [diem_dv] <= 10)),
    CONSTRAINT [CK_BangDiem_DiemGv] CHECK ([diem_gv] IS NULL OR ([diem_gv] >= 0 AND [diem_gv] <= 10)),
    CONSTRAINT [CK_BangDiem_NguoiChamDv] CHECK (([diem_dv] IS NULL AND [nguoi_cham_dv] IS NULL AND [tg_dn_nhap_diem] IS NULL) OR ([diem_dv] IS NOT NULL AND [nguoi_cham_dv] IS NOT NULL AND [tg_dn_nhap_diem] IS NOT NULL)),
    CONSTRAINT [CK_BangDiem_NguoiChamGv] CHECK (([diem_gv] IS NULL AND [nguoi_cham_gv] IS NULL AND [tg_gv_nhap_diem] IS NULL) OR ([diem_gv] IS NOT NULL AND [nguoi_cham_gv] IS NOT NULL AND [tg_gv_nhap_diem] IS NOT NULL)),
    CONSTRAINT [FK_BangDiem_NguoiDung_nguoi_cham_dv] FOREIGN KEY ([nguoi_cham_dv]) REFERENCES [NguoiDung] ([ma_nguoi_dung]),
    CONSTRAINT [FK_BangDiem_NguoiDung_nguoi_cham_gv] FOREIGN KEY ([nguoi_cham_gv]) REFERENCES [NguoiDung] ([ma_nguoi_dung]),
    CONSTRAINT [FK_BangDiem_PhienBanBaoCao_ma_phien_ban] FOREIGN KEY ([ma_phien_ban]) REFERENCES [PhienBanBaoCao] ([ma_phien_ban])
);
GO


CREATE UNIQUE INDEX [IX_BangDiem_ma_phien_ban] ON [BangDiem] ([ma_phien_ban]);
GO


CREATE INDEX [IX_BangDiem_nguoi_cham_dv] ON [BangDiem] ([nguoi_cham_dv]);
GO


CREATE INDEX [IX_BangDiem_nguoi_cham_gv] ON [BangDiem] ([nguoi_cham_gv]);
GO


CREATE UNIQUE INDEX [IX_BaoCaoThucTap_ma_phan_cong] ON [BaoCaoThucTap] ([ma_phan_cong]);
GO


CREATE INDEX [IX_DonUngTuyen_ma_dot] ON [DonUngTuyen] ([ma_dot]);
GO


CREATE INDEX [IX_DonUngTuyen_ma_tham_gia_ma_dot] ON [DonUngTuyen] ([ma_tham_gia], [ma_dot]);
GO


CREATE INDEX [IX_DonUngTuyen_ma_tham_gia_trang_thai_duyet] ON [DonUngTuyen] ([ma_tham_gia], [trang_thai_duyet]);
GO


CREATE INDEX [IX_DonUngTuyen_ma_vi_tri_ma_dot] ON [DonUngTuyen] ([ma_vi_tri], [ma_dot]);
GO


CREATE INDEX [IX_DonUngTuyen_ma_vi_tri_trang_thai_duyet] ON [DonUngTuyen] ([ma_vi_tri], [trang_thai_duyet]);
GO


CREATE INDEX [IX_DonUngTuyen_nguoi_xu_ly] ON [DonUngTuyen] ([nguoi_xu_ly]);
GO


CREATE UNIQUE INDEX [UX_Don_ThamGia_DaTiepNhan] ON [DonUngTuyen] ([ma_tham_gia]) WHERE [trang_thai_duyet] = 1;
GO


CREATE UNIQUE INDEX [UX_Don_ThamGia_ThuTu_ChuaHuy] ON [DonUngTuyen] ([ma_tham_gia], [thu_tu_nguyen_vong]) WHERE [trang_thai_duyet] <> 3;
GO


CREATE UNIQUE INDEX [UX_Don_ThamGia_ViTri_ChuaHuy] ON [DonUngTuyen] ([ma_tham_gia], [ma_vi_tri]) WHERE [trang_thai_duyet] <> 3;
GO


CREATE UNIQUE INDEX [IX_DonVi_ma_nguoi_dung] ON [DonVi] ([ma_nguoi_dung]);
GO


CREATE UNIQUE INDEX [IX_GiangVien_email] ON [GiangVien] ([email]);
GO


CREATE UNIQUE INDEX [IX_GiangVien_ma_can_bo] ON [GiangVien] ([ma_can_bo]);
GO


CREATE UNIQUE INDEX [IX_GiangVien_ma_nguoi_dung] ON [GiangVien] ([ma_nguoi_dung]);
GO


CREATE UNIQUE INDEX [IX_NguoiDung_ten_dang_nhap] ON [NguoiDung] ([ten_dang_nhap]);
GO


CREATE INDEX [IX_NhatKyThayDoi_loai_doi_tuong_ma_doi_tuong_thoi_gian] ON [NhatKyThayDoi] ([loai_doi_tuong], [ma_doi_tuong], [thoi_gian]);
GO


CREATE INDEX [IX_NhatKyThayDoi_nguoi_thuc_hien] ON [NhatKyThayDoi] ([nguoi_thuc_hien]);
GO


CREATE INDEX [IX_PhanCongGVHD_ma_gv_ma_tham_gia] ON [PhanCongGVHD] ([ma_gv], [ma_tham_gia]);
GO


CREATE UNIQUE INDEX [IX_PhanCongGVHD_ma_tham_gia] ON [PhanCongGVHD] ([ma_tham_gia]);
GO


CREATE INDEX [IX_PhanCongGVHD_nguoi_phan_cong] ON [PhanCongGVHD] ([nguoi_phan_cong]);
GO


CREATE UNIQUE INDEX [IX_PhienBanBaoCao_duong_dan_tep] ON [PhienBanBaoCao] ([duong_dan_tep]);
GO


CREATE UNIQUE INDEX [IX_PhienBanBaoCao_ma_bao_cao_so_phien_ban] ON [PhienBanBaoCao] ([ma_bao_cao], [so_phien_ban]);
GO


CREATE INDEX [IX_PhienBanBaoCao_nguoi_nop] ON [PhienBanBaoCao] ([nguoi_nop]);
GO


CREATE UNIQUE INDEX [IX_SinhVien_email_T01] ON [SinhVien] ([email_T01]);
GO


CREATE UNIQUE INDEX [IX_SinhVien_ma_nguoi_dung] ON [SinhVien] ([ma_nguoi_dung]);
GO


CREATE UNIQUE INDEX [IX_SinhVien_mssv] ON [SinhVien] ([mssv]);
GO


CREATE INDEX [IX_SinhVienDotThucTap_ma_dot_du_dieu_kien_tt] ON [SinhVienDotThucTap] ([ma_dot], [du_dieu_kien_tt]);
GO


CREATE UNIQUE INDEX [IX_SinhVienDotThucTap_ma_sv_ma_dot] ON [SinhVienDotThucTap] ([ma_sv], [ma_dot]);
GO


CREATE INDEX [IX_SinhVienDotThucTap_nguoi_duyet] ON [SinhVienDotThucTap] ([nguoi_duyet]);
GO


CREATE INDEX [IX_ViTriThucTap_ma_dot_trang_thai_mo] ON [ViTriThucTap] ([ma_dot], [trang_thai_mo]);
GO


CREATE INDEX [IX_ViTriThucTap_ma_dv_ma_dot] ON [ViTriThucTap] ([ma_dv], [ma_dot]);
GO


