package com.garage.dao;

import com.garage.context.DBContext;
import com.garage.model.SparePart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PartDAO {

    public List<SparePart> getAllParts(boolean onlyActive) {
        List<SparePart> list = new ArrayList<>();
        String sql = "SELECT * FROM SpareParts "
                   + (onlyActive ? "WHERE is_active = 1 " : "")
                   + "ORDER BY category ASC, part_name ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToPart(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public SparePart getPartById(int partId) {
        String sql = "SELECT * FROM SpareParts WHERE part_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, partId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPart(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addPart(SparePart p) {
        String sql = "INSERT INTO SpareParts (part_code, part_name, category, price, stock_quantity, unit, warranty_months, is_active) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getPartCode());
            ps.setString(2, p.getPartName());
            ps.setString(3, p.getCategory());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStockQuantity());
            ps.setString(6, p.getUnit());
            ps.setInt(7, p.getWarrantyMonths());
            ps.setBoolean(8, p.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePart(SparePart p) {
        String sql = "UPDATE SpareParts SET part_code = ?, part_name = ?, category = ?, price = ?, "
                   + "stock_quantity = ?, unit = ?, warranty_months = ?, is_active = ? WHERE part_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getPartCode());
            ps.setString(2, p.getPartName());
            ps.setString(3, p.getCategory());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStockQuantity());
            ps.setString(6, p.getUnit());
            ps.setInt(7, p.getWarrantyMonths());
            ps.setBoolean(8, p.isActive());
            ps.setInt(9, p.getPartId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStock(int partId, int quantityChange) {
        String sql = "UPDATE SpareParts SET stock_quantity = stock_quantity + ? WHERE part_id = ? AND stock_quantity + ? >= 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityChange);
            ps.setInt(2, partId);
            ps.setInt(3, quantityChange);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper giảm tồn kho
    public boolean decreaseStock(int partId, int quantity) {
        return updateStock(partId, -quantity);
    }

    // Helper tăng / hoàn lại tồn kho
    public boolean increaseStock(int partId, int quantity) {
        return updateStock(partId, quantity);
    }

    public boolean deletePart(int partId) {
        // Soft delete
        String sql = "UPDATE SpareParts SET is_active = 0 WHERE part_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, partId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<SparePart> searchParts(String keyword, String category) {
        List<SparePart> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM SpareParts WHERE is_active = 1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (part_name LIKE ? OR part_code LIKE ?) ");
            String pat = "%" + keyword.trim() + "%";
            params.add(pat);
            params.add(pat);
        }
        if (category != null && !category.trim().isEmpty() && !category.equals("ALL")) {
            sql.append("AND category = ? ");
            params.add(category.trim());
        }
        sql.append("ORDER BY part_name ASC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPart(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private SparePart mapResultSetToPart(ResultSet rs) throws SQLException {
        SparePart p = new SparePart();
        p.setPartId(rs.getInt("part_id"));
        p.setPartCode(rs.getString("part_code"));
        p.setPartName(rs.getString("part_name"));
        p.setCategory(rs.getString("category"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setUnit(rs.getString("unit"));
        p.setWarrantyMonths(rs.getInt("warranty_months"));
        p.setActive(rs.getBoolean("is_active"));
        return p;
    }
}
