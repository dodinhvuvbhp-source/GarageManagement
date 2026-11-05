-- =========================================================================
-- DATABASE: GarageDB - Hệ Thống Quản Lý Cửa Hàng Sửa Chữa Xe
-- Môn học: PRJ301 (Java Web Application)
-- =========================================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'GarageDB')
BEGIN
    ALTER DATABASE GarageDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GarageDB;
END
GO

CREATE DATABASE GarageDB;
GO

USE GarageDB;
GO

-- 1. Bảng Vai trò người dùng (Roles)
CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL
);
GO

-- 2. Bảng Người dùng (Users)
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address NVARCHAR(255),
    role_id INT NOT NULL FOREIGN KEY REFERENCES Roles(role_id),
    created_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 1 -- 1: Đang hoạt động, 0: Khóa
);
GO

-- 3. Bảng Phương tiện / Xe (Vehicles)
CREATE TABLE Vehicles (
    vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
    license_plate VARCHAR(20) UNIQUE NOT NULL, -- Biển số xe (ví dụ: 29A-12345)
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    vehicle_type NVARCHAR(30) NOT NULL, -- 'Ô tô' hoặc 'Xe máy'
    brand NVARCHAR(50) NOT NULL,        -- Hãng xe (Honda, Toyota, Yamaha, Mazda...)
    model NVARCHAR(50) NOT NULL,        -- Dòng xe (Vios, Civic, SH, Exciter...)
    color NVARCHAR(30),
    manufacture_year INT,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 4. Bảng Dịch vụ sửa chữa / bảo dưỡng (Services)
CREATE TABLE Services (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_name NVARCHAR(150) NOT NULL,
    description NVARCHAR(500),
    price DECIMAL(18,2) NOT NULL, -- Tiền công dịch vụ (VNĐ)
    estimated_duration INT DEFAULT 30, -- Thời gian ước tính (phút)
    is_active BIT DEFAULT 1
);
GO

-- 5. Bảng Phụ tùng / Linh kiện thay thế (SpareParts)
CREATE TABLE SpareParts (
    part_id INT IDENTITY(1,1) PRIMARY KEY,
    part_code VARCHAR(50) UNIQUE NOT NULL,
    part_name NVARCHAR(150) NOT NULL,
    category NVARCHAR(50) NOT NULL, -- Dầu nhớt, Má phanh, Lốp xe, Bugi, Ắc quy...
    price DECIMAL(18,2) NOT NULL,   -- Giá bán linh kiện (VNĐ)
    stock_quantity INT NOT NULL DEFAULT 0, -- Số lượng tồn kho
    unit NVARCHAR(30) NOT NULL,     -- Cái, Bình, Bộ, Lít, Hộp...
    warranty_months INT DEFAULT 6,  -- Thời hạn bảo hành (tháng)
    is_active BIT DEFAULT 1
);
GO

-- 6. Bảng Phiếu sửa chữa / Tiếp nhận xe (RepairOrders)
CREATE TABLE RepairOrders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_code VARCHAR(30) UNIQUE NOT NULL, -- Mã phiếu (ví dụ: RO20261104-001)
    vehicle_id INT NOT NULL FOREIGN KEY REFERENCES Vehicles(vehicle_id),
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    technician_id INT NULL FOREIGN KEY REFERENCES Users(user_id), -- Thợ sửa phụ trách
    receive_date DATETIME DEFAULT GETDATE(),
    completed_date DATETIME NULL,
    problem_description NVARCHAR(1000) NOT NULL, -- Yêu cầu / Mô tả lỗi khách gặp
    diagnosis_notes NVARCHAR(1000) NULL,         -- Kết quả chẩn đoán kỹ thuật viên
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', 
    -- PENDING: Chờ tiếp nhận / Phân công
    -- IN_PROGRESS: Đang kiểm tra / Sửa chữa
    -- COMPLETED: Đã hoàn tất sửa chữa
    -- PAID: Đã thanh toán & Giao xe
    -- CANCELLED: Đã hủy phiếu
    total_service_cost DECIMAL(18,2) DEFAULT 0,
    total_part_cost DECIMAL(18,2) DEFAULT 0,
    total_amount DECIMAL(18,2) DEFAULT 0
);
GO

-- 7. Bảng Chi tiết dịch vụ sửa chữa trong phiếu (RepairOrderServices)
CREATE TABLE RepairOrderServices (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES RepairOrders(order_id) ON DELETE CASCADE,
    service_id INT NOT NULL FOREIGN KEY REFERENCES Services(service_id),
    price DECIMAL(18,2) NOT NULL, -- Giá công dịch vụ thời điểm lập phiếu
    notes NVARCHAR(255) NULL
);
GO

-- 8. Bảng Chi tiết phụ tùng thay thế trong phiếu (RepairOrderParts)
CREATE TABLE RepairOrderParts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES RepairOrders(order_id) ON DELETE CASCADE,
    part_id INT NOT NULL FOREIGN KEY REFERENCES SpareParts(part_id),
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(18,2) NOT NULL,
    total_price DECIMAL(18,2) NOT NULL
);
GO

-- 9. Bảng Hóa đơn thanh toán (Invoices)
CREATE TABLE Invoices (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_code VARCHAR(30) UNIQUE NOT NULL, -- INV-20261104-001
    order_id INT NOT NULL FOREIGN KEY REFERENCES RepairOrders(order_id),
    created_date DATETIME DEFAULT GETDATE(),
    subtotal DECIMAL(18,2) NOT NULL,   -- Tổng tiền công + phụ tùng
    discount DECIMAL(18,2) DEFAULT 0,   -- Chiết khấu / Khuyến mãi
    tax DECIMAL(18,2) DEFAULT 0,        -- Thuế VAT nếu có
    total_amount DECIMAL(18,2) NOT NULL,-- Tiền phải trả
    payment_status VARCHAR(20) DEFAULT 'UNPAID', -- UNPAID, PAID
    payment_method VARCHAR(30) NULL,    -- CASH, VNPAY, BANK_TRANSFER
    paid_date DATETIME NULL
);
GO

-- 10. Bảng Nhật ký giao dịch Sandbox VNPay (PaymentTransactions)
CREATE TABLE PaymentTransactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL FOREIGN KEY REFERENCES Invoices(invoice_id),
    vnp_txn_ref VARCHAR(100) NOT NULL,
    vnp_transaction_no VARCHAR(100) NULL,
    vnp_amount DECIMAL(18,2) NOT NULL,
    vnp_bank_code VARCHAR(50) NULL,
    vnp_response_code VARCHAR(20) NULL,
    vnp_pay_date VARCHAR(50) NULL,
    status VARCHAR(20) NOT NULL, -- SUCCESS, FAILED
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- =========================================================================
-- DỮ LIỆU KHỞI TẠO MẪU (SEED DATA)
-- =========================================================================

-- 1. Insert Roles
INSERT INTO Roles (role_id, role_name) VALUES
(1, N'Quản trị viên (Admin)'),
(2, N'Thu ngân / Điều phối (Staff)'),
(3, N'Kỹ thuật viên (Technician)'),
(4, N'Khách hàng (Customer)');
GO

-- 2. Insert Users (Mật khẩu mặc định: 123456)
INSERT INTO Users (username, password, full_name, email, phone, address, role_id) VALUES
('admin', '123456', N'Trần Quản Trị', 'admin@garage.com', '0901234567', N'123 Đường Cầu Giấy, Hà Nội', 1),
('staff', '123456', N'Nguyễn Thu Ngân', 'staff@garage.com', '0912345678', N'45 Nguyễn Trãi, Thanh Xuân, Hà Nội', 2),
('tech1', '123456', N'Lê Văn Thợ Cả', 'tech1@garage.com', '0987654321', N'88 Hoàng Hoa Thám, Ba Đình, Hà Nội', 3),
('tech2', '123456', N'Phạm Kỹ Thuật', 'tech2@garage.com', '0978123456', N'15 Giải Phóng, Hai Bà Trưng, Hà Nội', 3),
('customer1', '123456', N'Hoàng Anh Dũng', 'dung.hoang@gmail.com', '0933456789', N'102 Thái Hà, Đống Đa, Hà Nội', 4),
('customer2', '123456', N'Vũ Thị Mai Hương', 'huong.vu@gmail.com', '0944567890', N'68 Láng Hạ, Đống Đa, Hà Nội', 4);
GO

-- 3. Insert Vehicles
INSERT INTO Vehicles (license_plate, customer_id, vehicle_type, brand, model, color, manufacture_year) VALUES
('30F-123.45', 5, N'Ô tô', N'Honda', N'CR-V 1.5 Turbo', N'Đen', 2021),
('29A-678.90', 5, N'Ô tô', N'Toyota', N'Vios 1.5G', N'Trắng', 2020),
('29B1-888.88', 6, N'Xe máy', N'Honda', N'SH 150i ABS', N'Xám xi măng', 2022),
('30K-999.66', 6, N'Xe máy', N'Yamaha', N'Exciter 155 VVA', N'Xanh GP', 2023);
GO

-- 4. Insert Services
INSERT INTO Services (service_name, description, price, estimated_duration) VALUES
(N'Thay dầu nhớt động cơ & lọc nhớt', N'Xả dầu cũ, súc rửa khoang máy, thay dầu mới và lọc dầu đạt chuẩn', 150000, 30),
(N'Bảo dưỡng hệ thống phanh 4 bánh', N'Vệ sinh cùm phanh, tra mỡ piston, kiểm tra độ mòn má phanh và đĩa phanh', 350000, 60),
(N'Cân chỉnh thước lái & góc đặt bánh xe', N'Đo và cân chỉnh độ chụm bánh xe bằng máy laser 3D hiện đại', 400000, 45),
(N'Vệ sinh kim phun & buồng đốt điện tử', N'Làm sạch muội than buồng đốt và kim phun xăng điện tử bằng dung dịch chuyên dụng', 250000, 40),
(N'Bảo dưỡng tổng thể xe máy định kỳ', N'Kiểm tra toàn bộ bugi, lọc gió, dây curoa, tra mỡ cổ phốt, căn chỉnh phanh', 300000, 60),
(N'Súc rửa két nước làm mát động cơ', N'Xúc rửa cặn bám trong hệ thống làm mát, thay nước giải nhiệt Liqui Moly', 200000, 35),
(N'Đại tu bảo dưỡng máy và động cơ', N'Hạ máy kiểm tra xéc-măng, supap, thay gioăng quy lát và căn chỉnh xích cam', 2500000, 240);
GO

-- 5. Insert SpareParts
INSERT INTO SpareParts (part_code, part_name, category, price, stock_quantity, unit, warranty_months) VALUES
('PART-OIL-01', N'Dầu nhớt Castrol Magnatec Stop-Start 5W-30 (4L)', N'Dầu nhớt', 480000, 50, N'Bình 4L', 6),
('PART-OIL-02', N'Dầu nhớt Motul Scooter Power LE 5W-40 (0.8L)', N'Dầu nhớt', 180000, 80, N'Chai 0.8L', 3),
('PART-FLT-01', N'Lọc dầu nhớt ô tô Honda chính hãng', N'Lọc nhớt', 120000, 35, N'Cái', 6),
('PART-FLT-02', N'Lọc gió động cơ Toyota Vios', N'Lọc gió', 160000, 25, N'Cái', 6),
('PART-BRK-01', N'Bộ má phanh trước Brembo Ceramic', N'Má phanh', 650000, 20, N'Bộ', 12),
('PART-BRK-02', N'Má phanh sau xe máy Nissin SH', N'Má phanh', 220000, 40, N'Bộ', 6),
('PART-SPK-01', N'Bugi Iridium NGK Laser IX', N'Bugi', 190000, 60, N'Cái', 12),
('PART-BAT-01', N'Bình ắc quy ô tô GS 12V - 45Ah', N'Ắc quy', 1150000, 15, N'Bình', 12),
('PART-BAT-02', N'Bình ắc quy xe máy Globe 12V - 6Ah', N'Ắc quy', 320000, 30, N'Bình', 9),
('PART-BELT-01', N'Dây curoa Bando Bando V-Belt cho SH', N'Dây curoa', 360000, 18, N'Sợi', 6),
('PART-COOL-01', N'Nước làm mát tản nhiệt Liqui Moly Coolant (1L)', N'Dung dịch làm mát', 150000, 45, N'Chai 1L', 6);
GO

-- 6. Insert RepairOrders mẫu
-- Đơn 1: Đã hoàn tất và đã thanh toán qua VNPay
INSERT INTO RepairOrders (order_code, vehicle_id, customer_id, technician_id, receive_date, completed_date, problem_description, diagnosis_notes, status, total_service_cost, total_part_cost, total_amount)
VALUES
('RO-202611-001', 1, 5, 3, DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, -2, GETDATE()), 
 N'Xe rung giật khi tăng tốc, máy gằn và đèn báo dầu nhớt sáng.', 
 N'Dầu máy cặn bẩn, lọc nhớt tắc nghẽn, má phanh trước bị mòn vẹt. Đã thay nhớt, lọc và thay má phanh mới.', 
 'PAID', 500000, 1250000, 1750000);

-- Chi tiết dịch vụ đơn 1
INSERT INTO RepairOrderServices (order_id, service_id, price, notes) VALUES
(1, 1, 150000, N'Thay nhớt và lọc nhớt'),
(1, 2, 350000, N'Bảo dưỡng phanh trước sau');

-- Chi tiết phụ tùng đơn 1
INSERT INTO RepairOrderParts (order_id, part_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 480000, 480000),
(1, 3, 1, 120000, 120000),
(1, 5, 1, 650000, 650000);

-- Hóa đơn đơn 1
INSERT INTO Invoices (invoice_code, order_id, created_date, subtotal, discount, tax, total_amount, payment_status, payment_method, paid_date)
VALUES
('INV-202611-001', 1, DATEADD(DAY, -2, GETDATE()), 1750000, 50000, 0, 1700000, 'PAID', 'VNPAY', DATEADD(DAY, -2, GETDATE()));

-- Nhật ký thanh toán VNPay đơn 1
INSERT INTO PaymentTransactions (invoice_id, vnp_txn_ref, vnp_transaction_no, vnp_amount, vnp_bank_code, vnp_response_code, vnp_pay_date, status)
VALUES
(1, 'INV-202611-001_1793798', '14589230', 1700000, 'NCB', '00', '20261102143000', 'SUCCESS');


-- Đơn 2: Đang trong quá trình sửa chữa (IN_PROGRESS)
INSERT INTO RepairOrders (order_code, vehicle_id, customer_id, technician_id, receive_date, completed_date, problem_description, diagnosis_notes, status, total_service_cost, total_part_cost, total_amount)
VALUES
('RO-202611-002', 3, 6, 4, DATEADD(HOUR, -5, GETDATE()), NULL, 
 N'Xe máy khởi động khó nổ vào buổi sáng, có tiếng kêu lách cách ở nồi xe.', 
 N'Bugi yếu tia lửa điện, dây curoa nồi bị rạn nứt. Đang tiến hành tháo bộ nồi để thay thế linh kiện.', 
 'IN_PROGRESS', 300000, 550000, 850000);

INSERT INTO RepairOrderServices (order_id, service_id, price, notes) VALUES
(2, 5, 300000, N'Bảo dưỡng nồi và tổng thể xe máy');

INSERT INTO RepairOrderParts (order_id, part_id, quantity, unit_price, total_price) VALUES
(2, 7, 1, 190000, 190000),
(2, 10, 1, 360000, 360000);

-- Hóa đơn tạm tính đơn 2
INSERT INTO Invoices (invoice_code, order_id, created_date, subtotal, discount, tax, total_amount, payment_status, payment_method, paid_date)
VALUES
('INV-202611-002', 2, GETDATE(), 850000, 0, 0, 850000, 'UNPAID', NULL, NULL);


-- Đơn 3: Mới tiếp nhận đang chờ kỹ thuật viên kiểm tra (PENDING)
INSERT INTO RepairOrders (order_code, vehicle_id, customer_id, technician_id, receive_date, completed_date, problem_description, diagnosis_notes, status, total_service_cost, total_part_cost, total_amount)
VALUES
('RO-202611-003', 2, 5, 3, DATEADD(HOUR, -1, GETDATE()), NULL, 
 N'Xe ô tô chạy qua chỗ xóc nghe tiếng lục cục ở bánh trước, tay lái bị lệch về bên phải.', 
 NULL, 
 'PENDING', 0, 0, 0);

GO

-- Kiểm tra kết quả
SELECT 'Roles' AS TableName, COUNT(*) AS TotalRows FROM Roles
UNION ALL
SELECT 'Users', COUNT(*) FROM Users
UNION ALL
SELECT 'Vehicles', COUNT(*) FROM Vehicles
UNION ALL
SELECT 'Services', COUNT(*) FROM Services
UNION ALL
SELECT 'SpareParts', COUNT(*) FROM SpareParts
UNION ALL
SELECT 'RepairOrders', COUNT(*) FROM RepairOrders
UNION ALL
SELECT 'Invoices', COUNT(*) FROM Invoices;
GO
