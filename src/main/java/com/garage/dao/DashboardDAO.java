package com.garage.dao;

import com.garage.context.DBContext;
import com.garage.model.RepairOrder;
import com.garage.model.SparePart;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT "
                   + "(SELECT COUNT(*) FROM RepairOrders) AS total_orders, "
                   + "(SELECT COUNT(*) FROM RepairOrders WHERE status = 'PENDING') AS pending_orders, "
                   + "(SELECT COUNT(*) FROM RepairOrders WHERE status = 'IN_PROGRESS') AS in_progress_orders, "
                   + "(SELECT COUNT(*) FROM RepairOrders WHERE status = 'COMPLETED') AS completed_orders, "
                   + "(SELECT COUNT(*) FROM RepairOrders WHERE status = 'PAID') AS paid_orders, "
                   + "(SELECT ISNULL(SUM(total_amount), 0) FROM Invoices WHERE payment_status = 'PAID') AS total_revenue, "
                   + "(SELECT COUNT(*) FROM Users WHERE role_id = 4) AS total_customers, "
                   + "(SELECT COUNT(*) FROM Vehicles) AS total_vehicles";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("total_orders"));
                stats.put("pendingOrders", rs.getInt("pending_orders"));
                stats.put("inProgressOrders", rs.getInt("in_progress_orders"));
                stats.put("completedOrders", rs.getInt("completed_orders"));
                stats.put("paidOrders", rs.getInt("paid_orders"));
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                stats.put("totalCustomers", rs.getInt("total_customers"));
                stats.put("totalVehicles", rs.getInt("total_vehicles"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<RepairOrder> getRecentOrders(int limit) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT TOP (?) ro.*, v.license_plate, v.brand, v.model, "
                   + "cu.full_name AS customer_name, cu.phone AS customer_phone, "
                   + "tu.full_name AS technician_name "
                   + "FROM RepairOrders ro "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "LEFT JOIN Users tu ON ro.technician_id = tu.user_id "
                   + "ORDER BY ro.order_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RepairOrder ro = new RepairOrder();
                    ro.setOrderId(rs.getInt("order_id"));
                    ro.setOrderCode(rs.getString("order_code"));
                    ro.setLicensePlate(rs.getString("license_plate"));
                    ro.setVehicleInfo(rs.getString("brand") + " " + rs.getString("model"));
                    ro.setCustomerName(rs.getString("customer_name"));
                    ro.setCustomerPhone(rs.getString("customer_phone"));
                    ro.setTechnicianName(rs.getString("technician_name"));
                    ro.setReceiveDate(rs.getTimestamp("receive_date"));
                    ro.setStatus(rs.getString("status"));
                    ro.setTotalAmount(rs.getBigDecimal("total_amount"));
                    list.add(ro);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SparePart> getLowStockParts(int threshold) {
        List<SparePart> list = new ArrayList<>();
        String sql = "SELECT * FROM SpareParts WHERE stock_quantity <= ? AND is_active = 1 ORDER BY stock_quantity ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SparePart p = new SparePart();
                    p.setPartId(rs.getInt("part_id"));
                    p.setPartCode(rs.getString("part_code"));
                    p.setPartName(rs.getString("part_name"));
                    p.setCategory(rs.getString("category"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setUnit(rs.getString("unit"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

