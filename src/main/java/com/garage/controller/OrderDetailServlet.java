package com.garage.controller;

import com.garage.dao.*;
import com.garage.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/order-detail"})
public class OrderDetailServlet extends HttpServlet {

    private final RepairOrderDAO orderDAO = new RepairOrderDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final PartDAO partDAO = new PartDAO();
    private final UserDAO userDAO = new UserDAO();
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            RepairOrder order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/orders?error=OrderNotFound");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("allServices", serviceDAO.getAllServices(true));
            request.setAttribute("allParts", partDAO.getAllParts(true));
            request.setAttribute("technicians", userDAO.getUsersByRole(3));

            // Kiểm tra xem đã có hóa đơn cho đơn này chưa
            Invoice invoice = invoiceDAO.getInvoiceByOrderId(orderId);
            request.setAttribute("invoice", invoice);

            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        if ("addService".equals(action)) {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            ServiceItem s = serviceDAO.getServiceById(serviceId);
            if (s != null) {
                orderDAO.addServiceToOrder(orderId, serviceId, s.getPrice(), "");
                request.getSession().setAttribute("flashSuccess", "Đã thêm dịch vụ " + s.getServiceName() + " vào phiếu!");
            }

        } else if ("removeService".equals(action)) {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            orderDAO.removeServiceFromOrder(detailId, orderId);
            request.getSession().setAttribute("flashSuccess", "Đã xóa dịch vụ khỏi phiếu!");

        } else if ("addPart".equals(action)) {
            int partId = Integer.parseInt(request.getParameter("partId"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            SparePart p = partDAO.getPartById(partId);
            if (p != null) {
                if (p.getStockQuantity() < qty) {
                    request.getSession().setAttribute("flashError", "Phụ tùng " + p.getPartName() + " chỉ còn tồn " + p.getStockQuantity() + " " + p.getUnit() + ", không đủ số lượng!");
                } else {
                    orderDAO.addPartToOrder(orderId, partId, qty, p.getPrice());
                    request.getSession().setAttribute("flashSuccess", "Đã thêm phụ tùng " + p.getPartName() + " (x" + qty + ") vào phiếu!");
                }
            }

        } else if ("removePart".equals(action)) {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            int partId = Integer.parseInt(request.getParameter("partId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            orderDAO.removePartFromOrder(detailId, orderId, partId, quantity);
            request.getSession().setAttribute("flashSuccess", "Đã hủy phụ tùng và hoàn lại kho!");

        } else if ("assignTech".equals(action)) {
            int techId = Integer.parseInt(request.getParameter("technicianId"));
            orderDAO.assignTechnician(orderId, techId);
            request.getSession().setAttribute("flashSuccess", "Phân công kỹ thuật viên thành công!");

        } else if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("status");
            orderDAO.updateStatus(orderId, newStatus);
            if ("COMPLETED".equals(newStatus)) {
                // Tự động tạo hoặc cập nhật hóa đơn thanh toán
                invoiceDAO.getOrCreateInvoiceForOrder(orderId);
            }
            request.getSession().setAttribute("flashSuccess", "Cập nhật trạng thái phiếu thành công: " + newStatus);

        } else if ("updateDiagnosis".equals(action)) {
            String notes = request.getParameter("diagnosisNotes");
            orderDAO.updateDiagnosis(orderId, notes);
            request.getSession().setAttribute("flashSuccess", "Đã lưu kết quả chẩn đoán kỹ thuật!");
        }

        response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
    }
}
