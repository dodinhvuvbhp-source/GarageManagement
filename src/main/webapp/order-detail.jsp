<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Chi Tiết Phiếu Sửa Chữa ${order.orderCode} - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <!-- Header Phiếu -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <a href="${pageContext.request.contextPath}/orders" class="text-decoration-none small text-muted">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách phiếu
                </a>
                <h2 class="fw-bold mb-0 mt-1">
                    Phiếu Tiếp Nhận: <span class="text-primary">${order.orderCode}</span>
                </h2>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="fs-5"><garage:statusBadge status="${order.status}" /></span>

                <c:if test="${invoice != null}">
                    <a href="${pageContext.request.contextPath}/invoices?action=detail&id=${invoice.invoiceId}" class="btn btn-outline-success fw-bold">
                        <i class="bi bi-receipt me-1"></i>Xem Hóa Đơn
                    </a>
                </c:if>
            </div>
        </div>

        <div class="row g-4">
            <!-- Cột trái: Thông tin phương tiện, khách hàng & chẩn đoán -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white">
                        <h6 class="fw-bold mb-0 text-primary"><i class="bi bi-info-circle me-2"></i>Thông Tin Tiếp Nhận</h6>
                    </div>
                    <div class="card-body">
                        <ul class="list-unstyled small mb-0">
                            <li class="mb-2"><strong>Biển số xe:</strong> <span class="badge bg-primary fs-6">${order.licensePlate}</span></li>
                            <li class="mb-2"><strong>Dòng xe:</strong> ${order.vehicleInfo}</li>
                            <li class="mb-2"><strong>Khách hàng:</strong> ${order.customerName}</li>
                            <li class="mb-2"><strong>Số điện thoại:</strong> ${order.customerPhone}</li>
                            <li class="mb-2"><strong>Ngày tiếp nhận:</strong> <fmt:formatDate value="${order.receiveDate}" pattern="dd/MM/yyyy HH:mm" /></li>
                            <c:if test="${order.completedDate != null}">
                                <li class="mb-2"><strong>Ngày hoàn thành:</strong> <fmt:formatDate value="${order.completedDate}" pattern="dd/MM/yyyy HH:mm" /></li>
                            </c:if>
                            <li class="mb-0">
                                <strong>Kỹ thuật viên:</strong>
                                <span class="fw-bold text-dark">${order.technicianName != null ? order.technicianName : 'Chưa phân công'}</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Cập nhật Kỹ thuật viên & Trạng thái (Admin / Staff) -->
                <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-white">
                            <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-sliders me-2"></i>Điều Phối & Trạng Thái</h6>
                        </div>
                        <div class="card-body">
                            <!-- Phân công thợ -->
                            <form action="${pageContext.request.contextPath}/order-detail" method="post" class="mb-3">
                                <input type="hidden" name="action" value="assignTech">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <label class="form-label small fw-bold">Phân công kỹ thuật viên</label>
                                <div class="input-group">
                                    <select name="technicianId" class="form-select form-select-sm" required>
                                        <option value="">-- Chọn kỹ thuật viên --</option>
                                        <c:forEach items="${technicians}" var="t">
                                            <option value="${t.userId}" ${order.technicianId == t.userId ? 'selected' : ''}>
                                                ${t.fullName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <button class="btn btn-outline-primary btn-sm" type="submit">Gán thợ</button>
                                </div>
                            </form>

                            <!-- Đổi trạng thái -->
                            <form action="${pageContext.request.contextPath}/order-detail" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <label class="form-label small fw-bold">Cập nhật tiến độ</label>
                                <div class="input-group">
                                    <select name="status" class="form-select form-select-sm">
                                        <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ tiếp nhận</option>
                                        <option value="IN_PROGRESS" ${order.status == 'IN_PROGRESS' ? 'selected' : ''}>Đang sửa chữa</option>
                                        <option value="COMPLETED" ${order.status == 'COMPLETED' ? 'selected' : ''}>Đã sửa xong</option>
                                        <option value="PAID" ${order.status == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                                        <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Hủy bỏ</option>
                                    </select>
                                    <button class="btn btn-outline-dark btn-sm" type="submit">Lưu</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

                <!-- Mô tả hư hỏng & Ghi chú chẩn đoán -->
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white">
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-chat-left-text me-2"></i>Mô Tả & Chẩn Đoán Lỗi</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <span class="text-secondary small fw-bold d-block">Yêu cầu của khách:</span>
                            <div class="p-2 bg-light rounded small mt-1">${order.problemDescription}</div>
                        </div>

                        <div>
                            <span class="text-secondary small fw-bold d-block">Kết quả chẩn đoán kỹ thuật:</span>
                            <c:choose>
                                <c:when test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2 || sessionScope.currentUser.roleId == 3}">
                                    <form action="${pageContext.request.contextPath}/order-detail" method="post" class="mt-2">
                                        <input type="hidden" name="action" value="updateDiagnosis">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <textarea name="diagnosisNotes" rows="3" class="form-control form-control-sm mb-2"
                                                  placeholder="Nhập chẩn đoán hư hỏng...">${order.diagnosisNotes}</textarea>
                                        <button type="submit" class="btn btn-sm btn-outline-primary w-100">Lưu kết quả chẩn đoán</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-2 bg-light rounded small mt-1">
                                        ${order.diagnosisNotes != null ? order.diagnosisNotes : 'Chưa có ghi chú chẩn đoán.'}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Chi tiết Dịch vụ, Phụ tùng & Tổng tiền -->
            <div class="col-lg-8">
                <!-- Danh sách Dịch Vụ Thực Hiện -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0 text-primary">
                            <i class="bi bi-gear-wide-connected me-2"></i>Công Dịch Vụ Sửa Chữa / Bảo Dưỡng
                        </h6>
                        <c:if test="${order.status != 'PAID' && order.status != 'CANCELLED' && (sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2 || sessionScope.currentUser.roleId == 3)}">
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addServiceModal">
                                <i class="bi bi-plus-circle me-1"></i>Thêm dịch vụ
                            </button>
                        </c:if>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-3">Tên dịch vụ</th>
                                        <th>Ghi chú</th>
                                        <th class="text-end">Tiền công</th>
                                        <c:if test="${order.status != 'PAID' && (sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2)}">
                                            <th class="text-end pe-3" style="width: 50px;">Xóa</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${order.services}" var="s">
                                        <tr>
                                            <td class="ps-3 fw-bold">${s.serviceName}</td>
                                            <td class="text-muted small">${s.notes != null ? s.notes : ''}</td>
                                            <td class="text-end fw-bold text-dark"><garage:formatCurrency value="${s.price}" /></td>
                                            <c:if test="${order.status != 'PAID' && (sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2)}">
                                                <td class="text-end pe-3">
                                                    <form action="${pageContext.request.contextPath}/order-detail" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="removeService">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <input type="hidden" name="detailId" value="${s.id}">
                                                        <button type="submit" class="btn btn-sm text-danger p-0" title="Xóa"><i class="bi bi-trash"></i></button>
                                                    </form>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty order.services}">
                                        <tr>
                                            <td colspan="4" class="text-center py-3 text-muted small">Chưa có dịch vụ nào được thêm.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Danh sách Phụ Tùng Linh Kiện Thay Thế -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0 text-success">
                            <i class="bi bi-box-seam me-2"></i>Phụ Tùng & Linh Kiện Sử Dụng
                        </h6>
                        <c:if test="${order.status != 'PAID' && order.status != 'CANCELLED' && (sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2 || sessionScope.currentUser.roleId == 3)}">
                            <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#addPartModal">
                                <i class="bi bi-plus-circle me-1"></i>Thêm phụ tùng
                            </button>
                        </c:if>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-3">Tên phụ tùng</th>
                                        <th class="text-center">Số lượng</th>
                                        <th class="text-end">Đơn giá</th>
                                        <th class="text-end">Thành tiền</th>
                                        <c:if test="${order.status != 'PAID' && (sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2)}">
                                            <th class="text-end pe-3" style="width: 50px;">Hủy</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${order.parts}" var="p">
                                        <tr>
                                            <td class="ps-3 fw-bold">
                                                ${p.partName} <small class="text-muted">(${p.partCode})</small>
                                            </td>
                                            <td class="text-center">${p.quantity} ${p.unit}</td>
                                            <td class="text-end"><garage:formatCurrency value="${p.unitPrice}" /></td>
                                            <td class="text-end fw-bold text-dark"><garage:formatCurrency value="${p.totalPrice}" /></td>
                                            <c:if test="${order.status != 'PAID' && (sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2)}">
                                                <td class="text-end pe-3">
                                                    <form action="${pageContext.request.contextPath}/order-detail" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="removePart">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <input type="hidden" name="detailId" value="${p.id}">
                                                        <input type="hidden" name="partId" value="${p.partId}">
                                                        <input type="hidden" name="quantity" value="${p.quantity}">
                                                        <button type="submit" class="btn btn-sm text-danger p-0" title="Hoàn lại kho"><i class="bi bi-trash"></i></button>
                                                    </form>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty order.parts}">
                                        <tr>
                                            <td colspan="5" class="text-center py-3 text-muted small">Chưa sử dụng phụ tùng nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Bảng tổng hợp chi phí -->
                <div class="card shadow-sm border-0 mb-4 bg-light">
                    <div class="card-body p-4">
                        <div class="row align-items-center">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <div class="d-flex justify-content-between mb-1 small">
                                    <span>Tổng tiền công dịch vụ:</span>
                                    <strong><garage:formatCurrency value="${order.totalServiceCost}" /></strong>
                                </div>
                                <div class="d-flex justify-content-between mb-2 small">
                                    <span>Tổng tiền phụ tùng thay thế:</span>
                                    <strong><garage:formatCurrency value="${order.totalPartCost}" /></strong>
                                </div>
                                <hr class="my-2">
                                <div class="d-flex justify-content-between fs-5 fw-bold text-danger">
                                    <span>TỔNG CỘNG:</span>
                                    <span><garage:formatCurrency value="${order.totalAmount}" /></span>
                                </div>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <c:choose>
                                    <c:when test="${invoice != null}">
                                        <a href="${pageContext.request.contextPath}/invoices?action=detail&id=${invoice.invoiceId}" class="btn btn-primary btn-lg fw-bold px-4 shadow">
                                            <i class="bi bi-receipt me-1"></i>Xem Hóa Đơn Chi Tiết
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                                            <form action="${pageContext.request.contextPath}/order-detail" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                <input type="hidden" name="status" value="COMPLETED">
                                                <button type="submit" class="btn btn-warning btn-lg fw-bold px-4 text-dark shadow">
                                                    <i class="bi bi-check2-all me-1"></i>Hoàn Tất & Lập Hóa Đơn
                                                </button>
                                            </form>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</main>

<!-- Modal Thêm Dịch Vụ Vào Phiếu -->
<div class="modal fade" id="addServiceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/order-detail" method="post">
                <input type="hidden" name="action" value="addService">
                <input type="hidden" name="orderId" value="${order.orderId}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-gear me-2"></i>Thêm Công Dịch Vụ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Chọn dịch vụ</label>
                        <select name="serviceId" class="form-select" required>
                            <c:forEach items="${allServices}" var="s">
                                <option value="${s.serviceId}">${s.serviceName} (<garage:formatCurrency value="${s.price}" />)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Ghi chú kèm theo</label>
                        <input type="text" name="notes" class="form-control" placeholder="Ví dụ: Kiểm tra kỹ má phanh sau...">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary fw-bold">Thêm Vào Phiếu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Thêm Phụ Tùng Vào Phiếu -->
<div class="modal fade" id="addPartModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/order-detail" method="post">
                <input type="hidden" name="action" value="addPart">
                <input type="hidden" name="orderId" value="${order.orderId}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-box me-2"></i>Thêm Phụ Tùng Thay Thế</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Chọn linh kiện / phụ tùng</label>
                        <select name="partId" class="form-select" required>
                            <c:forEach items="${allParts}" var="p">
                                <option value="${p.partId}">${p.partName} - Tồn: ${p.stockQuantity} ${p.unit} (<garage:formatCurrency value="${p.price}" />)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Số lượng thay thế</label>
                        <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-warning fw-bold text-dark">Thêm Vào Phiếu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
