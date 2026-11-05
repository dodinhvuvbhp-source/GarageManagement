<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đăng Nhập - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-lock text-primary display-4"></i>
                            <h3 class="fw-bold mt-2">Đăng Nhập Hệ Thống</h3>
                            <p class="text-muted small">Cửa hàng sửa chữa & bảo dưỡng xe AutoCare</p>
                        </div>

                        <!-- Thông báo lỗi -->
                        <c:if test="${error != null}">
                            <div class="alert alert-danger py-2 small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            </div>
                        </c:if>

                        <c:if test="${sessionScope.authError != null}">
                            <div class="alert alert-warning py-2 small" role="alert">
                                <i class="bi bi-shield-lock-fill me-2"></i>${sessionScope.authError}
                            </div>
                            <c:remove var="authError" scope="session" />
                        </c:if>

                        <c:if test="${param.msg == 'register_success'}">
                            <div class="alert alert-success py-2 small" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>Đăng ký tài khoản thành công! Bạn có thể đăng nhập ngay.
                            </div>
                        </c:if>

                        <c:if test="${param.msg == 'logged_out'}">
                            <div class="alert alert-info py-2 small" role="alert">
                                <i class="bi bi-info-circle-fill me-2"></i>Bạn đã đăng xuất khỏi hệ thống an toàn.
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label fw-medium">Tên đăng nhập</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${username != null ? username : ''}" placeholder="Nhập username..." required autofocus>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label fw-medium">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-key"></i></span>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Nhập mật khẩu..." required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Đăng Nhập
                            </button>
                        </form>

                        <div class="text-center mt-4">
                            <span class="text-muted small">Chưa có tài khoản?</span>
                            <a href="${pageContext.request.contextPath}/register" class="fw-bold text-decoration-none ms-1">
                                Đăng ký ngay
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/common/footer.jsp" %>
