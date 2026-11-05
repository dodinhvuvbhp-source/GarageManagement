package com.garage.filter;

import com.garage.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/profile", "/profile/*",
        "/vehicles", "/vehicles/*",
        "/orders", "/order/*", "/order-create", "/order-detail",
        "/invoices", "/invoice-detail",
        "/technician-tasks", "/technician/*",
        "/dashboard", "/dashboard/*",
        "/payment/*"
})
public class AuthenticationFilter implements Filter {

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
            String targetUri = request.getRequestURI();
            String query = request.getQueryString();
            if (query != null) {
                targetUri += "?" + query;
            }
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("redirectAfterLogin", targetUri);
            session.setAttribute("authError", "Vui lòng đăng nhập để tiếp tục sử dụng tính năng này!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
