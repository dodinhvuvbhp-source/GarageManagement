<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Bảng Giá Dịch Vụ Sửa Chữa & Bảo Dưỡng - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <!-- Header & Toolbar -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h2 class="fw-bold mb-1"><i class="bi bi-gear-wide-connected text-primary me-2"></i>Bảng Giá Dịch Vụ Sửa Chữa</h2>
                <p class="text-muted mb-0">Danh sách các dịch vụ kiểm tra, bảo dưỡng và sửa chữa chính quy tại xưởng</p>
            </div>
            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                    <button class="btn btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#addServiceModal">
                        <i class="bi bi-plus-circle me-1"></i>Thêm Dịch Vụ Mới
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Search Bar -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/services" method="get" class="row g-2">
                    <div class="col-md-10">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên dịch vụ, mô tả..."
                                   value="${keyword != null ? keyword : ''}">
                        </div>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-outline-primary fw-bold">Tìm kiếm</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Danh sách dịch vụ dạng thẻ -->
        <div class="row g-4">
            <c:forEach items="${services}" var="s">
                <div class="col-lg-4 col-md-6">
                    <div class="card h-100 shadow-sm border-0 position-relative">
                        <c:if test="${!s.active}">
                            <span class="position-absolute top-0 end-0 badge bg-danger m-2">Đã tạm ngừng</span>
                        </c:if>
                        <div class="card-body d-flex flex-column">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title fw-bold text-dark">${s.serviceName}</h5>
                                <span class="badge bg-light text-primary border">
                                    <i class="bi bi-stopwatch me-1"></i>${s.estimatedDuration} phút
                                </span>
                            </div>
                            <p class="card-text text-muted small flex-grow-1">${s.description}</p>
                            
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                <div>
                                    <small class="text-secondary d-block">Tiền công dịch vụ</small>
                                    <span class="fs-5 fw-bold text-danger">
                                        <garage:currency value="${s.price}" />
                                    </span>
                                </div>
                                <div class="d-flex gap-2">
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                                            <button class="btn btn-outline-secondary btn-sm" onclick="editService(${s.serviceId}, '${s.serviceName}', '${s.description}', ${s.price}, ${s.estimatedDuration}, ${s.active ? 1 : 0})">
                                                <i class="bi bi-pencil"></i> Sửa
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/order-create" class="btn btn-primary btn-sm">
                                                <i class="bi bi-plus-circle me-1"></i>Đặt làm
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<!-- Modal Thêm Dịch Vụ Mới -->
<c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
<div class="modal fade" id="addServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/services" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle text-primary me-2"></i>Thêm Dịch Vụ Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Tên dịch vụ <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="serviceName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Mô tả chi tiết</label>
                        <textarea class="form-control" name="description" rows="3"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Đơn giá (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" min="0" step="1000" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Thời gian ước tính (phút)</label>
                            <input type="number" class="form-control" name="estimatedDuration" value="30" min="5" step="5">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary fw-bold">Lưu Dịch Vụ</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Sửa Dịch Vụ -->
<div class="modal fade" id="editServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/services" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="serviceId" id="editServiceId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-primary me-2"></i>Chỉnh Sửa Dịch Vụ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Tên dịch vụ</label>
                        <input type="text" class="form-control" name="serviceName" id="editServiceName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Mô tả</label>
                        <textarea class="form-control" name="description" id="editServiceDesc" rows="3"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Đơn giá (VNĐ)</label>
                            <input type="number" class="form-control" name="price" id="editServicePrice" min="0" step="1000" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Thời gian (phút)</label>
                            <input type="number" class="form-control" name="estimatedDuration" id="editServiceDuration" min="5">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Trạng thái</label>
                        <select class="form-select" name="isActive" id="editServiceActive">
                            <option value="1">Đang hoạt động</option>
                            <option value="0">Tạm ngừng</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary fw-bold">Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function editService(id, name, desc, price, duration, active) {
    document.getElementById('editServiceId').value = id;
    document.getElementById('editServiceName').value = name;
    document.getElementById('editServiceDesc').value = desc;
    document.getElementById('editServicePrice').value = price;
    document.getElementById('editServiceDuration').value = duration;
    document.getElementById('editServiceActive').value = active;
    new bootstrap.Modal(document.getElementById('editServiceModal')).show();
}
</script>
</c:if>

<%@ include file="/common/footer.jsp" %>
