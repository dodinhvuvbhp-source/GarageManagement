package com.garage.context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String DATABASE_NAME = "GarageDB";

    // Cấu hình tài khoản (Đổi mật khẩu theo máy bạn)
    private static final String USER_ID = "sa";
    private static final String PASSWORD = "sa"; 

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=" + DATABASE_NAME + ";encrypt=true;trustServerCertificate=true";
            return DriverManager.getConnection(url, USER_ID, PASSWORD);
        } catch (Exception e) {
            // Thử tiếp các cổng và mật khẩu dự phòng
            String[] tryUrls = {
                "jdbc:sqlserver://localhost:1433;databaseName=" + DATABASE_NAME + ";encrypt=true;trustServerCertificate=true",
                "jdbc:sqlserver://localhost;databaseName=" + DATABASE_NAME + ";encrypt=true;trustServerCertificate=true",
                "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=" + DATABASE_NAME + ";encrypt=true;trustServerCertificate=true",
                "jdbc:sqlserver://127.0.0.1:1433;databaseName=" + DATABASE_NAME + ";encrypt=true;trustServerCertificate=true"
            };
            String[] tryPass = {PASSWORD, "123456", "123", "12345678", "sa", "HE171854", "he171854", "admin", ""};
            for (String u : tryUrls) {
                for (String p : tryPass) {
                    try {
                        Connection c = DriverManager.getConnection(u, USER_ID, p);
                        if (c != null && !c.isClosed()) return c;
                    } catch (Exception ignored) {}
                }
            }
            throw new RuntimeException("Không thể kết nối SQL Server: " + e.getMessage(), e);
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ignored) {}
        }
    }

    public static void main(String[] args) {
        System.out.println("\n---------------------------------------------------------");
        System.out.println(">>> ĐANG KIỂM TRA LỖI KẾT NỐI SQL SERVER CHI TIẾT <<<");
        System.out.println("---------------------------------------------------------");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("[OK] Đã tìm thấy SQL Server JDBC Driver.");
        } catch (Exception e) {
            System.out.println("[LỖI DRIVER]: " + e.getMessage());
            return;
        }

        String testUrl = "jdbc:sqlserver://localhost:1433;databaseName=" + DATABASE_NAME + ";encrypt=true;trustServerCertificate=true";
        System.out.println("Đang thử kết nối tới: " + testUrl);
        System.out.println("Tài khoản: " + USER_ID + " | Mật khẩu: " + PASSWORD);

        try {
            Connection conn = DriverManager.getConnection(testUrl, USER_ID, PASSWORD);
            if (conn != null) {
                System.out.println("\n>>> KẾT NỐI THÀNH CÔNG RỰC RỠ TỚI DATABASE " + DATABASE_NAME + "! <<<");
                conn.close();
            }
        } catch (SQLException ex) {
            System.out.println("\n[NGUYÊN NHÂN SQL SERVER BÁO LỖI]:");
            System.out.println("Mã lỗi (Error Code): " + ex.getErrorCode());
            System.out.println("Thông báo chi tiết: " + ex.getMessage());

            if (ex.getMessage().contains("TCP/IP") || ex.getMessage().contains("Connection refused") || ex.getErrorCode() == 0) {
                System.out.println("\n==> GIẢI THÍCH: Cổng TCP/IP 1433 của SQL Server chưa được bật trên máy bạn.");
                System.out.println("==> CÁCH SỬA: Mở 'SQL Server Configuration Manager' -> SQL Server Network Configuration -> Protocols -> Bật (Enabled) TCP/IP -> Restart SQL Server.");
            } else if (ex.getMessage().contains("Login failed") || ex.getErrorCode() == 18456) {
                System.out.println("\n==> GIẢI THÍCH: Sai mật khẩu hoặc tài khoản 'sa' đang bị tắt.");
                System.out.println("==> CÁCH SỬA: Hãy xem mật khẩu bạn dùng trong bài " + "HE171854_WS1_DE2" + " là gì và điền vào dòng 11 PASSWORD = \"...\".");
            }
        }
        System.out.println("---------------------------------------------------------\n");
    }
}
