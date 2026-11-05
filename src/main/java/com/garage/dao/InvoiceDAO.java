package com.garage.dao;

import com.garage.context.DBContext;
import com.garage.model.Invoice;
import com.garage.model.PaymentTransaction;
import com.garage.model.RepairOrder;

import java.math.BigDecimal;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class InvoiceDAO {

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT inv.*, ro.order_code, v.license_plate, cu.full_name AS customer_name, cu.phone AS customer_phone "
                   + "FROM Invoices inv "
                   + "JOIN RepairOrders ro ON inv.order_id = ro.order_id "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "ORDER BY inv.invoice_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoicesByCustomer(int customerId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT inv.*, ro.order_code, v.license_plate, cu.full_name AS customer_name, cu.phone AS customer_phone "
                   + "FROM Invoices inv "
                   + "JOIN RepairOrders ro ON inv.order_id = ro.order_id "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "WHERE ro.customer_id = ? "
                   + "ORDER BY inv.invoice_id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT inv.*, ro.order_code, v.license_plate, cu.full_name AS customer_name, cu.phone AS customer_phone "
                   + "FROM Invoices inv "
                   + "JOIN RepairOrders ro ON inv.order_id = ro.order_id "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "WHERE inv.invoice_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Invoice getInvoiceByOrderId(int orderId) {
        String sql = "SELECT inv.*, ro.order_code, v.license_plate, cu.full_name AS customer_name, cu.phone AS customer_phone "
                   + "FROM Invoices inv "
                   + "JOIN RepairOrders ro ON inv.order_id = ro.order_id "
                   + "JOIN Vehicles v ON ro.vehicle_id = v.vehicle_id "
                   + "JOIN Users cu ON ro.customer_id = cu.user_id "
                   + "WHERE inv.order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Invoice getOrCreateInvoiceForOrder(int orderId) {
        Invoice existing = getInvoiceByOrderId(orderId);
        if (existing != null) {
            // Cáº­p nháº­t láº¡i sá»‘ tiá»n náº¿u order cÃ³ thay Ä‘á»•i
            RepairOrder ro = new RepairOrderDAO().getOrderById(orderId);
            if (ro != null && existing.getPaymentStatus().equals("UNPAID")) {
                updateInvoiceAmounts(existing.getInvoiceId(), ro.getTotalAmount(), ro.getTotalAmount());
                existing.setSubtotal(ro.getTotalAmount());
                existing.setTotalAmount(ro.getTotalAmount());
            }
            return existing;
        }

        // Táº¡o má»›i hÃ³a Ä‘Æ¡n tá»« RepairOrder
        RepairOrder ro = new RepairOrderDAO().getOrderById(orderId);
        if (ro == null) return null;

        String code = "INV-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + "-" + (System.currentTimeMillis() % 10000);
        String sql = "INSERT INTO Invoices (invoice_code, order_id, subtotal, discount, tax, total_amount, payment_status) "
                   + "VALUES (?, ?, ?, 0, 0, ?, 'UNPAID')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, code);
            ps.setInt(2, orderId);
            ps.setBigDecimal(3, ro.getTotalAmount());
            ps.setBigDecimal(4, ro.getTotalAmount());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int invId = rs.getInt(1);
                        return getInvoiceById(invId);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void updateInvoiceAmounts(int invoiceId, BigDecimal subtotal, BigDecimal totalAmount) {
        String sql = "UPDATE Invoices SET subtotal = ?, total_amount = ? WHERE invoice_id = ? AND payment_status = 'UNPAID'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, subtotal);
            ps.setBigDecimal(2, totalAmount);
            ps.setInt(3, invoiceId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updatePaymentStatus(int invoiceId, String status, String method, Timestamp paidDate) {
        String sql = "UPDATE Invoices SET payment_status = ?, payment_method = ?, paid_date = ? WHERE invoice_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setTimestamp(3, paidDate);
            ps.setInt(4, invoiceId);
            boolean ok = ps.executeUpdate() > 0;
            if (ok && "PAID".equalsIgnoreCase(status)) {
                // Äá»“ng thá»i cáº­p nháº­t tráº¡ng thÃ¡i Ä‘Æ¡n sá»­a xe thÃ nh PAID
                Invoice inv = getInvoiceById(invoiceId);
                if (inv != null) {
                    new RepairOrderDAO().updateStatus(inv.getOrderId(), "PAID");
                }
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean savePaymentTransaction(PaymentTransaction trans) {
        String sql = "INSERT INTO PaymentTransactions (invoice_id, vnp_txn_ref, vnp_transaction_no, vnp_amount, "
                   + "vnp_bank_code, vnp_response_code, vnp_pay_date, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trans.getInvoiceId());
            ps.setString(2, trans.getVnpTxnRef());
            ps.setString(3, trans.getVnpTransactionNo());
            ps.setBigDecimal(4, trans.getVnpAmount());
            ps.setString(5, trans.getVnpBankCode());
            ps.setString(6, trans.getVnpResponseCode());
            ps.setString(7, trans.getVnpPayDate());
            ps.setString(8, trans.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Invoice mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();
        inv.setInvoiceId(rs.getInt("invoice_id"));
        inv.setInvoiceCode(rs.getString("invoice_code"));
        inv.setOrderId(rs.getInt("order_id"));
        inv.setOrderCode(rs.getString("order_code"));
        inv.setLicensePlate(rs.getString("license_plate"));
        inv.setCustomerName(rs.getString("customer_name"));
        inv.setCustomerPhone(rs.getString("customer_phone"));
        inv.setCreatedDate(rs.getTimestamp("created_date"));
        inv.setSubtotal(rs.getBigDecimal("subtotal"));
        inv.setDiscount(rs.getBigDecimal("discount"));
        inv.setTax(rs.getBigDecimal("tax"));
        inv.setTotalAmount(rs.getBigDecimal("total_amount"));
        inv.setPaymentStatus(rs.getString("payment_status"));
        inv.setPaymentMethod(rs.getString("payment_method"));
        inv.setPaidDate(rs.getTimestamp("paid_date"));
        return inv;
    }
}

