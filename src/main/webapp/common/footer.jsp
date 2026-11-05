<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="py-5 mt-5 bg-dark text-light" style="background-color: #0b1120 !important; color: #cbd5e1 !important;">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white mb-3 fw-bold" style="color: #ffffff !important;">
                    <i class="bi bi-wrench-adjustable-circle text-warning me-2"></i>CỬA HÀNG SỬA CHỮA XE
                </h5>
                <p class="small text-light opacity-75" style="color: #cbd5e1 !important;">
                    Trung tâm bảo dưỡng, chăm sóc và sửa chữa xe ô tô - xe máy chuyên nghiệp hàng đầu. Cam kết linh kiện chính hãng, thợ tay nghề cao, thanh toán minh bạch nhanh chóng.
                </p>
                <div class="d-flex gap-3">
                    <a href="#" class="text-light fs-5"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-light fs-5"><i class="bi bi-youtube"></i></a>
                    <a href="#" class="text-light fs-5"><i class="bi bi-tiktok"></i></a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3 text-uppercase fw-bold" style="color: #ffffff !important;">Dịch vụ sửa chữa</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-light text-decoration-none opacity-75">Thay dầu nhớt & Bảo dưỡng định kỳ</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-light text-decoration-none opacity-75">Kiểm tra hệ thống phanh</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-light text-decoration-none opacity-75">Cân chỉnh thước lái 3D</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-light text-decoration-none opacity-75">Vệ sinh buồng đốt & kim phun</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/services" class="text-light text-decoration-none opacity-75">Đại tu động cơ & hộp số</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white mb-3 text-uppercase fw-bold" style="color: #ffffff !important;">Liên kết nhanh</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/home" class="text-light text-decoration-none opacity-75">Trang chủ</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/parts" class="text-light text-decoration-none opacity-75">Kho linh kiện phụ tùng</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/order-create" class="text-light text-decoration-none opacity-75">Đặt lịch hẹn sửa xe</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/login" class="text-light text-decoration-none opacity-75">Đăng nhập hệ thống</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3 text-uppercase fw-bold" style="color: #ffffff !important;">Liên hệ & Địa chỉ</h6>
                <p class="small mb-2 text-light" style="color: #cbd5e1 !important;"><i class="bi bi-geo-alt-fill text-warning me-2"></i>123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội</p>
                <p class="small mb-2 text-light" style="color: #cbd5e1 !important;"><i class="bi bi-telephone-fill text-warning me-2"></i>Hotline: 0901.234.567</p>
                <p class="small mb-2 text-light" style="color: #cbd5e1 !important;"><i class="bi bi-envelope-fill text-warning me-2"></i>Email: contact@garage-suaxe.com</p>
                <p class="small mb-0 text-light" style="color: #cbd5e1 !important;"><i class="bi bi-clock-fill text-warning me-2"></i>Giờ mở cửa: 07:30 - 18:30 (Thứ 2 - CN)</p>
            </div>
        </div>
        <hr class="border-secondary my-4 opacity-25">
        <div class="text-center small text-light opacity-75" style="color: #94a3b8 !important;">
            &copy; 2026 Cửa Hàng Sửa Chữa Xe. Đồ án môn học PRJ301 - Java Web Application. Powered by Servlet, JSP, JSTL, SQL Server & NetBeans.
        </div>
    </div>
</footer>

<!-- Xóa bỏ key theme cũ trong browser -->
<script>
    try {
        localStorage.removeItem('garage_theme');
        document.documentElement.removeAttribute('data-bs-theme');
    } catch(e) {}
</script>

<!-- Bootstrap 5 Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
