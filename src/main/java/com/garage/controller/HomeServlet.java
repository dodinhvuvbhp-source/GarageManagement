package com.garage.controller;

import com.garage.dao.PartDAO;
import com.garage.dao.RepairOrderDAO;
import com.garage.dao.ServiceDAO;
import com.garage.model.RepairOrder;
import com.garage.model.ServiceItem;
import com.garage.model.SparePart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final PartDAO partDAO = new PartDAO();
    private final RepairOrderDAO orderDAO = new RepairOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tìm kiếm tra cứu nhanh đơn sửa xe theo mã phiếu hoặc biển số xe
        String searchTrack = request.getParameter("searchTrack");
        if (searchTrack != null && !searchTrack.trim().isEmpty()) {
            searchTrack = searchTrack.trim();
            for (RepairOrder ro : orderDAO.getAllOrders()) {
                if (ro.getOrderCode().equalsIgnoreCase(searchTrack) || 
                    ro.getLicensePlate().equalsIgnoreCase(searchTrack)) {
                    response.sendRedirect(request.getContextPath() + "/order-detail?id=" + ro.getOrderId());
                    return;
                }
            }
            request.setAttribute("trackError", "Không tìm thấy phiếu sửa chữa nào với mã hoặc biển số: " + searchTrack);
        }

        // Lấy danh sách dịch vụ nổi bật
        List<ServiceItem> featuredServices = serviceDAO.getAllServices(true);
        if (featuredServices.size() > 6) {
            featuredServices = featuredServices.subList(0, 6);
        }

        // Lấy danh sách phụ tùng tiêu biểu
        List<SparePart> featuredParts = partDAO.getAllParts(true);
        if (featuredParts.size() > 8) {
            featuredParts = featuredParts.subList(0, 8);
        }

        request.setAttribute("featuredServices", featuredServices);
        request.setAttribute("featuredParts", featuredParts);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
