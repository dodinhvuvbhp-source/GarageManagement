<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đăng Ký Tài Khoản Khách Hàng - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-plus-fill text-warning display-4"></i>
                            <h3 class="fw-bold mt-2">Đăng Ký Tài Khoản</h3>
                            <p class="text-muted small">Tạo tài khoản để theo dõi lịch sử bảo dưỡng và thanh toán trực tuyến</p>
                        </div>

                        <c:if test="${error != null}">
                            <div class="alert alert-danger py-2 small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label fw-medium">Tên đăng nhập <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="username" placeholder="Ví dụ: nguyenvana" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Mật khẩu <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" name="password" placeholder="Tối thiểu 6 ký tự" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-medium">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="fullName" placeholder="Ví dụ: Nguyễn Văn A" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" name="phone" placeholder="0901234567" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Địa chỉ Email</label>
                                    <input type="email" class="form-control" name="email" placeholder="example@email.com">
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-medium">Địa chỉ cư trú</label>
                                    <input type="text" class="form-control" name="address" placeholder="Số nhà, tên đường, quận/huyện...">
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-warning w-100 py-2 fw-bold text-dark">
                                        <i class="bi bi-check2-circle me-1"></i>Hoàn Tất Đăng Ký
                                    </button>
                                </div>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <span class="text-muted small">Đã có tài khoản?</span>
                            <a href="${pageContext.request.contextPath}/login" class="fw-bold text-decoration-none ms-1">
                                Đăng nhập ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/common/footer.jsp" %>
