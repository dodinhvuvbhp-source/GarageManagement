package com.garage.controller;

import com.garage.dao.UserDAO;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(username.trim(), password.trim());
        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);

            // Kiểm tra xem trước đó có yêu cầu chuyển hướng không
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
                return;
            }

            // Điều hướng theo Role
            if (user.getRoleId() == 1) {
                // Admin -> Dashboard Thống kê doanh thu
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else if (user.getRoleId() == 2) {
                // Thu ngân / Staff -> Danh sách Phiếu sửa chữa & Hóa đơn
                response.sendRedirect(request.getContextPath() + "/orders");
            } else if (user.getRoleId() == 3) {
                // Kỹ thuật viên -> Việc phụ trách sửa
                response.sendRedirect(request.getContextPath() + "/technician-tasks");
            } else {
                // Khách hàng -> Quản lý xe / đơn
                response.sendRedirect(request.getContextPath() + "/orders");
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
