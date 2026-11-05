<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Quản Lý Phương Tiện - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1"><i class="bi bi-car-front-fill text-primary me-2"></i>Danh Sách Phương Tiện</h2>
                <p class="text-muted mb-0">Quản lý thông tin xe ô tô và xe máy để theo dõi lịch sử bảo dưỡng</p>
            </div>
            <button type="button" class="btn btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#addVehicleModal">
                <i class="bi bi-plus-circle me-1"></i>Đăng Ký Xe Mới
            </button>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3">Biển số xe</th>
                                <th>Loại xe</th>
                                <th>Hãng & Dòng xe</th>
                                <th>Màu sơn</th>
                                <th>Năm SX</th>
                                <th>Chủ xe (Khách hàng)</th>
                                <th>Số điện thoại</th>
                                <th class="text-end pe-3">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${vehicles}" var="v">
                                <tr>
                                    <td class="ps-3 fw-bold text-primary">
                                        <i class="bi bi-car-front me-1"></i>${v.licensePlate}
                                    </td>
                                    <td>
                                        <span class="badge ${v.vehicleType == 'Ô tô' ? 'bg-info text-dark' : 'bg-secondary'}">
                                            ${v.vehicleType}
                                        </span>
                                    </td>
                                    <td class="fw-bold">${v.brand} ${v.model}</td>
                                    <td>${v.color}</td>
                                    <td>${v.manufactureYear}</td>
                                    <td>${v.customerName}</td>
                                    <td>${v.customerPhone}</td>
                                    <td class="text-end pe-3">
                                        <a href="${pageContext.request.contextPath}/order-create?vehicleId=${v.vehicleId}" class="btn btn-sm btn-outline-warning text-dark fw-bold me-1">
                                            <i class="bi bi-calendar-plus"></i> Đặt sửa
                                        </a>
                                        <form action="${pageContext.request.contextPath}/vehicles" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="vehicleId" value="${v.vehicleId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa xe ${v.licensePlate} không?')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty vehicles}">
                                <tr>
                                    <td colspan="8" class="text-center py-4 text-muted">
                                        Chưa có phương tiện nào được ghi nhận. Vui lòng bấm 
                                        <button type="button" class="btn btn-link p-0 fw-bold align-baseline" data-bs-toggle="modal" data-bs-target="#addVehicleModal">
                                            Đăng Ký Xe Mới
                                        </button>!
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Modal Thêm Xe Mới -->
<div class="modal fade" id="addVehicleModal" tabindex="-1" aria-labelledby="addVehicleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/vehicles" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold" id="addVehicleModalLabel"><i class="bi bi-plus-circle me-2"></i>Đăng Ký Xe Mới</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                            <div class="mb-3">
                                <label class="form-label fw-medium">Chủ sở hữu (Khách hàng) <span class="text-danger">*</span></label>
                                <select name="customerId" class="form-select" required>
                                    <c:forEach items="${customers}" var="c">
                                        <option value="${c.userId}">${c.fullName} - ${c.phone}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mb-3">
                                <label class="form-label fw-medium">Chủ xe tiếp nhận</label>
                                <input type="text" class="form-control bg-light" value="${sessionScope.currentUser.fullName} (${sessionScope.currentUser.phone})" readonly>
                                <input type="hidden" name="customerId" value="${sessionScope.currentUser.userId}">
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="mb-3">
                        <label class="form-label fw-medium">Biển số xe <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="licensePlate" placeholder="Ví dụ: 30F-123.45 hoặc 29B1-888.99" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Loại phương tiện</label>
                            <select name="vehicleType" class="form-select">
                                <option value="Ô tô">Ô tô</option>
                                <option value="Xe máy">Xe máy</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Hãng xe</label>
                            <input type="text" class="form-control" name="brand" placeholder="Honda, Toyota, Yamaha, Mazda..." required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Dòng xe / Model</label>
                            <input type="text" class="form-control" name="model" placeholder="Vios, CR-V, SH, Exciter, CX-5..." required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Màu sơn</label>
                            <input type="text" class="form-control" name="color" placeholder="Đen, Trắng, Đỏ, Bạc...">
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label fw-medium">Năm sản xuất</label>
                            <input type="number" class="form-control" name="manufactureYear" value="2023" min="1990" max="2030">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary fw-bold px-4">Lưu Phương Tiện</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
