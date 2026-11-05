<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Quản Lý Hóa Đơn - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-receipt-cutoff text-primary me-2"></i>Danh Sách Hóa Đơn & Thanh Toán</h2>
            <p class="text-muted mb-0">Theo dõi doanh thu, tình trạng xuất hóa đơn và đối soát thanh toán trực tuyến</p>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-light text-dark border p-2 d-flex align-items-center">
                <i class="bi bi-cash-stack text-success fs-5 me-2"></i>
                <div>
                    <small class="text-muted d-block">Tổng hóa đơn</small>
                    <strong>${invoices.size()} đơn</strong>
                </div>
            </span>
        </div>
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

    <!-- Search filter bar -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/invoices" method="get" class="row g-3">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                        <input type="text" name="search" class="form-control" placeholder="Tìm theo mã hóa đơn, mã phiếu..." value="${param.search}">
                    </div>
                </div>
                <div class="col-md-4">
                    <select name="status" class="form-select">
                        <option value="">-- Tất cả trạng thái thanh toán --</option>
                        <option value="PAID" ${param.status == 'PAID' ? 'selected' : ''}>Đã thanh toán (PAID)</option>
                        <option value="UNPAID" ${param.status == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán (UNPAID)</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-fill">
                        <i class="bi bi-filter me-1"></i>Lọc danh sách
                    </button>
                    <a href="${pageContext.request.contextPath}/invoices" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">Mã hóa đơn</th>
                            <th>Phiếu sửa chữa</th>
                            <th>Khách hàng</th>
                            <th>Ngày lập</th>
                            <th class="text-end">Tổng tiền (VNĐ)</th>
                            <th class="text-center">Hình thức TT</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-end pe-3">Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty invoices}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                        Không tìm thấy hóa đơn nào trong hệ thống!
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="inv" items="${invoices}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-primary">${inv.invoiceCode}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/order-detail?id=${inv.orderId}" class="text-decoration-none fw-bold">
                                                ${inv.orderCode}
                                            </a>
                                        </td>
                                        <td>
                                            <div class="fw-bold">${inv.customerName}</div>
                                            <small class="text-muted">${inv.customerPhone}</small>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${inv.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td class="text-end fw-bold text-danger fs-6">
                                            <garage:formatCurrency value="${inv.totalAmount}"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${inv.paymentMethod == 'VNPAY'}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                        <i class="bi bi-qr-code me-1"></i>VNPay
                                                    </span>
                                                </c:when>
                                                <c:when test="${inv.paymentMethod == 'BANKING'}">
                                                    <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">
                                                        <i class="bi bi-bank me-1"></i>Chuyển khoản
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">
                                                        <i class="bi bi-cash me-1"></i>Tiền mặt
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <garage:statusBadge status="${inv.status}"/>
                                        </td>
                                        <td class="text-end pe-3">
                                            <a href="${pageContext.request.contextPath}/invoices?action=detail&id=${inv.invoiceId}"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye me-1"></i>Xem
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
