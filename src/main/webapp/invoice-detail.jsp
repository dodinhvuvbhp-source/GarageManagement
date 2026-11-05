<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Chi Tiết Hóa Đơn ${invoice.invoiceCode} - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <a href="${pageContext.request.contextPath}/invoices" class="btn btn-outline-secondary btn-sm mb-2">
                <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách hóa đơn
            </a>
            <h2 class="fw-bold mb-0">Hóa Đơn Thanh Toán <span class="text-primary">#${invoice.invoiceCode}</span></h2>
        </div>
        <div>
            <button onclick="window.print()" class="btn btn-outline-dark">
                <i class="bi bi-printer me-1"></i>In hóa đơn
            </button>
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

    <!-- Printable Invoice Template -->
    <div class="card border-0 shadow-sm p-4 p-md-5 bg-white">
        <!-- Header invoice -->
        <div class="row pb-4 mb-4 border-bottom">
            <div class="col-sm-6">
                <h3 class="fw-bold text-primary mb-1">
                    <i class="bi bi-wrench-adjustable-circle me-1 text-warning"></i>AutoCare GARAGE
                </h3>
                <p class="text-muted mb-1 small"><i class="bi bi-geo-alt me-1"></i>Khu Công Nghệ Cao Hòa Lạc, Thạch Thất, Hà Nội</p>
                <p class="text-muted mb-1 small"><i class="bi bi-telephone me-1"></i>Hotline: 0988.123.456 - CSKH: (024) 7300.1866</p>
                <p class="text-muted mb-0 small"><i class="bi bi-envelope me-1"></i>Email: contact@autocaregarage.vn</p>
            </div>
            <div class="col-sm-6 text-sm-end mt-3 mt-sm-0">
                <h4 class="text-uppercase fw-bold text-secondary mb-1">HÓA ĐƠN DỊCH VỤ</h4>
                <div class="fs-5 fw-bold text-dark">${invoice.invoiceCode}</div>
                <div class="text-muted small">Ngày lập: <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                <div class="mt-2">
                    <garage:statusBadge status="${invoice.status}"/>
                </div>
            </div>
        </div>

        <!-- Customer & Order Information -->
        <div class="row mb-4">
            <div class="col-sm-6">
                <h6 class="fw-bold text-uppercase text-secondary small">THÔNG TIN KHÁCH HÀNG:</h6>
                <div class="fw-bold fs-6">${order.customerName}</div>
                <div>Số điện thoại: <strong>${order.customerPhone}</strong></div>
                <div class="text-muted small">Địa chỉ: ${order.customerAddress != null ? order.customerAddress : 'Tại xưởng'}</div>
            </div>
            <div class="col-sm-6 text-sm-end mt-3 mt-sm-0">
                <h6 class="fw-bold text-uppercase text-secondary small">THÔNG TIN PHƯƠNG TIỆN:</h6>
                <div class="fw-bold fs-6 text-primary">${order.licensePlate}</div>
                <div>Dòng xe: <strong>${order.vehicleModel}</strong> (${order.vehicleBrand})</div>
                <div class="text-muted small">Phiếu sửa chữa: <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderId}">#${order.orderCode}</a></div>
            </div>
        </div>

        <!-- Services table -->
        <h6 class="fw-bold text-primary mb-2"><i class="bi bi-tools me-1"></i>1. TIỀN CÔNG DỊCH VỤ & BẢO DƯỠNG</h6>
        <div class="table-responsive mb-4">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width: 50px;" class="text-center">STT</th>
                        <th>Hạng mục dịch vụ</th>
                        <th class="text-center" style="width: 80px;">Số lượng</th>
                        <th class="text-end" style="width: 150px;">Đơn giá</th>
                        <th class="text-end" style="width: 170px;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${orderServices}" varStatus="loop">
                        <tr>
                            <td class="text-center">${loop.index + 1}</td>
                            <td>${s.serviceName}</td>
                            <td class="text-center">${s.quantity}</td>
                            <td class="text-end"><garage:formatCurrency value="${s.price}"/></td>
                            <td class="text-end fw-semibold"><garage:formatCurrency value="${s.subtotal}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orderServices}">
                        <tr>
                            <td colspan="5" class="text-center text-muted fst-italic">Không có chi phí dịch vụ</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Spare parts table -->
        <h6 class="fw-bold text-success mb-2"><i class="bi bi-box-seam me-1"></i>2. PHỤ TÙNG THAY THẾ</h6>
        <div class="table-responsive mb-4">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width: 50px;" class="text-center">STT</th>
                        <th>Tên phụ tùng chính hãng</th>
                        <th class="text-center" style="width: 80px;">Số lượng</th>
                        <th class="text-end" style="width: 150px;">Đơn giá</th>
                        <th class="text-end" style="width: 170px;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${orderParts}" varStatus="loop">
                        <tr>
                            <td class="text-center">${loop.index + 1}</td>
                            <td>${p.partName} <small class="text-muted">(${p.partCode})</small></td>
                            <td class="text-center">${p.quantity}</td>
                            <td class="text-end"><garage:formatCurrency value="${p.price}"/></td>
                            <td class="text-end fw-semibold"><garage:formatCurrency value="${p.subtotal}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orderParts}">
                        <tr>
                            <td colspan="5" class="text-center text-muted fst-italic">Không sử dụng phụ tùng thay thế</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Summary & Totals -->
        <div class="row justify-content-end">
            <div class="col-md-6 col-lg-5">
                <table class="table table-borderless">
                    <tr>
                        <td class="text-muted">Tổng tiền dịch vụ:</td>
                        <td class="text-end fw-semibold"><garage:formatCurrency value="${order.serviceAmount}"/></td>
                    </tr>
                    <tr>
                        <td class="text-muted">Tổng tiền phụ tùng:</td>
                        <td class="text-end fw-semibold"><garage:formatCurrency value="${order.partAmount}"/></td>
                    </tr>
                    <tr class="border-top border-dark fs-5">
                        <td class="fw-bold text-danger">TỔNG CỘNG PHẢI TRẢ:</td>
                        <td class="text-end fw-bold text-danger">
                            <garage:formatCurrency value="${invoice.totalAmount}"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Payment Actions -->
        <c:if test="${invoice.status == 'UNPAID'}">
            <div class="card bg-light border-0 p-3 mt-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-credit-card me-2 text-primary"></i>Chọn phương thức thanh toán</h5>
                <div class="d-flex flex-wrap gap-2">
                    <!-- Nút thanh toán Sandbox VNPay -->
                    <form action="${pageContext.request.contextPath}/vnpay-payment" method="post" class="d-inline">
                        <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                        <button type="submit" class="btn btn-danger btn-lg shadow-sm fw-bold">
                            <i class="bi bi-qr-code me-2"></i>Thanh toán Online qua VNPay Sandbox
                        </button>
                    </form>

                    <!-- Staff/Admin confirm cash payment -->
                    <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                        <form action="${pageContext.request.contextPath}/invoices" method="post" class="d-inline">
                            <input type="hidden" name="action" value="payCash">
                            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                            <button type="submit" class="btn btn-success btn-lg" onclick="return confirm('Xác nhận khách đã thanh toán đủ tiền mặt tại quầy?')">
                                <i class="bi bi-cash-stack me-2"></i>Xác nhận Thu Tiền Mặt Tại Quầy
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
