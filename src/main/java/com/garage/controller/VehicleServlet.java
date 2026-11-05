package com.garage.controller;

import com.garage.dao.UserDAO;
import com.garage.dao.VehicleDAO;
import com.garage.model.User;
import com.garage.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "VehicleServlet", urlPatterns = {"/vehicles"})
public class VehicleServlet extends HttpServlet {

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

        List<Vehicle> vehicles;
        if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2) {
            vehicles = vehicleDAO.getAllVehicles();
            // Lấy danh sách khách hàng để gán khi thêm xe hộ khách
            request.setAttribute("customers", userDAO.getUsersByRole(4));
        } else {
            vehicles = vehicleDAO.getVehiclesByCustomer(currentUser.getUserId());
        }

        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
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
        if ("add".equals(action)) {
            String licensePlate = request.getParameter("licensePlate");
            String vehicleType = request.getParameter("vehicleType");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String color = request.getParameter("color");
            String yearStr = request.getParameter("manufactureYear");

            int customerId = currentUser.getUserId();
            // Nếu là Admin hoặc Staff thì có thể chọn khách hàng sở hữu
            if ((currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2) && request.getParameter("customerId") != null) {
                customerId = Integer.parseInt(request.getParameter("customerId"));
            }

            int manufactureYear = 2022;
            try {
                if (yearStr != null && !yearStr.trim().isEmpty()) {
                    manufactureYear = Integer.parseInt(yearStr.trim());
                }
            } catch (NumberFormatException ignored) {}

            Vehicle v = new Vehicle();
            v.setLicensePlate(licensePlate.trim().toUpperCase());
            v.setCustomerId(customerId);
            v.setVehicleType(vehicleType);
            v.setBrand(brand.trim());
            v.setModel(model.trim());
            v.setColor(color != null ? color.trim() : "");
            v.setManufactureYear(manufactureYear);

            if (vehicleDAO.getVehicleByLicensePlate(v.getLicensePlate()) != null) {
                request.getSession().setAttribute("flashError", "Biển số xe " + v.getLicensePlate() + " đã tồn tại trong hệ thống!");
            } else {
                vehicleDAO.addVehicle(v);
                request.getSession().setAttribute("flashSuccess", "Thêm xe " + v.getLicensePlate() + " thành công!");
            }
        } else if ("delete".equals(action)) {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            vehicleDAO.deleteVehicle(vehicleId);
            request.getSession().setAttribute("flashSuccess", "Đã xóa thông tin xe!");
        }

        response.sendRedirect(request.getContextPath() + "/vehicles");
    }
}
