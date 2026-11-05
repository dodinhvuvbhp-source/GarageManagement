package com.garage.controller;

import com.garage.dao.InvoiceDAO;
import com.garage.dao.RepairOrderDAO;
import com.garage.model.RepairOrder;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TechnicianServlet", urlPatterns = {"/technician-tasks"})
public class TechnicianServlet extends HttpServlet {

    private final RepairOrderDAO orderDAO = new RepairOrderDAO();
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<RepairOrder> tasks;
        if (currentUser.getRoleId() == 3) {
            tasks = orderDAO.getOrdersByTechnician(currentUser.getUserId());
        } else {
            // Admin hoặc Staff xem toàn bộ nhiệm vụ kỹ thuật
            tasks = orderDAO.getAllOrders();
        }

        request.setAttribute("tasks", tasks);
        request.setAttribute("assignedOrders", tasks);
        request.getRequestDispatcher("/technician-tasks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String action = request.getParameter("action");

        if ("complete".equals(action)) {
            orderDAO.updateStatus(orderId, "COMPLETED");
            // Tự động tạo hóa đơn UNPAID khi thợ hoàn thành sửa chữa
            invoiceDAO.getOrCreateInvoiceForOrder(orderId);
            request.getSession().setAttribute("flashSuccess", "Đã đánh dấu hoàn tất sửa chữa phiếu #" + orderId);
        }

        response.sendRedirect(request.getContextPath() + "/technician-tasks");
    }
}
