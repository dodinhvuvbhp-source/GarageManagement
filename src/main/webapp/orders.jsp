<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Danh Sách Phiếu Sửa Chữa - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1"><i class="bi bi-card-checklist text-primary me-2"></i>Danh Sách Phiếu Sửa Chữa</h2>
                <p class="text-muted mb-0">Theo dõi quy trình tiếp nhận, tiến độ sửa chữa và lịch sử phương tiện</p>
            </div>
            <a href="${pageContext.request.contextPath}/order-create" class="btn btn-warning fw-bold text-dark">
                <i class="bi bi-plus-circle me-1"></i>Tạo Phiếu Tiếp Nhận Mới
            </a>
        </div>

        <!-- Filter Status Tabs -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body p-2">
                <ul class="nav nav-pills nav-fill">
                    <li class="nav-item">
                        <a class="nav-link ${empty currentStatus || currentStatus == 'ALL' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders?status=ALL">
                            Tất cả
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentStatus == 'PENDING' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders?status=PENDING">
                            <i class="bi bi-clock me-1"></i>Chờ tiếp nhận
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentStatus == 'IN_PROGRESS' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders?status=IN_PROGRESS">
                            <i class="bi bi-tools me-1"></i>Đang sửa chữa
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentStatus == 'COMPLETED' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders?status=COMPLETED">
                            <i class="bi bi-check2-circle me-1"></i>Đã sửa xong
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentStatus == 'PAID' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders?status=PAID">
                            <i class="bi bi-cash-coin me-1"></i>Đã thanh toán
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Bảng danh sách phiếu -->
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3">Mã phiếu</th>
                                <th>Phương tiện</th>
                                <th>Khách hàng</th>
                                <th>Kỹ thuật viên</th>
                                <th>Ngày tiếp nhận</th>
                                <th>Trạng thái</th>
                                <th>Tổng tiền</th>
                                <th class="text-end pe-3">Chi tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="ro">
                                <tr>
                                    <td class="ps-3 fw-bold">
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${ro.orderId}" class="text-decoration-none">
                                            <code>${ro.orderCode}</code>
                                        </a>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${ro.licensePlate}</div>
                                        <small class="text-muted">${ro.vehicleInfo}</small>
                                    </td>
                                    <td>
                                        <div>${ro.customerName}</div>
                                        <small class="text-muted">${ro.customerPhone}</small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ro.technicianName != null}">
                                                <span class="badge bg-light text-dark border">
                                                    <i class="bi bi-person-gear me-1"></i>${ro.technicianName}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small fst-italic">Chưa phân công</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${ro.receiveDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <!-- Sử dụng Custom Tag StatusBadgeTag -->
                                        <garage:statusBadge status="${ro.status}" />
                                    </td>
                                    <td class="fw-bold text-danger">
                                        <!-- Sử dụng Custom Tag CurrencyFormatTag -->
                                        <garage:currency value="${ro.totalAmount}" />
                                    </td>
                                    <td class="text-end pe-3">
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${ro.orderId}" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i> Xem phiếu
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox display-4 d-block mb-2 text-secondary"></i>
                                        Không tìm thấy phiếu sửa chữa nào trong danh mục này.
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

<%@ include file="/common/footer.jsp" %>
