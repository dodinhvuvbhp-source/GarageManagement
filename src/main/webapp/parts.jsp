<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="garage" uri="/WEB-INF/tlds/garage-tags.tld" %>
<c:set var="pageTitle" value="Kho Linh Kiện & Phụ Tùng - AutoCare Garage" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <!-- Header -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h2 class="fw-bold mb-1"><i class="bi bi-box-seam text-warning me-2"></i>Kho Linh Kiện & Phụ Tùng Xe</h2>
                <p class="text-muted mb-0">Quản lý nhập xuất, tồn kho và bảng giá các phụ tùng thay thế</p>
            </div>
            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                    <button class="btn btn-warning fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#addPartModal">
                        <i class="bi bi-plus-circle me-1"></i>Thêm Phụ Tùng Mới
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Filter & Search Bar -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/parts" method="get" class="row g-2">
                    <div class="col-md-4">
                        <select name="category" class="form-select">
                            <option value="ALL">-- Tất cả danh mục --</option>
                            <option value="Dầu nhớt" ${selectedCategory == 'Dầu nhớt' ? 'selected' : ''}>Dầu nhớt</option>
                            <option value="Lọc nhớt" ${selectedCategory == 'Lọc nhớt' ? 'selected' : ''}>Lọc nhớt</option>
                            <option value="Lọc gió" ${selectedCategory == 'Lọc gió' ? 'selected' : ''}>Lọc gió</option>
                            <option value="Má phanh" ${selectedCategory == 'Má phanh' ? 'selected' : ''}>Má phanh</option>
                            <option value="Bugi" ${selectedCategory == 'Bugi' ? 'selected' : ''}>Bugi</option>
                            <option value="Ắc quy" ${selectedCategory == 'Ắc quy' ? 'selected' : ''}>Ắc quy</option>
                            <option value="Dây curoa" ${selectedCategory == 'Dây curoa' ? 'selected' : ''}>Dây curoa</option>
                            <option value="Dung dịch làm mát" ${selectedCategory == 'Dung dịch làm mát' ? 'selected' : ''}>Dung dịch làm mát</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên hoặc mã phụ tùng..."
                               value="${keyword != null ? keyword : ''}">
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-dark fw-bold">Lọc dữ liệu</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Bảng danh sách phụ tùng -->
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3">Mã linh kiện</th>
                                <th>Tên phụ tùng</th>
                                <th>Phân loại</th>
                                <th>Đơn vị</th>
                                <th>Đơn giá</th>
                                <th>Tồn kho</th>
                                <th>Bảo hành</th>
                                <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                                    <th class="text-end pe-3">Thao tác</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${parts}" var="p">
                                <tr>
                                    <td class="ps-3 fw-bold"><code>${p.partCode}</code></td>
                                    <td>
                                        <div class="fw-bold">${p.partName}</div>
                                        <c:if test="${!p.active}">
                                            <span class="badge bg-danger">Ngừng bán</span>
                                        </c:if>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${p.category}</span></td>
                                    <td>${p.unit}</td>
                                    <td class="fw-bold text-danger"><garage:currency value="${p.price}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.stockQuantity <= 5}">
                                                <span class="badge bg-danger">${p.stockQuantity} (Sắp hết)</span>
                                            </c:when>
                                            <c:when test="${p.stockQuantity <= 15}">
                                                <span class="badge bg-warning text-dark">${p.stockQuantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">${p.stockQuantity}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${p.warrantyMonths} tháng</td>
                                    <c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
                                        <td class="text-end pe-3">
                                            <button class="btn btn-sm btn-outline-primary" onclick="openRestockModal(${p.partId}, '${p.partName}', ${p.stockQuantity})">
                                                <i class="bi bi-box-arrow-in-down"></i> Nhập/Xuất kho
                                            </button>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<c:if test="${sessionScope.currentUser.roleId == 1 || sessionScope.currentUser.roleId == 2}">
<!-- Modal Thêm Phụ Tùng -->
<div class="modal fade" id="addPartModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/parts" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle text-warning me-2"></i>Thêm Phụ Tùng Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Mã phụ tùng (duy nhất) <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="partCode" placeholder="Ví dụ: PART-OIL-99" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Tên phụ tùng <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="partName" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Phân loại danh mục</label>
                            <input type="text" class="form-control" name="category" placeholder="Ví dụ: Dầu nhớt, Má phanh..." required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Đơn vị tính</label>
                            <input type="text" class="form-control" name="unit" placeholder="Cái, Bình, Bộ..." required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Đơn giá bán (VNĐ)</label>
                            <input type="number" class="form-control" name="price" min="0" step="1000" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium">Số lượng tồn kho ban đầu</label>
                            <input type="number" class="form-control" name="stockQuantity" value="10" min="0" required>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label fw-medium">Bảo hành (tháng)</label>
                            <input type="number" class="form-control" name="warrantyMonths" value="6" min="0">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-warning fw-bold text-dark">Lưu Phụ Tùng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Điều Chỉnh Tồn Kho (Nhập / Xuất) -->
<div class="modal fade" id="restockModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/parts" method="post">
                <input type="hidden" name="action" value="updateStock">
                <input type="hidden" name="partId" id="restockPartId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-arrow-repeat text-primary me-2"></i>Điều Chỉnh Tồn Kho</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-2">Phụ tùng: <strong id="restockPartName"></strong></p>
                    <p class="mb-3 text-muted">Số lượng hiện tại: <span id="restockCurrentQty" class="badge bg-secondary"></span></p>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Số lượng thay đổi (dương để nhập kho, âm để xuất kho)</label>
                        <input type="number" class="form-control" name="stockAmount" placeholder="+10 hoặc -5" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary fw-bold">Xác Nhận Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openRestockModal(id, name, qty) {
    document.getElementById('restockPartId').value = id;
    document.getElementById('restockPartName').innerText = name;
    document.getElementById('restockCurrentQty').innerText = qty;
    new bootstrap.Modal(document.getElementById('restockModal')).show();
}
</script>
</c:if>

<%@ include file="/common/footer.jsp" %>
