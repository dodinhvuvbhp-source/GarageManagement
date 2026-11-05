package com.garage.filter;

import com.garage.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {
        "/dashboard", "/dashboard/*",
        "/technician-tasks", "/technician/*"
})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        int roleId = currentUser.getRoleId();

        // 1. Dashboard: CHỈ RIÊNG Admin (roleId == 1) mới được xem Báo cáo doanh thu & Thống kê
        if (path.startsWith("/dashboard")) {
            if (roleId != 1) {
                request.setAttribute("errorMessage", "Bạn không có quyền truy cập trang Quản trị & Thống kê doanh thu (Chức năng dành riêng cho Quản trị viên/Chủ cửa hàng)!");
                request.getRequestDispatcher("/error-403.jsp").forward(request, response);
                return;
            }
        }

        // 2. Kỹ thuật viên (technician-tasks): Chỉ Thợ sửa (3), Staff (2), Admin (1)
        if (path.startsWith("/technician-tasks")) {
            if (roleId != 1 && roleId != 2 && roleId != 3) {
                request.setAttribute("errorMessage", "Chức năng này dành riêng cho Kỹ thuật viên & Quản lý!");
                request.getRequestDispatcher("/error-403.jsp").forward(request, response);
                return;
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
