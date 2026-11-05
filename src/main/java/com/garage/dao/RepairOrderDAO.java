package com.garage.dao;

import com.garage.context.DBContext;
import com.garage.model.RepairOrder;
import com.garage.model.RepairOrderPart;
import com.garage.model.RepairOrderService;

import java.math.BigDecimal;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class RepairOrderDAO {

    public List<RepairOrder> getAllOrders() {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, v.license_plate, v.brand, v.model, "
                   + "cu.full_name AS customer_name, cu.phone AS customer_phone, "
                   + "tu.full_name AS technician_name "
                   + "FROM RepairOrders ro "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "LEFT JOIN Users tu ON ro.technician_id = tu.user_id "
                   + "ORDER BY ro.order_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RepairOrder> getOrdersByCustomer(int customerId) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, v.license_plate, v.brand, v.model, "
                   + "cu.full_name AS customer_name, cu.phone AS customer_phone, "
                   + "tu.full_name AS technician_name "
                   + "FROM RepairOrders ro "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "LEFT JOIN Users tu ON ro.technician_id = tu.user_id "
                   + "WHERE ro.customer_id = ? "
                   + "ORDER BY ro.order_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RepairOrder> getOrdersByTechnician(int technicianId) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = "SELECT ro.*, v.license_plate, v.brand, v.model, "
                   + "cu.full_name AS customer_name, cu.phone AS customer_phone, "
                   + "tu.full_name AS technician_name "
                   + "FROM RepairOrders ro "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "LEFT JOIN Users tu ON ro.technician_id = tu.user_id "
                   + "WHERE ro.technician_id = ? "
                   + "ORDER BY ro.order_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public RepairOrder getOrderById(int orderId) {
        String sql = "SELECT ro.*, v.license_plate, v.brand, v.model, "
                   + "cu.full_name AS customer_name, cu.phone AS customer_phone, "
                   + "tu.full_name AS technician_name "
                   + "FROM RepairOrders ro "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "LEFT JOIN Users tu ON ro.technician_id = tu.user_id "
                   + "WHERE ro.order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RepairOrder order = mapResultSetToOrder(rs);
                    order.setServices(getOrderServices(orderId));
                    order.setParts(getOrderParts(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createOrder(RepairOrder order) {
        String sql = "INSERT INTO RepairOrders (order_code, vehicle_id, customer_id, technician_id, receive_date, problem_description, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Tự sinh mã phiếu RO-yyyyMMdd-XXXX
            String code = "RO-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + "-" + (System.currentTimeMillis() % 10000);
            ps.setString(1, code);
            ps.setInt(2, order.getVehicleId());
            ps.setInt(3, order.getCustomerId());
            if (order.getTechnicianId() != null && order.getTechnicianId() > 0) {
                ps.setInt(4, order.getTechnicianId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (order.getReceiveDate() != null) {
                ps.setTimestamp(5, order.getReceiveDate());
            } else {
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            }
            ps.setString(6, order.getProblemDescription());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE RepairOrders SET status = ?, "
                   + "completed_date = CASE WHEN ? IN ('COMPLETED', 'PAID') THEN GETDATE() ELSE completed_date END "
                   + "WHERE order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignTechnician(int orderId, int technicianId) {
        String sql = "UPDATE RepairOrders SET technician_id = ?, "
                   + "status = CASE WHEN status = 'PENDING' THEN 'IN_PROGRESS' ELSE status END "
                   + "WHERE order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDiagnosis(int orderId, String diagnosis) {
        return updateDiagnosis(orderId, diagnosis, null);
    }

    public boolean updateDiagnosis(int orderId, String diagnosis, Integer technicianId) {
        String sql = "UPDATE RepairOrders SET diagnosis_notes = ?, "
                   + "technician_id = COALESCE(?, technician_id), "
                   + "status = CASE WHEN status = 'PENDING' THEN 'IN_PROGRESS' ELSE status END "
                   + "WHERE order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, diagnosis);
            if (technicianId != null && technicianId > 0) {
                ps.setInt(2, technicianId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addServiceToOrder(int orderId, int serviceId, BigDecimal price, String notes) {
        String sql = "INSERT INTO RepairOrderServices (order_id, service_id, price, notes) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, serviceId);
            ps.setBigDecimal(3, price);
            ps.setString(4, notes);
            boolean inserted = ps.executeUpdate() > 0;
            if (inserted) {
                recalculateOrderTotal(orderId);
            }
            return inserted;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeServiceFromOrder(int id, int orderId) {
        String sql = "DELETE FROM RepairOrderServices WHERE id = ? AND order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, orderId);
            boolean deleted = ps.executeUpdate() > 0;
            if (deleted) {
                recalculateOrderTotal(orderId);
            }
            return deleted;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addPartToOrder(int orderId, int partId, int quantity, BigDecimal unitPrice) {
        // Trừ tồn kho trước
        PartDAO partDAO = new PartDAO();
        if (!partDAO.decreaseStock(partId, quantity)) {
            return false;
        }

        BigDecimal totalPrice = unitPrice.multiply(new BigDecimal(quantity));
        String sql = "INSERT INTO RepairOrderParts (order_id, part_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, partId);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, unitPrice);
            ps.setBigDecimal(5, totalPrice);
            boolean inserted = ps.executeUpdate() > 0;
            if (inserted) {
                recalculateOrderTotal(orderId);
            }
            return inserted;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removePartFromOrder(int id, int orderId, int partId, int quantity) {
        // Hoàn lại tồn kho
        new PartDAO().increaseStock(partId, quantity);

        String sql = "DELETE FROM RepairOrderParts WHERE id = ? AND order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, orderId);
            boolean deleted = ps.executeUpdate() > 0;
            if (deleted) {
                recalculateOrderTotal(orderId);
            }
            return deleted;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void recalculateOrderTotal(int orderId) {
        String sql = "UPDATE RepairOrders SET "
                   + "total_service_cost = ISNULL((SELECT SUM(price) FROM RepairOrderServices WHERE order_id = ?), 0), "
                   + "total_part_cost = ISNULL((SELECT SUM(total_price) FROM RepairOrderParts WHERE order_id = ?), 0), "
                   + "total_amount = ISNULL((SELECT SUM(price) FROM RepairOrderServices WHERE order_id = ?), 0) + "
                   + "               ISNULL((SELECT SUM(total_price) FROM RepairOrderParts WHERE order_id = ?), 0) "
                   + "WHERE order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, orderId);
            ps.setInt(3, orderId);
            ps.setInt(4, orderId);
            ps.setInt(5, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<RepairOrderService> getOrderServices(int orderId) {
        List<RepairOrderService> list = new ArrayList<>();
        String sql = "SELECT ros.*, s.service_name "
                   + "FROM RepairOrderServices ros "
                   + "JOIN Services s ON ros.service_id = s.service_id "
                   + "WHERE ros.order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RepairOrderService ros = new RepairOrderService();
                    ros.setId(rs.getInt("id"));
                    ros.setOrderId(rs.getInt("order_id"));
                    ros.setServiceId(rs.getInt("service_id"));
                    ros.setServiceName(rs.getString("service_name"));
                    ros.setPrice(rs.getBigDecimal("price"));
                    ros.setNotes(rs.getString("notes"));
                    list.add(ros);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RepairOrderPart> getOrderParts(int orderId) {
        List<RepairOrderPart> list = new ArrayList<>();
        String sql = "SELECT rop.*, sp.part_code, sp.part_name, sp.unit "
                   + "FROM RepairOrderParts rop "
                   + "JOIN SpareParts sp ON rop.part_id = sp.part_id "
                   + "WHERE rop.order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RepairOrderPart rop = new RepairOrderPart();
                    rop.setId(rs.getInt("id"));
                    rop.setOrderId(rs.getInt("order_id"));
                    rop.setPartId(rs.getInt("part_id"));
                    rop.setPartCode(rs.getString("part_code"));
                    rop.setPartName(rs.getString("part_name"));
                    rop.setUnit(rs.getString("unit"));
                    rop.setQuantity(rs.getInt("quantity"));
                    rop.setUnitPrice(rs.getBigDecimal("unit_price"));
                    rop.setTotalPrice(rs.getBigDecimal("total_price"));
                    list.add(rop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private RepairOrder mapResultSetToOrder(ResultSet rs) throws SQLException {
        RepairOrder ro = new RepairOrder();
        ro.setOrderId(rs.getInt("order_id"));
        ro.setOrderCode(rs.getString("order_code"));
        ro.setVehicleId(rs.getInt("vehicle_id"));
        ro.setLicensePlate(rs.getString("license_plate"));
        ro.setVehicleInfo(rs.getString("brand") + " " + rs.getString("model"));
        ro.setCustomerId(rs.getInt("customer_id"));
        ro.setCustomerName(rs.getString("customer_name"));
        ro.setCustomerPhone(rs.getString("customer_phone"));
        
        int techId = rs.getInt("technician_id");
        if (!rs.wasNull()) {
            ro.setTechnicianId(techId);
        }
        ro.setTechnicianName(rs.getString("technician_name"));
        ro.setReceiveDate(rs.getTimestamp("receive_date"));
        ro.setCompletedDate(rs.getTimestamp("completed_date"));
        ro.setProblemDescription(rs.getString("problem_description"));
        ro.setDiagnosisNotes(rs.getString("diagnosis_notes"));
        ro.setStatus(rs.getString("status"));
        ro.setTotalServiceCost(rs.getBigDecimal("total_service_cost"));
        ro.setTotalPartCost(rs.getBigDecimal("total_part_cost"));
        ro.setTotalAmount(rs.getBigDecimal("total_amount"));
        return ro;
    }
}
