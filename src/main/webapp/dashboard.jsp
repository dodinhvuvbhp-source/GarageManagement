<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Báo Cáo Thống Kê - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-speedometer2 text-primary me-2"></i>Bảng Điều Khiển & Thống Kê</h2>
            <p class="text-muted mb-0">Tổng quan chỉ số kinh doanh, phụ tùng sắp hết và đơn sửa xe gần nhất</p>
        </div>
        <span class="badge bg-danger px-3 py-2 fs-6 shadow-sm">
            <i class="bi bi-shield-lock me-1"></i>Khu vực Quản trị (Admin)
        </span>
    </div>

    <!-- 4 KPI Cards Nổi Bật, Rõ Ràng & Sắc Nét -->
    <div class="row g-3 mb-4">
        <!-- 1. TỔNG DOANH THU -->
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow rounded-4 bg-primary text-white h-100 overflow-hidden position-relative">
                <div class="card-body p-4 position-relative z-1">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-uppercase fw-bold text-white tracking-wider" style="font-size: 0.85rem; letter-spacing: 0.05em; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">
                                TỔNG DOANH THU
                            </span>
                            <h2 class="fw-extrabold text-white my-2 display-6 fw-bold" style="text-shadow: 0 2px 4px rgba(0,0,0,0.3);">
                                <garage:formatCurrency value="${totalRevenue != null ? totalRevenue : (stats.totalRevenue != null ? stats.totalRevenue : 0)}"/>
                            </h2>
                            <div class="fw-semibold text-white d-flex align-items-center" style="font-size: 0.85rem; opacity: 0.95;">
                                <i class="bi bi-check-circle-fill me-1 text-warning"></i>Hóa đơn đã thanh toán
                            </div>
                        </div>
                        <div class="bg-white bg-opacity-25 rounded-circle p-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                            <i class="bi bi-cash-stack fs-2 text-white"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. PHIẾU SỬA CHỮA -->
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow rounded-4 bg-success text-white h-100 overflow-hidden position-relative">
                <div class="card-body p-4 position-relative z-1">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-uppercase fw-bold text-white tracking-wider" style="font-size: 0.85rem; letter-spacing: 0.05em; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">
                                PHIẾU SỬA CHỮA
                            </span>
                            <h2 class="fw-extrabold text-white my-2 display-6 fw-bold" style="text-shadow: 0 2px 4px rgba(0,0,0,0.3);">
                                ${totalOrders != null ? totalOrders : (stats.totalOrders != null ? stats.totalOrders : 0)}
                            </h2>
                            <div class="fw-semibold text-white d-flex align-items-center" style="font-size: 0.85rem; opacity: 0.95;">
                                <i class="bi bi-tools me-1 text-warning"></i>Lượt tiếp nhận tại xưởng
                            </div>
                        </div>
                        <div class="bg-white bg-opacity-25 rounded-circle p-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                            <i class="bi bi-card-checklist fs-2 text-white"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. ĐANG SỬA CHỮA -->
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow rounded-4 bg-warning text-dark h-100 overflow-hidden position-relative">
                <div class="card-body p-4 position-relative z-1">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-uppercase fw-bold text-dark tracking-wider" style="font-size: 0.85rem; letter-spacing: 0.05em;">
                                ĐANG SỬA CHỮA
                            </span>
                            <h2 class="fw-extrabold text-dark my-2 display-6 fw-bold">
                                ${activeOrders != null ? activeOrders : (stats.inProgressOrders != null ? stats.inProgressOrders : 0)}
                            </h2>
                            <div class="fw-bold text-dark d-flex align-items-center" style="font-size: 0.85rem;">
                                <i class="bi bi-gear-fill me-1 text-danger"></i>Xe đang trong xưởng
                            </div>
                        </div>
                        <div class="bg-dark bg-opacity-10 rounded-circle p-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                            <i class="bi bi-wrench-adjustable fs-2 text-dark"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. KHÁCH HÀNG -->
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow rounded-4 bg-info text-white h-100 overflow-hidden position-relative" style="background-color: #0284c7 !important;">
                <div class="card-body p-4 position-relative z-1">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-uppercase fw-bold text-white tracking-wider" style="font-size: 0.85rem; letter-spacing: 0.05em; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">
                                KHÁCH HÀNG
                            </span>
                            <h2 class="fw-extrabold text-white my-2 display-6 fw-bold" style="text-shadow: 0 2px 4px rgba(0,0,0,0.3);">
                                ${totalCustomers != null ? totalCustomers : (stats.totalCustomers != null ? stats.totalCustomers : 0)}
                            </h2>
                            <div class="fw-semibold text-white d-flex align-items-center" style="font-size: 0.85rem; opacity: 0.95;">
                                <i class="bi bi-person-check-fill me-1 text-warning"></i>Tài khoản khách hàng
                            </div>
                        </div>
                        <div class="bg-white bg-opacity-25 rounded-circle p-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                            <i class="bi bi-people-fill fs-2 text-white"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hàng nội dung chi tiết -->
    <div class="row g-4">
        <!-- Recent Orders -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-clock-history me-2 text-primary"></i>Phiếu Sửa Chữa Mới Nhất</h5>
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-sm btn-outline-primary fw-bold">Xem tất cả</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Mã phiếu</th>
                                    <th>Khách hàng</th>
                                    <th>Biển số xe</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end pe-3">Tổng tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ro" items="${recentOrders}">
                                    <tr>
                                        <td class="ps-3 fw-bold">
                                            <a href="${pageContext.request.contextPath}/order-detail?id=${ro.orderId}" class="text-decoration-none fw-bold">
                                                ${ro.orderCode}
                                            </a>
                                        </td>
                                        <td>${ro.customerName}</td>
                                        <td><span class="badge bg-light text-dark border">${ro.licensePlate}</span></td>
                                        <td><garage:statusBadge status="${ro.status}"/></td>
                                        <td class="text-end pe-3 fw-bold text-danger">
                                            <garage:formatCurrency value="${ro.totalAmount}"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentOrders}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted">Chưa có phiếu sửa chữa nào</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tình Trạng Tồn Kho Phụ Tùng -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <c:choose>
                        <c:when test="${not empty lowStockParts}">
                            <h5 class="mb-0 fw-bold text-danger">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>Cảnh Báo Sắp Hết (≤ 5)
                            </h5>
                        </c:when>
                        <c:otherwise>
                            <h5 class="mb-0 fw-bold text-success">
                                <i class="bi bi-box-seam me-2"></i>Tình Trạng Kho Hàng
                            </h5>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/parts" class="btn btn-sm btn-outline-secondary fw-bold">Kho hàng</a>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <c:choose>
                            <c:when test="${empty lowStockParts}">
                                <li class="list-group-item text-center py-5 text-muted">
                                    <div class="bg-success-subtle text-success rounded-circle d-inline-flex p-3 mb-3">
                                        <i class="bi bi-shield-check fs-1"></i>
                                    </div>
                                    <h6 class="fw-bold text-success mb-1">Kho Hàng Ổn Định</h6>
                                    <p class="small text-muted mb-0">Tất cả phụ tùng trong kho đều có số lượng an toàn (&gt; 5 món)!</p>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="part" items="${lowStockParts}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                        <div>
                                            <div class="fw-bold text-dark">${part.partName}</div>
                                            <small class="text-muted">Mã: <code>${part.partCode}</code> - ${part.category}</small>
                                        </div>
                                        <span class="badge bg-danger fs-6 px-3 py-2 rounded-pill fw-bold">
                                            Còn: ${part.stockQuantity}
                                        </span>
                                    </li>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
