package com.garage.tag;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

public class StatusBadgeTag extends SimpleTagSupport {

    private String status;

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        if (status == null) {
            status = "";
        }

        String badgeHtml;
        switch (status.toUpperCase()) {
            case "RECEIVED":
                badgeHtml = "<span class=\"badge bg-secondary\"><i class=\"bi bi-inbox me-1\"></i>Tiếp nhận</span>";
                break;
            case "IN_PROGRESS":
                badgeHtml = "<span class=\"badge bg-primary\"><i class=\"bi bi-gear-wide-connected me-1\"></i>Đang sửa chữa</span>";
                break;
            case "COMPLETED":
                badgeHtml = "<span class=\"badge bg-success\"><i class=\"bi bi-check-circle me-1\"></i>Hoàn thành</span>";
                break;
            case "DELIVERED":
                badgeHtml = "<span class=\"badge bg-dark\"><i class=\"bi bi-truck me-1\"></i>Đã giao xe</span>";
                break;
            case "CANCELLED":
                badgeHtml = "<span class=\"badge bg-danger\"><i class=\"bi bi-x-circle me-1\"></i>Đã hủy</span>";
                break;
            case "PAID":
                badgeHtml = "<span class=\"badge bg-success\"><i class=\"bi bi-check-all me-1\"></i>Đã thanh toán</span>";
                break;
            case "UNPAID":
                badgeHtml = "<span class=\"badge bg-warning text-dark\"><i class=\"bi bi-hourglass-split me-1\"></i>Chưa thanh toán</span>";
                break;
            default:
                badgeHtml = "<span class=\"badge bg-light text-dark\">" + status + "</span>";
                break;
        }

        out.write(badgeHtml);
    }
}
