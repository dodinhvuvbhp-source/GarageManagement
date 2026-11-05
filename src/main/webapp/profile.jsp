<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Hồ Sơ Cá Nhân - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 border-bottom">
                    <h4 class="mb-0 fw-bold"><i class="bi bi-person-circle text-primary me-2"></i>Thông Tin Tài Khoản</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty sessionScope.flashSuccess}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashSuccess}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="flashSuccess" scope="session"/>
                    </c:if>

                    <c:if test="${not empty sessionScope.flashError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.flashError}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="flashError" scope="session"/>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="updateInfo">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên đăng nhập (Username):</label>
                            <input type="text" class="form-control bg-light" value="${currentUser.username}" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Vai trò hệ thống:</label>
                            <div>
                                <span class="badge bg-primary fs-6">${currentUser.roleName}</span>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên <span class="text-danger">*</span>:</label>
                            <input type="text" name="fullName" class="form-control" value="${currentUser.fullName}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Email:</label>
                            <input type="email" name="email" class="form-control" value="${currentUser.email}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Số điện thoại <span class="text-danger">*</span>:</label>
                            <input type="text" name="phone" class="form-control" value="${currentUser.phone}" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Địa chỉ:</label>
                            <textarea name="address" class="form-control" rows="2">${currentUser.address}</textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary fw-semibold py-2">
                                <i class="bi bi-save me-1"></i>Lưu Thay Đổi Thông Tin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
