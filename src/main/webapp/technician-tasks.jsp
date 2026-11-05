<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Nhiệm Vụ Kỹ Thuật Viên - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-tools text-primary me-2"></i>Nhiệm Vụ Kỹ Thuật Viên Phụ Trách</h2>
            <p class="text-muted mb-0">Danh sách các phiếu sửa chữa được phân công cho kỹ thuật viên: <strong>${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.currentUser.fullName}</strong></p>
        </div>
        <span class="badge bg-primary px-3 py-2 fs-6">
            <i class="bi bi-person-badge me-1"></i>Kỹ thuật viên
        </span>
    </div>

    <c:if test="${not empty sessionScope.flashSuccess}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flashSuccess" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.flashError}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flashError" scope="session"/>
    </c:if>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold"><i class="bi bi-list-task me-2 text-primary"></i>Danh Sách Xe Cần Xử Lý (${assignedOrders.size()})</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">Mã phiếu</th>
                            <th>Xe & Biển số</th>
                            <th>Khách hàng</th>
                            <th>Ngày nhận</th>
                            <th>Chẩn đoán & Ghi chú</th>
                            <th>Trạng thái</th>
                            <th class="text-end pe-3">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty assignedOrders}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-clipboard-check fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                        Hiện tại bạn chưa có phiếu sửa chữa nào được phân công hoặc các phiếu đã hoàn tất!
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="order" items="${assignedOrders}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-primary">${order.orderCode}</td>
                                        <td>
                                            <div class="fw-bold">${order.licensePlate}</div>
                                            <small class="text-muted">${order.vehicleModel}</small>
                                        </td>
                                        <td>
                                            <div>${order.customerName}</div>
                                            <small class="text-muted">${order.customerPhone}</small>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <span class="text-truncate d-inline-block" style="max-width: 250px;" title="${order.diagnosis}">
                                                ${empty order.diagnosis ? '<span class="text-muted fst-italic">Chưa có chẩn đoán</span>' : order.diagnosis}
                                            </span>
                                        </td>
                                        <td>
                                            <garage:statusBadge status="${order.status}"/>
                                        </td>
                                        <td class="text-end pe-3">
                                            <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderId}"
                                               class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye me-1"></i>Xem & Thao tác
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
