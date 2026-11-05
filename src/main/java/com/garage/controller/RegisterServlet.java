package com.garage.controller;

import com.garage.dao.UserDAO;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkUsernameExists(username.trim())) {
            request.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại! Vui lòng chọn tên khác.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password.trim());
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email != null ? email.trim() : "");
        newUser.setPhone(phone.trim());
        newUser.setAddress(address != null ? address.trim() : "");

        boolean success = userDAO.registerCustomer(newUser);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/login?msg=register_success");
        } else {
            request.setAttribute("error", "Đã có lỗi xảy ra khi tạo tài khoản. Vui lòng thử lại!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
