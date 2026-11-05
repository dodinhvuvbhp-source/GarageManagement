package com.garage.controller;

import com.garage.dao.RepairOrderDAO;
import com.garage.dao.UserDAO;
import com.garage.dao.VehicleDAO;
import com.garage.model.RepairOrder;
import com.garage.model.User;
import com.garage.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "OrderCreateServlet", urlPatterns = {"/order-create"})
public class OrderCreateServlet extends HttpServlet {

    private final RepairOrderDAO orderDAO = new RepairOrderDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
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

        if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2) {
            request.setAttribute("vehicles", vehicleDAO.getAllVehicles());
            request.setAttribute("customers", userDAO.getUsersByRole(4));
            request.setAttribute("technicians", userDAO.getUsersByRole(3));
        } else {
            List<Vehicle> customerVehicles = vehicleDAO.getVehiclesByCustomer(currentUser.getUserId());
            request.setAttribute("vehicles", customerVehicles);
        }

        request.getRequestDispatcher("/order-create.jsp").forward(request, response);
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

        String vehicleIdStr = request.getParameter("vehicleId");
        String problemDesc = request.getParameter("problemDescription");
        String techIdStr = request.getParameter("technicianId");
        String appointmentTimeStr = request.getParameter("appointmentTime");

        if (vehicleIdStr == null || vehicleIdStr.isEmpty() || problemDesc == null || problemDesc.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn xe và nhập mô tả tình trạng hư hỏng!");
            doGet(request, response);
            return;
        }

        int vehicleId = Integer.parseInt(vehicleIdStr);
        Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);
        if (vehicle == null) {
            request.setAttribute("error", "Xe không hợp lệ!");
            doGet(request, response);
            return;
        }

        RepairOrder order = new RepairOrder();
        order.setVehicleId(vehicleId);
        order.setCustomerId(vehicle.getCustomerId());
        order.setProblemDescription(problemDesc.trim());

        // Xử lý giờ hẹn sửa xe
        if (appointmentTimeStr != null && !appointmentTimeStr.trim().isEmpty()) {
            try {
                // Định dạng datetime-local HTML5: yyyy-MM-ddTHH:mm
                LocalDateTime ldt = LocalDateTime.parse(appointmentTimeStr.trim(), DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                order.setReceiveDate(Timestamp.valueOf(ldt));
            } catch (Exception e) {
                order.setReceiveDate(new Timestamp(System.currentTimeMillis()));
            }
        } else {
            order.setReceiveDate(new Timestamp(System.currentTimeMillis()));
        }

        if (techIdStr != null && !techIdStr.isEmpty()) {
            order.setTechnicianId(Integer.parseInt(techIdStr));
        }

        int orderId = orderDAO.createOrder(order);
        if (orderId > 0) {
            request.getSession().setAttribute("flashSuccess", "Đặt lịch hẹn sửa xe thành công!");
            response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
        } else {
            request.setAttribute("error", "Lỗi tạo phiếu sửa chữa, vui lòng thử lại!");
            doGet(request, response);
        }
    }
}
