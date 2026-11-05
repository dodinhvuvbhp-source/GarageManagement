package com.garage.dao;

import com.garage.context.DBContext;
import com.garage.model.Vehicle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT v.*, u.full_name AS customer_name, u.phone AS customer_phone "
                   + "FROM Vehicles v "
                   + "JOIN Users u ON v.customer_id = u.user_id "
                   + "ORDER BY v.vehicle_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToVehicle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Vehicle> getVehiclesByCustomer(int customerId) {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT v.*, u.full_name AS customer_name, u.phone AS customer_phone "
                   + "FROM Vehicles v "
                   + "JOIN Users u ON v.customer_id = u.user_id "
                   + "WHERE v.customer_id = ? "
                   + "ORDER BY v.vehicle_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToVehicle(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Vehicle getVehicleById(int vehicleId) {
        String sql = "SELECT v.*, u.full_name AS customer_name, u.phone AS customer_phone "
                   + "FROM Vehicles v "
                   + "JOIN Users u ON v.customer_id = u.user_id "
                   + "WHERE v.vehicle_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVehicle(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Vehicle getVehicleByLicensePlate(String licensePlate) {
        String sql = "SELECT v.*, u.full_name AS customer_name, u.phone AS customer_phone "
                   + "FROM Vehicles v "
                   + "JOIN Users u ON v.customer_id = u.user_id "
                   + "WHERE v.license_plate = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, licensePlate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVehicle(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addVehicle(Vehicle v) {
        String sql = "INSERT INTO Vehicles (license_plate, customer_id, vehicle_type, brand, model, color, manufacture_year) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getLicensePlate());
            ps.setInt(2, v.getCustomerId());
            ps.setString(3, v.getVehicleType());
            ps.setString(4, v.getBrand());
            ps.setString(5, v.getModel());
            ps.setString(6, v.getColor());
            ps.setInt(7, v.getManufactureYear());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateVehicle(Vehicle v) {
        String sql = "UPDATE Vehicles SET license_plate = ?, vehicle_type = ?, brand = ?, model = ?, color = ?, manufacture_year = ? "
                   + "WHERE vehicle_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getLicensePlate());
            ps.setString(2, v.getVehicleType());
            ps.setString(3, v.getBrand());
            ps.setString(4, v.getModel());
            ps.setString(5, v.getColor());
            ps.setInt(6, v.getManufactureYear());
            ps.setInt(7, v.getVehicleId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteVehicle(int vehicleId) {
        String sql = "DELETE FROM Vehicles WHERE vehicle_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Vehicle mapResultSetToVehicle(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setVehicleId(rs.getInt("vehicle_id"));
        v.setLicensePlate(rs.getString("license_plate"));
        v.setCustomerId(rs.getInt("customer_id"));
        v.setCustomerName(rs.getString("customer_name"));
        v.setCustomerPhone(rs.getString("customer_phone"));
        v.setVehicleType(rs.getString("vehicle_type"));
        v.setBrand(rs.getString("brand"));
        v.setModel(rs.getString("model"));
        v.setColor(rs.getString("color"));
        v.setManufactureYear(rs.getInt("manufacture_year"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }
}

