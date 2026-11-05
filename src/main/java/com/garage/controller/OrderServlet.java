package com.garage.controller;

import com.garage.dao.RepairOrderDAO;
import com.garage.dao.UserDAO;
import com.garage.model.RepairOrder;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders"})
public class OrderServlet extends HttpServlet {

    private final RepairOrderDAO orderDAO = new RepairOrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String statusFilter = request.getParameter("status");
        List<RepairOrder> orders;

        if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2) {
            orders = orderDAO.getAllOrders();
            // Lấy danh sách kỹ thuật viên để gán
            request.setAttribute("technicians", userDAO.getUsersByRole(3));
        } else if (currentUser.getRoleId() == 3) {
            orders = orderDAO.getOrdersByTechnician(currentUser.getUserId());
        } else {
            orders = orderDAO.getOrdersByCustomer(currentUser.getUserId());
        }

        // Lọc theo trạng thái nếu có
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            List<RepairOrder> filtered = new ArrayList<>();
            for (RepairOrder ro : orders) {
                if (ro.getStatus().equalsIgnoreCase(statusFilter)) {
                    filtered.add(ro);
                }
            }
            orders = filtered;
        }

        request.setAttribute("orders", orders);
        request.setAttribute("currentStatus", statusFilter);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }
}
