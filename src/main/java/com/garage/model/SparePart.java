package com.garage.model;

import java.math.BigDecimal;

public class SparePart {
    private int partId;
    private String partCode;
    private String partName;
    private String category;
    private BigDecimal price;
    private int stockQuantity;
    private String unit;
    private int warrantyMonths;
    private boolean isActive;

    public SparePart() {
    }

    public SparePart(int partId, String partCode, String partName, String category, BigDecimal price, int stockQuantity, String unit, int warrantyMonths, boolean isActive) {
        this.partId = partId;
        this.partCode = partCode;
        this.partName = partName;
        this.category = category;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.unit = unit;
        this.warrantyMonths = warrantyMonths;
        this.isActive = isActive;
    }

    public int getPartId() {
        return partId;
    }

    public void setPartId(int partId) {
        this.partId = partId;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getPartName() {
        return partName;
    }

    public void setPartName(String partName) {
        this.partName = partName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}

