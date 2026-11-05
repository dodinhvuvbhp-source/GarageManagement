package com.garage.controller;

import com.garage.dao.InvoiceDAO;
import com.garage.dao.RepairOrderDAO;
import com.garage.model.Invoice;
import com.garage.model.RepairOrder;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoices", "/invoice-detail"})
public class InvoiceServlet extends HttpServlet {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final RepairOrderDAO orderDAO = new RepairOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/invoice-detail".equals(path) || "detail".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/invoices");
                return;
            }

            try {
                int invoiceId = Integer.parseInt(idStr);
                Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
                if (invoice == null) {
                    response.sendRedirect(request.getContextPath() + "/invoices?error=NotFound");
                    return;
                }

                RepairOrder order = orderDAO.getOrderById(invoice.getOrderId());
                request.setAttribute("invoice", invoice);
                request.setAttribute("order", order);
                if (order != null) {
                    request.setAttribute("orderServices", order.getServices());
                    request.setAttribute("orderParts", order.getParts());
                }
                request.getRequestDispatcher("/invoice-detail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/invoices");
            }

        } else {
            // Danh sách hóa đơn
            List<Invoice> invoices;
            if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2) {
                invoices = invoiceDAO.getAllInvoices();
            } else {
                invoices = invoiceDAO.getInvoicesByCustomer(currentUser.getUserId());
            }

            request.setAttribute("invoices", invoices);
            request.getRequestDispatcher("/invoices.jsp").forward(request, response);
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
        if ("payCash".equals(action)) {
            // Xác nhận thu tiền mặt trực tiếp tại quầy (dành cho Thu ngân / Admin)
            if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2) {
                int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
                invoiceDAO.updatePaymentStatus(invoiceId, "PAID", "CASH", new Timestamp(System.currentTimeMillis()));
                request.getSession().setAttribute("flashSuccess", "Đã xác nhận thu tiền mặt và hoàn tất hóa đơn!");
                response.sendRedirect(request.getContextPath() + "/invoice-detail?id=" + invoiceId);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/invoices");
    }
}
