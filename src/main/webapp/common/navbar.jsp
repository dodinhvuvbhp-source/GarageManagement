<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <!-- Thương hiệu: CỬA HÀNG SỬA CHỮA XE -->
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-wrench-adjustable-circle text-warning fs-3 me-2"></i>
            <span><strong class="text-white">CỬA HÀNG</strong> <span class="text-warning">SỬA CHỮA XE</span></span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/services">
                        <i class="bi bi-gear-wide-connected me-1"></i>Dịch vụ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/parts">
                        <i class="bi bi-box-seam me-1"></i>Phụ tùng
                    </a>
                </li>

                <!-- Menu theo Role -->
                <c:if test="${sessionScope.currentUser != null}">
                    <!-- Admin (1): Toàn quyền gồm cả Dashboard Thống Kê & Doanh Thu -->
                    <c:if test="${sessionScope.currentUser.roleId == 1}">
                        <li class="nav-item">
                            <a class="nav-link text-info fw-bold" href="${pageContext.request.contextPath}/dashboard">
                                <i class="bi bi-speedometer2 me-1"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                                <i class="bi bi-card-checklist me-1"></i>Phiếu sửa chữa
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/vehicles">
                                <i class="bi bi-car-front me-1"></i>Quản lý Xe
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/invoices">
                                <i class="bi bi-receipt me-1"></i>Hóa đơn
                            </a>
                        </li>
                    </c:if>

                    <!-- Staff / Thu ngân (2): Tiếp nhận xe, điều phối phiếu và thu ngân/hóa đơn (KHÔNG xem Dashboard doanh thu) -->
                    <c:if test="${sessionScope.currentUser.roleId == 2}">
                        <li class="nav-item">
                            <a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/orders">
                                <i class="bi bi-card-checklist me-1"></i>Phiếu sửa chữa
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/vehicles">
                                <i class="bi bi-car-front me-1"></i>Quản lý Xe
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-success fw-bold" href="${pageContext.request.contextPath}/invoices">
                                <i class="bi bi-receipt me-1"></i>Thu ngân & Hóa đơn
                            </a>
                        </li>
                    </c:if>

                    <!-- Technician (3) -->
                    <c:if test="${sessionScope.currentUser.roleId == 3}">
                        <li class="nav-item">
                            <a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/technician-tasks">
                                <i class="bi bi-tools me-1"></i>Xe phụ trách sửa
                            </a>
                        </li>
                    </c:if>

                    <!-- Customer (4) -->
                    <c:if test="${sessionScope.currentUser.roleId == 4}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/vehicles">
                                <i class="bi bi-car-front me-1"></i>Xe của tôi
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/order-create">
                                <i class="bi bi-calendar-plus me-1"></i>Đặt lịch sửa
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                                <i class="bi bi-clock-history me-1"></i>Lịch sử sửa chữa
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/invoices">
                                <i class="bi bi-credit-card me-1"></i>Hóa đơn & Thanh toán
                            </a>
                        </li>
                    </c:if>
                </c:if>
            </ul>

            <!-- Khối người dùng bên phải -->
            <ul class="navbar-nav ms-auto align-items-center gap-2">
                <c:choose>
                    <c:when test="${sessionScope.currentUser != null}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center text-white" href="#" id="userDropdown"
                                role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-5 me-2 text-warning"></i>
                                <span>${sessionScope.currentUser.fullName}</span>
                                <span class="badge bg-light text-dark ms-2" style="font-size: 0.75rem;">
                                    ${sessionScope.currentUser.roleName}
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item me-1">
                            <a class="btn btn-outline-light btn-sm px-3" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-warning btn-sm px-3 fw-bold text-dark" href="${pageContext.request.contextPath}/register">
                                <i class="bi bi-person-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Thông báo Flash Messages từ Session -->
<c:if test="${sessionScope.flashSuccess != null}">
    <div class="container mt-3">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
    <c:remove var="flashSuccess" scope="session" />
</c:if>

<c:if test="${sessionScope.flashError != null}">
    <div class="container mt-3">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.flashError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
    <c:remove var="flashError" scope="session" />
</c:if>
