package com.garage.dao;

import com.garage.context.DBContext;
import com.garage.model.ServiceItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<ServiceItem> getAllServices(boolean onlyActive) {
        List<ServiceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM Services "
                   + (onlyActive ? "WHERE is_active = 1 " : "")
                   + "ORDER BY service_name ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ServiceItem getServiceById(int serviceId) {
        String sql = "SELECT * FROM Services WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToService(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addService(ServiceItem s) {
        String sql = "INSERT INTO Services (service_name, description, price, estimated_duration, is_active) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getDescription());
            ps.setBigDecimal(3, s.getPrice());
            ps.setInt(4, s.getEstimatedDuration());
            ps.setBoolean(5, s.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateService(ServiceItem s) {
        String sql = "UPDATE Services SET service_name = ?, description = ?, price = ?, estimated_duration = ?, is_active = ? "
                   + "WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getDescription());
            ps.setBigDecimal(3, s.getPrice());
            ps.setInt(4, s.getEstimatedDuration());
            ps.setBoolean(5, s.isActive());
            ps.setInt(6, s.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteService(int serviceId) {
        // Soft delete: chuyá»ƒn is_active = 0 Ä‘á»ƒ báº£o toÃ n lá»‹ch sá»­ hÃ³a Ä‘Æ¡n
        String sql = "UPDATE Services SET is_active = 0 WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ServiceItem> searchServices(String keyword) {
        List<ServiceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM Services WHERE is_active = 1 AND (service_name LIKE ? OR description LIKE ?) ORDER BY service_name ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private ServiceItem mapResultSetToService(ResultSet rs) throws SQLException {
        ServiceItem s = new ServiceItem();
        s.setServiceId(rs.getInt("service_id"));
        s.setServiceName(rs.getString("service_name"));
        s.setDescription(rs.getString("description"));
        s.setPrice(rs.getBigDecimal("price"));
        s.setEstimatedDuration(rs.getInt("estimated_duration"));
        s.setActive(rs.getBoolean("is_active"));
        return s;
    }
}

