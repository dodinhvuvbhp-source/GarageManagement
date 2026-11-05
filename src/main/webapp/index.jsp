<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Cửa Hàng Sửa Chữa Xe - Trung Tâm Dịch Vụ & Bảo Dưỡng Uy Tín" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main>
    <!-- Hero Banner -->
    <section class="hero-section text-center text-lg-start">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <span class="badge bg-warning text-dark px-3 py-2 mb-3 fw-bold">
                        <i class="bi bi-shield-check me-1"></i>GARAGE TIÊU CHUẨN 5 SAO
                    </span>
                    <h1 class="display-4 fw-bold mb-3">
                        Dịch Vụ Sửa Chữa & Chăm Sóc Xe Chuyên Nghiệp
                    </h1>
                    <p class="lead mb-4">
                        Kiểm tra chẩn đoán chính xác bằng thiết bị hiện đại, đội ngũ kỹ thuật viên giàu kinh nghiệm, 100% phụ tùng chính hãng, quy trình minh bạch từ tiếp nhận đến thanh toán online.
                    </p>
                    <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                        <a href="${pageContext.request.contextPath}/order-create" class="btn btn-warning btn-lg fw-bold px-4 text-dark shadow-sm">
                            <i class="bi bi-calendar-check me-2"></i>Đặt Lịch Tiếp Nhận Ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-primary btn-lg px-4">
                            <i class="bi bi-card-list me-2"></i>Xem Bảng Giá Dịch Vụ
                        </a>
                    </div>
                </div>

                <!-- Box tra cứu nhanh tiến độ sửa xe -->
                <div class="col-lg-5 mt-5 mt-lg-0">
                    <div class="card shadow border-0 p-4 tra-cuu-card">
                        <div class="card-body">
                            <h4 class="card-title fw-bold text-primary mb-3">
                                <i class="bi bi-search me-2"></i>Tra Cứu Tiến Độ Sửa Xe
                            </h4>
                            <p class="text-muted small">
                                Nhập mã phiếu sửa chữa (ví dụ: <code>RO-202611-001</code>) hoặc biển số xe (ví dụ: <code>30F-123.45</code>) theo dõi:
                            </p>
                            <form action="${pageContext.request.contextPath}/home" method="get">
                                <div class="input-group mb-3">
                                    <span class="input-group-text"><i class="bi bi-upc-scan"></i></span>
                                    <input type="text" name="searchTrack" class="form-control form-control-lg"
                                           placeholder="Biển số hoặc Mã phiếu..." required>
                                    <button class="btn btn-primary px-4 fw-bold" type="submit">
                                        Tìm kiếm
                                    </button>
                                </div>
                            </form>
                            <c:if test="${trackError != null}">
                                <div class="alert alert-danger py-2 small mb-0">
                                    <i class="bi bi-exclamation-triangle me-1"></i>${trackError}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Cam kết dịch vụ & Ưu điểm -->
    <section class="py-5 cam-ket-section border-bottom">
        <div class="container">
            <div class="row g-4 text-center">
                <div class="col-md-3">
                    <div class="feature-item p-3 rounded-3 h-100">
                        <div class="feature-icon-wrapper mb-3 mx-auto d-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle" style="width: 72px; height: 72px;">
                            <i class="bi bi-wrench-adjustable fs-1"></i>
                        </div>
                        <h6 class="fw-bold mb-2">Thợ Tay Nghề Cao</h6>
                        <p class="text-muted small mb-0">Hơn 10 năm kinh nghiệm đại tu ô tô và xe máy cao cấp.</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-item p-3 rounded-3 h-100">
                        <div class="feature-icon-wrapper mb-3 mx-auto d-flex align-items-center justify-content-center bg-success-subtle text-success rounded-circle" style="width: 72px; height: 72px;">
                            <i class="bi bi-shield-fill-check fs-1"></i>
                        </div>
                        <h6 class="fw-bold mb-2">Phụ Tùng Chính Hãng</h6>
                        <p class="text-muted small mb-0">Cam kết 100% linh kiện có nguồn gốc, bảo hành từ 6-12 tháng.</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-item p-3 rounded-3 h-100">
                        <div class="feature-icon-wrapper mb-3 mx-auto d-flex align-items-center justify-content-center bg-info-subtle text-info rounded-circle" style="width: 72px; height: 72px;">
                            <i class="bi bi-file-earmark-text-fill fs-1"></i>
                        </div>
                        <h6 class="fw-bold mb-2">Báo Giá Rõ Ràng</h6>
                        <p class="text-muted small mb-0">Khách duyệt báo giá chi tiết trước khi kỹ thuật viên bắt đầu sửa.</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-item p-3 rounded-3 h-100">
                        <div class="feature-icon-wrapper mb-3 mx-auto d-flex align-items-center justify-content-center bg-warning-subtle text-warning rounded-circle" style="width: 72px; height: 72px;">
                            <i class="bi bi-credit-card-2-front-fill fs-1"></i>
                        </div>
                        <h6 class="fw-bold mb-2">Thanh Toán Linh Hoạt</h6>
                        <p class="text-muted small mb-0">Hỗ trợ tiền mặt, chuyển khoản và cổng VNPay Sandbox an toàn.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Dịch vụ tiêu biểu -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-gear-wide-connected text-primary me-2"></i>Dịch Vụ Sửa Chữa Nổi Bật</h2>
                    <p class="text-muted mb-0">Các gói dịch vụ chăm sóc, bảo dưỡng định kỳ được khách hàng tin chọn</p>
                </div>
                <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-primary fw-medium">
                    Xem tất cả dịch vụ <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach items="${featuredServices}" var="s">
                    <div class="col-lg-4 col-md-6">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title fw-bold">${s.serviceName}</h5>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                        <i class="bi bi-stopwatch me-1"></i>${s.estimatedDuration} phút
                                    </span>
                                </div>
                                <p class="card-text text-muted small flex-grow-1">${s.description}</p>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                                    <div>
                                        <small class="text-secondary d-block">Tiền công dịch vụ</small>
                                        <span class="fs-5 fw-bold text-danger">
                                            <garage:formatCurrency value="${s.price}" />
                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/order-create" class="btn btn-primary btn-sm">
                                        <i class="bi bi-plus-circle me-1"></i>Đặt làm
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Kho Phụ Tùng -->
    <section class="py-5 kho-phu-tung-section border-top">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-box-seam text-warning me-2"></i>Linh Kiện & Phụ Tùng Sẵn Có</h2>
                    <p class="text-muted mb-0">Nhớt, má phanh, lốp xe, bugi, bình ắc quy luôn sẵn sàng tại xưởng</p>
                </div>
                <a href="${pageContext.request.contextPath}/parts" class="btn btn-outline-secondary fw-medium">
                    Vào kho phụ tùng <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach items="${featuredParts}" var="p">
                    <div class="col-lg-3 col-md-6">
                        <div class="card h-100 border-0 shadow-sm part-card position-relative overflow-hidden">
                            <!-- Visual Banner Icon cho từng loại phụ tùng -->
                            <div class="p-4 text-center bg-light border-bottom d-flex align-items-center justify-content-center" style="height: 120px;">
                                <c:choose>
                                    <c:when test="${p.category.contains('nhớt') || p.category.contains('Dầu')}">
                                        <i class="bi bi-droplet-half text-warning display-4"></i>
                                    </c:when>
                                    <c:when test="${p.category.contains('phanh')}">
                                        <i class="bi bi-disc text-danger display-4"></i>
                                    </c:when>
                                    <c:when test="${p.category.contains('quy') || p.category.contains('Ắc')}">
                                        <i class="bi bi-battery-charging text-success display-4"></i>
                                    </c:when>
                                    <c:when test="${p.category.contains('lọc') || p.category.contains('Lọc')}">
                                        <i class="bi bi-funnel text-info display-4"></i>
                                    </c:when>
                                    <c:when test="${p.category.contains('Bugi') || p.category.contains('bugi')}">
                                        <i class="bi bi-lightning-charge text-warning display-4"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-box-seam text-primary display-4"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <span class="badge bg-secondary mb-2">${p.category}</span>
                                <h6 class="card-title fw-bold mb-1 text-truncate" title="${p.partName}">${p.partName}</h6>
                                <p class="text-muted small mb-2">Mã: <code>${p.partCode}</code></p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="fw-bold text-danger fs-6">
                                        <garage:formatCurrency value="${p.price}" />
                                    </span>
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                        Còn: ${p.stockQuantity} ${p.unit}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<%@ include file="/common/footer.jsp" %>
