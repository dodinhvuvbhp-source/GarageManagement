package com.garage.controller.payment;

import com.garage.dao.InvoiceDAO;
import com.garage.model.Invoice;
import com.garage.model.PaymentTransaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.*;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // Tính lại chữ ký kiểm tra tính toàn vẹn
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        String signValue = VNPayConfig.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        boolean checkSignature = signValue.equalsIgnoreCase(vnp_SecureHash);

        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        String vnp_PayDate = request.getParameter("vnp_PayDate");

        boolean isSuccess = false;
        String message;
        Invoice invoice = null;

        if (checkSignature) {
            if ("00".equals(vnp_ResponseCode)) {
                isSuccess = true;
                message = "Giao dịch thanh toán qua cổng VNPay thành công!";

                // vnp_TxnRef dạng INV-20261104-001_123456
                if (vnp_TxnRef != null && vnp_TxnRef.contains("_")) {
                    String invCode = vnp_TxnRef.substring(0, vnp_TxnRef.lastIndexOf("_"));
                    for (Invoice inv : invoiceDAO.getAllInvoices()) {
                        if (inv.getInvoiceCode().equalsIgnoreCase(invCode)) {
                            invoice = inv;
                            break;
                        }
                    }
                }

                if (invoice != null) {
                    // Cập nhật trạng thái hóa đơn sang PAID
                    invoiceDAO.updatePaymentStatus(invoice.getInvoiceId(), "PAID", "VNPAY", new Timestamp(System.currentTimeMillis()));

                    // Ghi nhận nhật ký giao dịch
                    PaymentTransaction trans = new PaymentTransaction();
                    trans.setInvoiceId(invoice.getInvoiceId());
                    trans.setVnpTxnRef(vnp_TxnRef);
                    trans.setVnpTransactionNo(vnp_TransactionNo);
                    trans.setVnpAmount(new BigDecimal(vnp_Amount).divide(new BigDecimal(100)));
                    trans.setVnpBankCode(vnp_BankCode);
                    trans.setVnpResponseCode(vnp_ResponseCode);
                    trans.setVnpPayDate(vnp_PayDate);
                    trans.setStatus("SUCCESS");
                    invoiceDAO.savePaymentTransaction(trans);
                }
            } else {
                message = "Giao dịch không thành công hoặc người dùng đã hủy thanh toán (Mã phản hồi: " + vnp_ResponseCode + ").";
            }
        } else {
            message = "Chữ ký số không hợp lệ (Checksum failed)!";
        }

        request.setAttribute("isSuccess", isSuccess);
        request.setAttribute("message", message);
        request.setAttribute("vnp_TxnRef", vnp_TxnRef);
        request.setAttribute("vnp_Amount", (vnp_Amount != null) ? new BigDecimal(vnp_Amount).divide(new BigDecimal(100)) : BigDecimal.ZERO);
        request.setAttribute("vnp_TransactionNo", vnp_TransactionNo);
        request.setAttribute("vnp_BankCode", vnp_BankCode);
        request.setAttribute("vnp_PayDate", vnp_PayDate);
        request.setAttribute("invoice", invoice);

        request.getRequestDispatcher("/payment-result.jsp").forward(request, response);
    }
}
