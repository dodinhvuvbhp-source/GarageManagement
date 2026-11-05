package com.garage.controller;

import com.garage.dao.PartDAO;
import com.garage.model.SparePart;
import com.garage.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "PartServlet", urlPatterns = {"/parts"})
public class PartServlet extends HttpServlet {

    private final PartDAO partDAO = new PartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        List<SparePart> list;
        if ((keyword != null && !keyword.trim().isEmpty()) || (category != null && !category.isEmpty())) {
            list = partDAO.searchParts(keyword, category);
        } else {
            list = partDAO.getAllParts(false);
        }

        request.setAttribute("parts", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.getRequestDispatcher("/parts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/parts?error=PermissionDenied");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String code = request.getParameter("partCode");
            String name = request.getParameter("partName");
            String category = request.getParameter("category");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stockQuantity"));
            String unit = request.getParameter("unit");
            int warranty = Integer.parseInt(request.getParameter("warrantyMonths"));

            SparePart p = new SparePart();
            p.setPartCode(code.trim().toUpperCase());
            p.setPartName(name.trim());
            p.setCategory(category);
            p.setPrice(price);
            p.setStockQuantity(stock);
            p.setUnit(unit.trim());
            p.setWarrantyMonths(warranty);
            p.setActive(true);

            partDAO.addPart(p);
            request.getSession().setAttribute("flashSuccess", "Thêm phụ tùng mới thành công!");

        } else if ("updateStock".equals(action)) {
            int partId = Integer.parseInt(request.getParameter("partId"));
            int amount = Integer.parseInt(request.getParameter("stockAmount")); // Có thể âm hoặc dương
            partDAO.updateStock(partId, amount);
            request.getSession().setAttribute("flashSuccess", "Đã cập nhật số lượng tồn kho!");

        } else if ("delete".equals(action)) {
            int partId = Integer.parseInt(request.getParameter("partId"));
            partDAO.deletePart(partId);
            request.getSession().setAttribute("flashSuccess", "Đã ngừng kinh doanh phụ tùng này!");
        }

        response.sendRedirect(request.getContextPath() + "/parts");
    }
}
