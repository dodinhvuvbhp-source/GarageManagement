<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kiểm Tra Kết Nối SQL Server - GarageDB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">
<div class="container">
    <div class="card shadow-sm border-0 mx-auto" style="max-width: 800px;">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">🔍 Chẩn Đoán Kết Nối CSDL SQL Server (GarageDB)</h5>
        </div>
        <div class="card-body">
            <%
                String dbName = "GarageDB";
                String user = "sa";
                String[] passwords = {"sa", "123456", "123", "12345678", "admin", "HE171854", "he171854", ""};
                String[] servers = {"localhost:1433", "localhost", "localhost\\SQLEXPRESS", "127.0.0.1:1433"};

                boolean success = false;
                String workingPass = "";
                String workingServer = "";
                List<String> logs = new ArrayList<>();

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    logs.add("✅ Đã tìm thấy SQL Server JDBC Driver.");
                } catch (ClassNotFoundException e) {
                    logs.add("❌ Không tìm thấy JDBC Driver: " + e.getMessage());
                }

                for (String srv : servers) {
                    for (String pass : passwords) {
                        String url = "jdbc:sqlserver://" + srv + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true";
                        try {
                            Connection conn = DriverManager.getConnection(url, user, pass);
                            if (conn != null && !conn.isClosed()) {
                                success = true;
                                workingPass = pass;
                                workingServer = srv;
                                conn.close();
                                break;
                            }
                        } catch (SQLException ex) {
                            String msg = ex.getMessage();
                            if (msg != null && (msg.contains("Cannot open database") || ex.getErrorCode() == 4060)) {
                                logs.add("⚠️ Mật khẩu '" + pass + "' ĐÚNG, nhưng Database '" + dbName + "' chưa được chọn!");
                            } else if (msg != null && (msg.contains("Login failed") || ex.getErrorCode() == 18456)) {
                                logs.add("❌ Thử Server [" + srv + "] Mật khẩu '" + pass + "' -> Sai mật khẩu (Login failed).");
                            } else {
                                logs.add("❌ Thử Server [" + srv + "] -> Lỗi: " + msg);
                                break; // Nếu server không kết nối được cổng thì bỏ qua các pass còn lại của server này
                            }
                        }
                    }
                    if (success) break;
                }
            %>

            <% if (success) { %>
                <div class="alert alert-success">
                    <h4 class="alert-heading">🎉 KẾT NỐI THÀNH CÔNG!</h4>
                    <p class="mb-1">Hệ thống đã tự động tìm thấy cấu hình kết nối chuẩn tới SQL Server của bạn:</p>
                    <ul>
                        <li><strong>Server:</strong> <code><%= workingServer %></code></li>
                        <li><strong>User:</strong> <code>sa</code></li>
                        <li><strong>Mật khẩu đúng:</strong> <code><%= workingPass.isEmpty() ? "(để trống)" : workingPass %></code></li>
                        <li><strong>Database:</strong> <code><%= dbName %></code></li>
                    </ul>
                    <hr>
                    <p class="mb-0">
                        👉 Bây giờ bạn có thể mở trang chủ tại:
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-success fw-bold ms-2">VÀO TRANG CHỦ GARAGE NGAY</a>
                    </p>
                </div>
            <% } else { %>
                <div class="alert alert-danger">
                    <h5 class="alert-heading">⚠️ CHƯA KẾT NỐI ĐƯỢC TỚI SQL SERVER</h5>
                    <p class="small mb-0">Dưới đây là chi tiết nhật ký các lần thử kết nối:</p>
                </div>

                <div class="bg-dark text-light p-3 rounded small font-monospace mb-3" style="max-height: 300px; overflow-y: auto;">
                    <% for (String log : logs) { %>
                        <div><%= log %></div>
                    <% } %>
                </div>

                <div class="card bg-light border">
                    <div class="card-body">
                        <h6 class="fw-bold text-primary">💡 HƯỚNG DẪN KHẮC PHỤC NHANH:</h6>
                        <ol class="small mb-0">
                            <li class="mb-2">
                                <strong>Xem mật khẩu bài cũ:</strong> Bạn hãy mở file <code>DBContext.java</code> trong project <code>HE171854_WS1_DE2</code> (hoặc <code>Suaxxe</code>) trên NetBeans để xem bạn đang dùng mật khẩu gì.
                            </li>
                            <li class="mb-2">
                                <strong>Nếu lỗi "The TCP/IP connection to the host has failed":</strong> Cổng TCP/IP 1433 chưa bật. Bạn mở <em>SQL Server Configuration Manager</em> -> <em>Protocols for MSSQLSERVER</em> -> chuyển TCP/IP sang <strong>Enabled</strong> -> Khởi động lại dịch vụ SQL Server.
                            </li>
                        </ol>
                    </div>
                </div>
            <% } %>

        </div>
    </div>
</div>
</body>
</html>
