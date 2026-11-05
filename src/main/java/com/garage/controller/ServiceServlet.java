package com.garage.controller;

import com.garage.dao.ServiceDAO;
import com.garage.model.ServiceItem;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ServiceServlet", urlPatterns = {"/services"})
public class ServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<ServiceItem> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = serviceDAO.searchServices(keyword.trim());
        } else {
            list = serviceDAO.getAllServices(false);
        }

        request.setAttribute("services", list);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/services?error=PermissionDenied");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String name = request.getParameter("serviceName");
            String desc = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int duration = Integer.parseInt(request.getParameter("estimatedDuration"));

            ServiceItem s = new ServiceItem();
            s.setServiceName(name.trim());
            s.setDescription(desc != null ? desc.trim() : "");
            s.setPrice(price);
            s.setEstimatedDuration(duration);
            s.setActive(true);

            serviceDAO.addService(s);
            request.getSession().setAttribute("flashSuccess", "Thêm dịch vụ mới thành công!");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("serviceId"));
            String name = request.getParameter("serviceName");
            String desc = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int duration = Integer.parseInt(request.getParameter("estimatedDuration"));
            boolean active = "1".equals(request.getParameter("isActive"));

            ServiceItem s = new ServiceItem();
            s.setServiceId(id);
            s.setServiceName(name.trim());
            s.setDescription(desc != null ? desc.trim() : "");
            s.setPrice(price);
            s.setEstimatedDuration(duration);
            s.setActive(active);

            serviceDAO.updateService(s);
            request.getSession().setAttribute("flashSuccess", "Cập nhật dịch vụ thành công!");

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("serviceId"));
            serviceDAO.deleteService(id);
            request.getSession().setAttribute("flashSuccess", "Đã ngừng kích hoạt dịch vụ!");
        }

        response.sendRedirect(request.getContextPath() + "/services");
    }
}
