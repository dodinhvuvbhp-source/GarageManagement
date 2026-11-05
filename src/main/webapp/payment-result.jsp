<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Kết Quả Thanh Toán VNPay - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card border-0 shadow-lg text-center p-4 p-md-5">
                <c:choose>
                    <c:when test="${success}">
                        <div class="mb-4">
                            <span class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-circle" style="width: 80px; height: 80px;">
                                <i class="bi bi-check-circle-fill fs-1"></i>
                            </span>
                        </div>
                        <h3 class="fw-bold text-success mb-2">Thanh Toán Trực Tuyến Thành Công!</h3>
                        <p class="text-muted mb-4">${message}</p>

                        <div class="card bg-light border-0 p-3 mb-4 text-start">
                            <div class="d-flex justify-content-between py-1 border-bottom">
                                <span class="text-muted">Mã giao dịch VNPay:</span>
                                <strong>${transactionNo}</strong>
                            </div>
                            <div class="d-flex justify-content-between py-1 border-bottom">
                                <span class="text-muted">Mã hóa đơn:</span>
                                <strong>${invoiceCode}</strong>
                            </div>
                            <div class="d-flex justify-content-between py-1">
                                <span class="text-muted">Số tiền thanh toán:</span>
                                <strong class="text-danger fs-5"><garage:formatCurrency value="${amount}"/></strong>
                            </div>
                        </div>

                        <div class="d-flex gap-2 justify-content-center">
                            <a href="${pageContext.request.contextPath}/invoices?action=detail&id=${invoiceId}" class="btn btn-primary px-4 fw-semibold">
                                <i class="bi bi-receipt me-1"></i>Xem lại hóa đơn
                            </a>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">
                                <i class="bi bi-house me-1"></i>Về trang chủ
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="mb-4">
                            <span class="d-inline-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-circle" style="width: 80px; height: 80px;">
                                <i class="bi bi-x-circle-fill fs-1"></i>
                            </span>
                        </div>
                        <h3 class="fw-bold text-danger mb-2">Giao Dịch Không Thành Công</h3>
                        <p class="text-muted mb-4">${message}</p>

                        <div class="alert alert-warning text-start small mb-4">
                            <i class="bi bi-info-circle me-1"></i>Giao dịch đã bị hủy hoặc có lỗi xảy ra trong quá trình xử lý qua cổng thanh toán VNPay Sandbox. Quý khách vui lòng thử lại hoặc liên hệ thu ngân.
                        </div>

                        <div class="d-flex gap-2 justify-content-center">
                            <a href="${pageContext.request.contextPath}/invoices?action=detail&id=${invoiceId}" class="btn btn-danger px-4 fw-semibold">
                                <i class="bi bi-arrow-repeat me-1"></i>Thử thanh toán lại
                            </a>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">
                                <i class="bi bi-house me-1"></i>Về trang chủ
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
