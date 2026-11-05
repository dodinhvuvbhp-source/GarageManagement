// GarageManagement Main JavaScript

document.addEventListener('DOMContentLoaded', function () {
    // Tự động đóng thông báo flash sau 5 giây
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Xác nhận trước khi xóa
    const deleteButtons = document.querySelectorAll('.btn-delete-confirm');
    deleteButtons.forEach(function (button) {
        button.addEventListener('click', function (e) {
            const message = button.getAttribute('data-confirm') || 'Bạn có chắc chắn muốn thực hiện thao tác xóa này không?';
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });
});

// Hàm in hóa đơn
function printInvoice() {
    window.print();
}
