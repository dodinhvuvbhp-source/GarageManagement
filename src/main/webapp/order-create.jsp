 <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đặt Lịch Hẹn & Tiếp Nhận Sửa Chữa - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-white py-3 border-bottom d-flex align-items-center justify-content-between">
                        <h4 class="fw-bold mb-0 text-primary">
                            <i class="bi bi-calendar2-week me-2"></i>Đặt Lịch Hẹn & Tạo Phiếu Sửa Chữa Xe
                        </h4>
                        <span class="badge bg-warning text-dark px-3 py-2">
                            <i class="bi bi-clock-history me-1"></i>Chủ động chọn giờ hẹn
                        </span>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger py-2 small mb-3">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            </div>
                        </c:if>

                        <c:if test="${empty vehicles}">
                            <div class="alert alert-warning">
                                <i class="bi bi-exclamation-circle me-2"></i>Bạn chưa đăng ký phương tiện nào trong hệ thống!
                                <a href="${pageContext.request.contextPath}/vehicles" class="alert-link ms-2">Bấm vào đây để đăng ký xe trước.</a>
                            </div>
                        </c:if>

                        <c:if test="${not empty vehicles}">
                            <form action="${pageContext.request.contextPath}/order-create" method="post">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Chọn phương tiện cần sửa chữa / bảo dưỡng <span class="text-danger">*</span></label>
                                    <select name="vehicleId" class="form-select form-select-lg" required>
                                        <option value="">-- Chọn xe theo biển số --</option>
                                        <c:forEach items="${vehicles}" var="v">
                                            <option value="${v.vehicleId}" ${param.vehicleId == v.vehicleId ? 'selected' : ''}>
                                                ${v.licensePlate} - ${v.brand} ${v.model} (${v.vehicleType} - ${v.customerName})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Chức năng chọn ngày & giờ hẹn sửa xe -->
                                <div class="mb-3">
                                    <label class="form-label fw-bold">
                                        <i class="bi bi-alarm text-primary me-1"></i>Hẹn ngày & giờ mang xe đến xưởng
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-calendar-event"></i></span>
                                        <input type="datetime-local" class="form-control form-control-lg" name="appointmentTime" id="appointmentTime">
                                    </div>
                                    <div class="form-text">
                                        Chọn khung giờ thuận tiện cho bạn (Garage mở cửa phục vụ từ 07:30 đến 18:30 tất cả các ngày trong tuần).
                                    </div>
                                </div>

                                <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Phân công kỹ thuật viên phụ trách</label>
                                        <select name="technicianId" class="form-select">
                                            <option value="">-- Để trống nếu phân công sau --</option>
                                            <c:forEach items="${technicians}" var="t">
                                                <option value="${t.userId}">${t.fullName} (SĐT: ${t.phone})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </c:if>

                                <div class="mb-4">
                                    <label class="form-label fw-bold">Mô tả tình trạng hư hỏng / Yêu cầu bảo dưỡng <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="problemDescription" rows="4"
                                              placeholder="Ví dụ: Xe kêu lọc cọc ở gầm trước khi đánh lái, cần thay dầu máy và lọc nhớt định kỳ, hẹn 9h sáng thứ 7 mang qua..." required></textarea>
                                    <div class="form-text">Mô tả chi tiết giúp kỹ thuật viên chuẩn bị sẵn vật tư phụ tùng và xử lý nhanh chóng hơn.</div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                                    </a>
                                    <button type="submit" class="btn btn-primary btn-lg fw-bold px-4">
                                        <i class="bi bi-calendar-check me-2"></i>Xác Nhận Đặt Lịch Hẹn
                                    </button>
                                </div>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Tự động gán thời gian mặc định là ngày mai cùng giờ hoặc thời điểm hiện tại
    window.addEventListener('DOMContentLoaded', () => {
        const appointmentInput = document.getElementById('appointmentTime');
        if (appointmentInput && !appointmentInput.value) {
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            appointmentInput.min = now.toISOString().slice(0, 16);
            
            // Mặc định gợi ý sau 2 tiếng
            const suggestTime = new Date(Date.now() + 2 * 60 * 60 * 1000);
            suggestTime.setMinutes(suggestTime.getMinutes() - suggestTime.getTimezoneOffset());
            appointmentInput.value = suggestTime.toISOString().slice(0, 16);
        }
    });
</script>

<%@ include file="/common/footer.jsp" %>
