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

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

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

        // Tải lại thông tin mới nhất từ CSDL
        User user = userDAO.getUserById(currentUser.getUserId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
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
        if ("updateInfo".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);
            currentUser.setAddress(address);

            if (userDAO.updateProfile(currentUser)) {
                session.setAttribute("currentUser", currentUser);
                request.setAttribute("successMsg", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("errorMsg", "Không thể cập nhật thông tin!");
            }
        } else if ("changePassword".equals(action)) {
            String currentPass = request.getParameter("currentPassword");
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            User dbUser = userDAO.getUserById(currentUser.getUserId());
            if (!dbUser.getPassword().equals(currentPass)) {
                request.setAttribute("errorMsg", "Mật khẩu hiện tại không đúng!");
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("errorMsg", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            } else {
                if (userDAO.changePassword(currentUser.getUserId(), newPass)) {
                    request.setAttribute("successMsg", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("errorMsg", "Đã có lỗi xảy ra khi đổi mật khẩu!");
                }
            }
        }

        request.setAttribute("user", userDAO.getUserById(currentUser.getUserId()));
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
