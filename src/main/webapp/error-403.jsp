<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Không Có Quyền Truy Cập - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-5">
                <div class="mb-3">
                    <i class="bi bi-shield-slash-fill text-danger" style="font-size: 5rem;"></i>
                </div>
                <h1 class="display-5 fw-bold text-danger mb-2">403</h1>
                <h4 class="fw-bold mb-3">Truy Cập Bị Từ Chối (Access Denied)</h4>
                <p class="text-muted mb-4">
                    Tài khoản của bạn không có đủ thẩm quyền để truy cập vào phân hệ chức năng này. Vui lòng liên hệ Quản trị viên (Admin) nếu bạn cần hỗ trợ thêm quyền hạn.
                </p>
                <div>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 fw-semibold">
                        <i class="bi bi-house me-1"></i>Trở về Trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
