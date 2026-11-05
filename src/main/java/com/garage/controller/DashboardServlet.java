package com.garage.controller;

import com.garage.dao.DashboardDAO;
import com.garage.model.RepairOrder;
import com.garage.model.SparePart;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, Object> stats = dashboardDAO.getDashboardStats();
        List<RepairOrder> recentOrders = dashboardDAO.getRecentOrders(6);
        List<SparePart> lowStockParts = dashboardDAO.getLowStockParts(5);

        request.setAttribute("stats", stats);
        request.setAttribute("totalRevenue", stats.get("totalRevenue"));
        request.setAttribute("totalOrders", stats.get("totalOrders"));
        request.setAttribute("activeOrders", stats.get("inProgressOrders"));
        request.setAttribute("totalCustomers", stats.get("totalCustomers"));
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("lowStockParts", lowStockParts);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}

